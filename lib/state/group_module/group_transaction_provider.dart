// lib/state/groups_module/group_transaction_provider.dart

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/groups_module/group_transaction_model.dart';
import '../../services/groups_module/group_transaction_service.dart';
import '../../services/groups_module/group_service.dart' as ser;
import '../../services/user_module/transactions_service.dart' as sumarry;


/// Exposes one group’s transactions + sync to the UI.
class GroupTransactionProvider extends ChangeNotifier {
  final GroupTransactionService _service;
  final String _groupId;
  final String _userId;

  GroupTransactionProvider({
    required GroupTransactionService service,
    required String groupId,
    required String userId,
  })  : _service = service,
        _groupId  = groupId,
        _userId   = userId {
    _initialize();
  }

  // ─── State ────────────────────────────────────────────────────────────────

  List<GroupTransactionModel> _transactions = [];
  List<GroupTransactionModel> get transactions => _transactions;

  bool _isLoading   = false;
  bool get isLoading   => _isLoading;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isSyncing   = false;
  bool get isSyncing   => _isSyncing;

  String? _error;
  String? get error => _error;

  sumarry.Summary _summary = sumarry.Summary(totalExpense: 0, totalIncome: 0);
  sumarry.Summary get summary => _summary;

  late final StreamSubscription<List<GroupTransactionModel>> _sub;

  // ─── Initialization ───────────────────────────────────────────────────────

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      // 1) Seed Hive if empty
      await _service.initialSeed(_groupId);

      // 2) Compute initial summary
      _summary = await _service.getSummary(
        groupId: _groupId,
        userId: _userId,
      );

      // 3) Listen to local Hive changes
      _sub = _service.watchAll(_groupId).listen((list) {
        _transactions = list;
        notifyListeners();
      });

      // 4) One-off sync up & down
      await synchronize();
    } catch (e) {
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ─── Add / Sync ───────────────────────────────────────────────────────────

  /// Add a new transaction (local + enqueue), then push & recompute.
  Future<void> addTransaction(GroupTransactionModel txn) =>
      _runProcessing(() async {
        await _service.addTransaction(txn);
        await _service.syncUpstream();
        _summary = await _service.getSummary(
          groupId: _groupId,
          userId: _userId,
        );
      });

  /// Push any local changes and pull any remote diffs.
  Future<void> synchronize() async {
    _setSyncing(true);
    try {
      await _service.syncUpstream();
      await _service.syncDownstream(_groupId);
    } catch (e) {
      _setError(e);
    } finally {
      _setSyncing(false);
    }
  }

  // ─── Queries & Summaries ─────────────────────────────────────────────────

  /// One-off fetch of transactions in a date range.
  Future<List<GroupTransactionModel>> fetchByDateRange(
      {required DateTime start, required DateTime end}) =>
      _service.fetchByDateRange(
        groupId: _groupId,
        start: start,
        end: end,
      );

  /// Compute expense vs income for this user in the group.
  Future<sumarry.Summary> getSummary({DateTime? start, DateTime? end}) =>
      _service.getSummary(
        groupId: _groupId,
        userId: _userId,
        start: start,
        end: end,
      );

  /// Clear all local data (for testing or full reset).
  Future<void> clearAll() async {
    await _service.clearAll();
    _transactions = [];
    _summary = sumarry.Summary(totalExpense: 0, totalIncome: 0);
    notifyListeners();
  }

  // ─── Lifecycle & Helpers ─────────────────────────────────────────────────

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setSyncing(bool v) {
    _isSyncing = v;
    notifyListeners();
  }

  Future<void> _runProcessing(Future<void> Function() action) async {
    _isProcessing = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      _setError(e);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void _setError(Object e) {
    _error = e.toString();
    notifyListeners();
  }
}
