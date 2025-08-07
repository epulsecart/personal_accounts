// lib/services/groups/group_transaction_service_impl.dart

import 'dart:async';

import 'package:accounts/data/offline_mutation.dart';
import 'package:accounts/data/groups_module/group_transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user_module/transactions_service.dart';
import 'group_transaction_service.dart';

class GroupTransactionServiceImpl implements GroupTransactionService {
  static const _kLastPulledPrefix = 'group_txns_lastPulledAt_';

  final Box<GroupTransactionModel> _box;
  final Box<OfflineMutation>       _mutBox;
  final FirebaseFirestore          _firestore;
  final SharedPreferences          _prefs;

  GroupTransactionServiceImpl({
    required Box<GroupTransactionModel> box,
    required Box<OfflineMutation> mutBox,
    FirebaseFirestore? firestore,
    required SharedPreferences prefs,
  })  : _box        = box,
        _mutBox     = mutBox,
        _firestore  = firestore ?? FirebaseFirestore.instance,
        _prefs      = prefs;

  // ─ Local writes + enqueue for sync ───────────────────────────────────────
  @override
  Future<void> addTransaction(GroupTransactionModel txn) async {
    await _box.put(txn.id, txn);
    await _mutBox.add(OfflineMutation(
      collection:    'group_transactions',
      docId:  txn.id,
      operation: MutationOp.create,
      data:      txn.toMap(),
    ));
  }

  @override
  Future<void> approveTransaction(String txnId) async {
    final txn = _box.get(txnId);
    if (txn == null) throw Exception('Transaction not found');

    final updated = txn.copyWith(
      isApproved: true,
      updatedAt: DateTime.now(),
    );

    await _box.put(txnId, updated);

    final m = OfflineMutation.update(
      collection: 'group_transactions',
      docId: txnId,
      data: updated.toMap(),
    );
    await _mutBox.add(m);
  }


  // ─ Local reads from Hive ────────────────────────────────────────────────
  @override
  Future<List<GroupTransactionModel>> fetchAll(String groupId) async {
    return _box.values
        .where((t) => t.groupId == groupId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Stream<List<GroupTransactionModel>> watchAll(String groupId) {
    // start with current, then every change
    final ctrl = StreamController<List<GroupTransactionModel>>();
    ctrl.add(_box.values
        .where((t) => t.groupId == groupId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)));
    _box.watch().listen((_) {
      final list = _box.values
          .where((t) => t.groupId == groupId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      ctrl.add(list);
    });
    return ctrl.stream;
  }

  @override
  Future<List<GroupTransactionModel>> fetchByDateRange({
    required String groupId,
    required DateTime start,
    required DateTime end,
  }) async {
    final all = await fetchAll(groupId);
    return all.where((t) => !t.date.isBefore(start) && !t.date.isAfter(end)).toList();
  }

  @override
  Future<Summary> getSummary({
    required String groupId,
    required String userId,
    DateTime? start,
    DateTime? end,
  }) async {
    final list = (start == null && end == null)
        ? await fetchAll(groupId)
        : await fetchByDateRange(groupId: groupId, start: start!, end: end!);
    var exp = 0.0, inc = 0.0;
    for (var t in list) {
      if (t.fromUserId == userId) exp += t.amount;
      else inc += t.amount;
    }
    return Summary(totalExpense: exp, totalIncome: inc);
  }

  // ─ Live Firestore stream ────────────────────────────────────────────────
  @override
  Stream<List<GroupTransactionModel>> watchRemote(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
      final m = GroupTransactionModel.fromFirestore(d);
      return m;
    }).toList());
  }

  // ─ Sync with Firestore ─────────────────────────────────────────────────
  @override
  Future<void> syncUpstream() async {
    for (var m in _mutBox.values.toList()) {
      if (m.collection != 'group_transactions') continue;
      final data     = Map<String, dynamic>.from(m.data!);
      final groupId  = data['groupId'] as String;
      final ref = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('transactions')
          .doc(m.docId);
      try {
        switch (m.operation) {
          case MutationOp.create:
          case MutationOp.update:
            await ref.set(data, SetOptions(merge: true));
            break;
          case MutationOp.delete:
            await ref.delete();
            break;
        }
        await m.delete();
      } catch (_) {
        // leave for retry
      }
    }
  }

  @override
  Future<void> syncDownstream(String groupId) async {
    final key = '$_kLastPulledPrefix$groupId';
    final last = DateTime.tryParse(_prefs.getString(key) ?? '')
        ?? DateTime.fromMillisecondsSinceEpoch(0);

    final snap = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('transactions')
        .where('updatedAt', isGreaterThan: last)
        .orderBy('updatedAt')
        .get();

    for (var doc in snap.docs) {
      final txn = GroupTransactionModel.fromFirestore(doc);
      await _box.put(txn.id, txn);
    }
    await _prefs.setString(key, DateTime.now().toIso8601String());
  }

  @override
  Future<void> initialSeed(String groupId) async {
    if (_box.values.any((t) => t.groupId == groupId)) return;
    String? lastDocId;
    const batchSize = 100;
    Query<Map<String, dynamic>> query = _firestore
        .collection('groups')
        .doc(groupId)
        .collection('transactions')
        .orderBy('date')
        .limit(batchSize);

    while (true) {
      if (lastDocId != null) {
        final lastDoc = await _firestore
            .collection('groups')
            .doc(groupId)
            .collection('transactions')
            .doc(lastDocId)
            .get();
        query = query.startAfterDocument(lastDoc);
      }
      final snap = await query.get();
      if (snap.docs.isEmpty) break;
      for (var doc in snap.docs) {
        final txn = GroupTransactionModel.fromFirestore(doc);
        await _box.put(txn.id, txn);
      }
      lastDocId = snap.docs.last.id;
      if (snap.docs.length < batchSize) break;
    }
    await _prefs.setString(
      '$_kLastPulledPrefix$groupId',
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> synchronize(String groupId) async {
    await syncUpstream();
    await syncDownstream(groupId);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
    await _mutBox.clear();
  }
}
