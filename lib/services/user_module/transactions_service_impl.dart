// lib/services/transaction_service_impl.dart

import 'dart:async';

import 'package:accounts/services/user_module/transactions_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_module/sync_record.dart';
import '../../data/user_module/transactions.dart';


class TransactionServiceImpl implements TransactionService {
  static const _kLastPulledKey = 'txns_lastPulledAt';

  final Box<TransactionModel> _txnBox;
  final Box<SyncRecord>       _queueBox;
  final FirebaseFirestore     _firestore;
  final String                _userId;
  final SharedPreferences     _prefs;

  TransactionServiceImpl({
    required String userId,
    required Box<TransactionModel> txnBox,
    required Box<SyncRecord> queueBox,
    FirebaseFirestore? firestore,
    required SharedPreferences prefs,
  })  : _userId     = userId,
        _txnBox     = txnBox,
        _queueBox   = queueBox,
        _firestore  = firestore ?? FirebaseFirestore.instance,
        _prefs      = prefs;

  // ────────────────────────────────────────────────────────────────────────────
  // Local writes + enqueue for sync
  @override
  Future<void> addTransaction(TransactionModel txn) async {
    await _txnBox.put(txn.id, txn);
    final rec = SyncRecord.create(txn);
    await _queueBox.add(rec);
  }

  @override
  Future<void> updateTransaction(TransactionModel txn) async {
    await _txnBox.put(txn.id, txn);
    final rec = SyncRecord.update(txn);
    await _queueBox.add(rec);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _txnBox.delete(id);
    final rec = SyncRecord.delete(id);
    await _queueBox.add(rec);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Local reads from Hive
  @override
  Future<List<TransactionModel>> fetchAll() async {
    final all = _txnBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return all;
  }

  @override
  Stream<List<TransactionModel>> watchAll() {
    // Emit current + any time the box changes
    return _txnBox.watch().map((_) => _txnBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)))
    // Also start with initial state
        .startWith(_txnBox.values.toList()..sort((a, b) => b.date.compareTo(a.date)));
  }

  @override
  Future<List<TransactionModel>> searchByDescription(String query) async {
    final q = query.toLowerCase();
    return (await fetchAll())
        .where((t) => t.description.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<List<String>> recentDescriptions({int limit = 10}) async {
    final seen = <String>{};
    final list = <String>[];
    for (var t in await fetchAll()) {
      if (seen.add(t.description)) {
        list.add(t.description);
        if (list.length >= limit) break;
      }
    }
    return list;
  }

  @override
  Future<List<TransactionModel>> fetchByDateRange({
    required DateTime start,
    required DateTime end,
  }) async {
    return (await fetchAll())
        .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
        .toList();
  }

  @override
  Future<Summary> getSummary({DateTime? start, DateTime? end}) async {
    final txns = (start == null && end == null)
        ? await fetchAll()
        : await fetchByDateRange(start: start!, end: end!);
    double exp = 0, inc = 0;
    for (var t in txns) {
      if (t.isExpense) exp += t.amount;
      else inc += t.amount;
    }
    return Summary(totalExpense: exp, totalIncome: inc);
  }

  @override
  Future<Map<String, double>> getCategoryTotals({
    DateTime? start,
    DateTime? end,
  }) async {
    final txns = (start == null && end == null)
        ? await fetchAll()
        : await fetchByDateRange(start: start!, end: end!);
    final map = <String, double>{};
    for (var t in txns) {
      final cat = t.categoryId ?? 'uncategorized';
      map[cat] = (map[cat] ?? 0) + t.amount;
    }
    return map;
  }

  @override
  Future<void> clearAll() async {
    await _txnBox.clear();
    await _queueBox.clear();
    await _prefs.remove(_kLastPulledKey);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Sync with Firestore
  @override
  Future<void> syncUpstream() async {
    // For each queued record, perform the Firestore operation:
    for (var rec in _queueBox.values.toList()) {
      final ref = _firestore.collection('users/$_userId/transactions').doc(rec.id);
      try {
        switch (rec.operation) {
          case SyncOperation.create:
          case SyncOperation.update:
          // Merge ensures updatedAt is stamped
            await ref.set(rec.txn!.toFirestoreMap(), SetOptions(merge: true));
            break;
          case SyncOperation.delete:
            await ref.delete();
            break;
        }
        // If succeeded, remove from queue
        await rec.delete();
      } catch (e) {
        // keep it in queue for retry later
      }
    }
  }

  @override
  Future<void> syncDownstream() async {
    final last = DateTime.tryParse(_prefs.getString(_kLastPulledKey) ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
    final snap = await _firestore
        .collection('users/$_userId/transactions')
        .where('updatedAt', isGreaterThan: last)
        .orderBy('updatedAt')
        .get();

    for (var doc in snap.docs) {
      final data = doc.data();
      final txn = TransactionModel.fromFirestore(doc.id, data);
      await _txnBox.put(txn.id, txn);
    }
    await _prefs.setString(_kLastPulledKey, DateTime.now().toIso8601String());
  }

  @override
  Future<void> synchronize() async {
    await syncUpstream();
    await syncDownstream();
  }

  @override
  Future<void> initialSeed() async {
    if (_txnBox.isNotEmpty) return;
    String? lastDocId;
    const batchSize = 100;
    Query query = _firestore
        .collection('users/$_userId/transactions')
        .orderBy('date')
        .limit(batchSize);

    while (true) {
      if (lastDocId != null) {
        final lastDoc = await _firestore
            .collection('users/$_userId/transactions')
            .doc(lastDocId)
            .get();
        query = query.startAfterDocument(lastDoc);
      }
      final snap = await query.get();
      if (snap.docs.isEmpty) break;

      for (var doc in snap.docs) {
        final txn = TransactionModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
        await _txnBox.put(txn.id, txn);
      }
      lastDocId = snap.docs.last.id;
      if (snap.docs.length < batchSize) break;
    }
    await _prefs.setString(_kLastPulledKey, DateTime.now().toIso8601String());
  }
}
