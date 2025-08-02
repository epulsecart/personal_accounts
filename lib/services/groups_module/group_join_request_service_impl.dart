// lib/services/groups_module/group_join_request_service_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/groups_module/group_join_request_model.dart';
import '../../data/offline_mutation.dart';
import 'group_join_request_service.dart';

class GroupJoinRequestServiceImpl implements GroupJoinRequestService {
  static const _kDomain = 'group_join_requests'; // still used for your offline queue’s “domain” field

  final Box<GroupJoinRequestModel> _box;
  final Box<OfflineMutation>       _mutBox;
  final FirebaseFirestore          _firestore;

  GroupJoinRequestServiceImpl({
    required Box<GroupJoinRequestModel> box,
    required Box<OfflineMutation> mutBox,
    FirebaseFirestore? firestore,
  })  : _box       = box,
        _mutBox    = mutBox,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Helper to get the Firestore sub-collection under a specific group:
  CollectionReference<Map<String, dynamic>> _joinCol(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('joinRequests');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 1) Create / Approve / Reject / Delete

  @override
  Future<void> createRequest(GroupJoinRequestModel req) async {
    await _box.put(req.id, req);

    // enqueue mutation using the sub-collection path as the “domain”
    final mut = OfflineMutation(
      collection:   'groups/${req.groupId}/joinRequests',
      docId: req.id,
      operation: MutationOp.create,
      data:      req.toMap(),
    );
    await _mutBox.add(mut);
  }

  @override
  Future<void> approveRequest(GroupJoinRequestModel req) async {
    final approved = req.copyWith(
      status:      JoinStatus.approved,
      approverId:  req.approverId,       // caller must set this on `req`
      respondedAt: DateTime.now(),
    );
    await _box.put(approved.id, approved);

    final mut = OfflineMutation(
      collection:   'groups/${approved.groupId}/joinRequests',
      docId: approved.id,
      operation: MutationOp.update,
      data:      approved.toMap(),
    );
    await _mutBox.add(mut);

    // ← remember: you still need to add the new member ID into the group’s memberIds via your GroupService elsewhere
  }

  @override
  Future<void> rejectRequest(GroupJoinRequestModel req) async {
    final rejected = req.copyWith(
      status:      JoinStatus.rejected,
      approverId:  req.approverId,
      respondedAt: DateTime.now(),
    );
    await _box.put(rejected.id, rejected);

    final mut = OfflineMutation(
      collection:   'groups/${rejected.groupId}/joinRequests',
      docId: rejected.id,
      operation: MutationOp.update,
      data:      rejected.toMap(),
    );
    await _mutBox.add(mut);
  }

  @override
  Future<void> deleteRequest(String id) async {
    final req = _box.get(id);
    if (req != null) {
      await _box.delete(id);
      final mut = OfflineMutation(
        collection:   'groups/${req.groupId}/joinRequests',
        docId: id,
        operation: MutationOp.delete,
        data:      {},
      );
      await _mutBox.add(mut);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2) Local reads from Hive

  @override
  Future<List<GroupJoinRequestModel>> fetchAllForGroup(String groupId) async {
    return _box.values
        .where((r) => r.groupId == groupId)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  @override
  Stream<List<GroupJoinRequestModel>> watchAllForGroup(String groupId) {
    // emit initial + on any change
    return _box.watch().map((_) => _box.values
        .where((r) => r.groupId == groupId)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt)))
        .startWith(_box.values
        .where((r) => r.groupId == groupId)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt)));
  }

  @override
  Future<List<GroupJoinRequestModel>> fetchAllForInvitee(String userId) async {
    return _box.values
        .where((r) => r.requesterId == userId || r.requesterId /* or inviteeId */ == userId)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  @override
  Stream<List<GroupJoinRequestModel>> watchAllForInvitee(String userId) {
    return _box.watch().map((_) => _box.values
        .where((r) => r.requesterId == userId || r.requesterId /* or inviteeId */ == userId)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt)))
        .startWith(_box.values
        .where((r) => r.requesterId == userId || r.requesterId /* or inviteeId */ == userId)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt)));
  }

  @override
  Future<GroupJoinRequestModel?> getById(String id) async => _box.get(id);

  // ──────────────────────────────────────────────────────────────────────────
  // 3) Sync with Firestore (each group’s sub-collection)

  @override
  Future<void> initialSeed() async {
    if (_box.isNotEmpty) return;
    await syncDownstream();
  }

  @override
  Future<void> syncUpstream() async {
    for (final m in _mutBox.values.where((m) => m.docId.startsWith('groups/'))) {
      final parts = m.collection.split('/');
      // domain == "groups/{groupId}/joinRequests"
      final groupId = parts[1];
      final ref = _joinCol(groupId).doc(m.docId);
      try {
        switch (m.operation) {
          case MutationOp.create:
          case MutationOp.update:
            await ref.set(m.data!, SetOptions(merge: true));
            break;
          case MutationOp.delete:
            await ref.delete();
            break;
        }
        await m.delete();
      } catch (_) {
        // leave in queue
      }
    }
  }

  @override
  Future<void> syncDownstream() async {
    // pull _all_ joinRequests across every group
    final snap = await _firestore.collectionGroup('joinRequests').get();
    for (final doc in snap.docs) {
      final model = GroupJoinRequestModel.fromFirestore(doc);
      await _box.put(model.id, model);
    }
  }

  @override
  Future<void> synchronize() async {
    await syncUpstream();
    await syncDownstream();
  }
}
