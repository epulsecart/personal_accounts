// lib/services/groups_module/group_txn_change_request_service_impl.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../data/groups_module/group_txn_change_request_model.dart';
import '../../data/offline_mutation.dart';
import 'group_txn_change_request_service.dart';

class GroupTxnChangeRequestServiceImpl
    implements GroupTxnChangeRequestService {
  static const _domain = 'group_txn_change_request';

  final String groupId;
  final String txnId;
  final Box<GroupTxnChangeRequestModel> _box;
  final Box<OfflineMutation>            _queueBox;
  final FirebaseFirestore                _fs;

  GroupTxnChangeRequestServiceImpl({
    required this.groupId,
    required this.txnId,
    required Box<GroupTxnChangeRequestModel> box,
    required Box<OfflineMutation> queueBox,
    FirebaseFirestore? firestore,
  })  : _box       = box,
        _queueBox  = queueBox,
        _fs        = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _fs
      .collection('groups')
      .doc(groupId)
      .collection('transactions')
      .doc(txnId)
      .collection('changeRequests');

  @override
  Future<void> requestChange(GroupTxnChangeRequestModel req) async {
    // 1) local
    await _box.put(req.id, req);
    // 2) enqueue for remote
    final m = OfflineMutation(
      collection:    _domain,
      docId:  req.id,
      operation: MutationOp.create,
      data:      req.toMap(),
    );
    await _queueBox.add(m);
  }

  @override
  Future<void> approveChange({
    required String requestId,
    required String approverId,
  }) async {
    final existing = _box.get(requestId);
    if (existing == null) throw Exception('No such request');
    final updated = existing.copyWith(
      status:     RequestStatus.approved,
      approvedBy: approverId,
      respondedAt: DateTime.now(),
    );
    await _box.put(requestId, updated);

    final m = OfflineMutation(
      collection:    _domain,
      docId:  requestId,
      operation: MutationOp.update,
      data:      updated.toMap(),
    );
    await _queueBox.add(m);
  }

  @override
  Future<void> rejectChange({
    required String requestId,
    required String approverId,
    String? reason,
  }) async {
    final existing = _box.get(requestId);
    if (existing == null) throw Exception('No such request');
    final updated = existing.copyWith(
      status:      RequestStatus.rejected,
      approvedBy:  approverId,
      respondedAt: DateTime.now(),
    );
    // if you want to store the reason, rebuild `copyWith` to accept it.
    await _box.put(requestId, updated);

    final m = OfflineMutation(
      collection:    _domain,
      docId:  requestId,
      operation: MutationOp.update,
      data:      updated.toMap(),
    );
    await _queueBox.add(m);
  }

  @override
  Future<void> initialSeed() async {
    if (_box.isNotEmpty) return;
    final snap = await _col.get();
    for (var doc in snap.docs) {
      final model = GroupTxnChangeRequestModel.fromFirestore(doc);
      await _box.put(model.id, model);
    }
  }

  @override
  Future<void> syncUpstream() async {
    for (var m in _queueBox.values
        .where((m) => m.collection == _domain)
        .toList()) {
      final ref = _col.doc(m.docId);
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
        await m.delete(); // remove from queue on success
      } catch (_) {
        // leave it for retry
      }
    }
  }

  @override
  Future<void> syncDownstream() async {
    final snap = await _col.get();
    for (var doc in snap.docs) {
      final model = GroupTxnChangeRequestModel.fromFirestore(doc);
      await _box.put(model.id, model);
    }
  }

  @override
  Future<void> synchronize() async {
    await syncUpstream();
    await syncDownstream();
  }

  @override
  Future<List<GroupTxnChangeRequestModel>> fetchAll() async {
    final list = _box.values.toList();
    list.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
    return list;
  }

  @override
  Stream<List<GroupTxnChangeRequestModel>> watchAll() {
    // emit initial + any changes
    final controller = StreamController<List<GroupTxnChangeRequestModel>>();
    void emit() => controller.add(_box.values
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt))
    );
    emit();
    final sub = _box.watch().listen((_) => emit());
    controller.onCancel = () => sub.cancel();
    return controller.stream;
  }

  @override
  Future<void> clearLocal() async {
    await _box.clear();
  }
}
