// lib/state/groups/settlement_request_provider.dart

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/groups_module/settlement_request_model.dart';
import '../../services/groups_module/settlement_request_service.dart';

/// Exposes settlement‐request operations scoped to all groups.
class SettlementRequestProvider extends ChangeNotifier {
  final SettlementRequestService _service;

  SettlementRequestProvider(this._service) {
    _initialize();
  }

  /// ─── Public state ───────────────────────────────────────────────────────

  /// All settlement requests (across all groups).
  List<SettlementRequestModel> _requests = [];
  List<SettlementRequestModel> get requests => _requests;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _error;
  String? get error => _error;

  /// ─── Internals ───────────────────────────────────────────────────────────

  late final StreamSubscription<List<SettlementRequestModel>> _sub;

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      // 1) seed Hive if needed
      await _service.initialSeed();

      // 2) subscribe to Hive changes
      _sub = _service.watchAll().listen((list) {
        _requests = list;
        notifyListeners();
      });

      // 3) one-off sync
      await synchronize();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// ─── Actions ────────────────────────────────────────────────────────────

  /// Create a new settlement request.
  Future<void> createSettlementRequest(SettlementRequestModel req) =>
      _runProcessing(() async {
        await _service.createSettlementRequest(req);
        await synchronize();
      });

  /// Mark an existing request as settled.
  Future<void> markSettled({
    required String requestId,
    required DateTime settledAt,
  }) =>
      _runProcessing(() async {
        await _service.markSettled(
          requestId: requestId,
          settledAt: settledAt,
        );
        await synchronize();
      });

  /// Manually trigger upstream & downstream sync.
  Future<void> synchronize() async {
    _setSyncing(true);
    try {
      await _service.syncUpstream();
      await _service.syncDownstream();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setSyncing(false);
    }
  }

  /// ─── Cleanup ─────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  // ─── Private helpers ────────────────────────────────────────────────────

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
      _setError(e.toString());
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void _setError(String msg) {
    _error = msg;
    notifyListeners();
  }
}
