// lib/services/groups_module/settlement_request_service_impl.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../data/groups_module/settlement_request_model.dart';
import '../../data/offline_mutation.dart';
import 'settlement_request_service.dart';

class SettlementRequestServiceImpl implements SettlementRequestService {
  /// we still use a base name for OfflineMutation.collection, but now
  /// it will be prefixed by "groups/{groupId}/"
  static const _base = 'settlementRequests';

  final Box<SettlementRequestModel> _box;
  final Box<OfflineMutation>        _queueBox;
  final FirebaseFirestore           _fs;

  SettlementRequestServiceImpl({
    required Box<SettlementRequestModel> box,
    required Box<OfflineMutation> queueBox,
    FirebaseFirestore? firestore,
  })  : _box      = box,
        _queueBox = queueBox,
        _fs       = firestore ?? FirebaseFirestore.instance;

  /// Sub-collection reference under a specific group:
  CollectionReference<Map<String, dynamic>> _col(String groupId) =>
      _fs.collection('groups').doc(groupId).collection(_base);

  // ──────────────────────────────────────────────────────────────────────────
  @override
  Future<void> createSettlementRequest(SettlementRequestModel req) async {
    // 1. local
    await _box.put(req.id, req);
    // 2. enqueue for remote
    final mut = OfflineMutation(
      collection:    'groups/${req.groupId}/$_base',
      docId:  req.id,
      operation: MutationOp.create,
      data:      req.toMap(),
    );
    await _queueBox.add(mut);
  }

  @override
  Future<void> markSettled({
    required String requestId,
    required DateTime settledAt,
  }) async {
    final existing = _box.get(requestId);
    if (existing == null) throw Exception('No such settlement request');
    final updated = existing.copyWith(
      settled:   true,
    );
    await _box.put(requestId, updated);

    final mut = OfflineMutation(
      collection:    'groups/${existing.groupId}/$_base',
      docId:  requestId,
      operation: MutationOp.update,
      data:      updated.toMap(),
    );
    await _queueBox.add(mut);
  }

  // ──────────────────────────────────────────────────────────────────────────
  @override
  Future<void> initialSeed() async {
    if (_box.isNotEmpty) return;
    // pull all settlementRequests under all groups:
    final snap = await _fs.collectionGroup(_base).get();
    for (final doc in snap.docs) {
      final model = SettlementRequestModel.fromFirestore(doc);
      await _box.put(model.id, model);
    }
  }

  @override
  Future<void> syncUpstream() async {
    for (final m in _queueBox.values.where((m) => m.collection.startsWith('groups/'))) {
      // domain == "groups/{groupId}/settlementRequests"
      final parts   = m.collection.split('/');
      final groupId = parts[1];
      final ref     = _col(groupId).doc(m.docId);

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
        // keep in queue for retry
      }
    }
  }

  @override
  Future<void> syncDownstream() async {
    final snap = await _fs.collectionGroup(_base).get();
    for (final doc in snap.docs) {
      final model = SettlementRequestModel.fromFirestore(doc);
      await _box.put(model.id, model);
    }
  }

  @override
  Future<void> synchronize() async {
    await syncUpstream();
    await syncDownstream();
  }

  // ──────────────────────────────────────────────────────────────────────────
  @override
  Future<List<SettlementRequestModel>> fetchAll() async {
    final list = _box.values.toList();
    list.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
    return list;
  }

  @override
  Stream<List<SettlementRequestModel>> watchAll() {
    final controller = StreamController<List<SettlementRequestModel>>();
    void emit() {
      controller.add(
          _box.values.toList()..sort((a, b) => b.requestedAt.compareTo(a.requestedAt))
      );
    }
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
