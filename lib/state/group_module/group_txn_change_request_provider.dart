// lib/state/groups/group_txn_change_request_provider.dart

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/groups_module/group_txn_change_request_model.dart';
import '../../services/groups_module/group_txn_change_request_service.dart';

/// Exposes change‐request operations for a single group transaction.
class GroupTxnChangeRequestProvider extends ChangeNotifier {
  final GroupTxnChangeRequestService _service;

  GroupTxnChangeRequestProvider(this._service) {
    _initialize();
  }

  /// ─── Public state ───────────────────────────────────────────────────────

  /// Live list of change requests for this txn.
  List<GroupTxnChangeRequestModel> _requests = [];
  List<GroupTxnChangeRequestModel> get requests => _requests;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _error;
  String? get error => _error;

  /// ─── Internals ───────────────────────────────────────────────────────────

  late final StreamSubscription<List<GroupTxnChangeRequestModel>> _sub;

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      // 1) seed local Hive if empty
      await _service.initialSeed();

      // 2) subscribe to local box changes
      _sub = _service.watchAll().listen((list) {
        _requests = list;
        notifyListeners();
      });

      // 3) one‐off sync upstream + downstream
      await synchronize();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// ─── Actions ────────────────────────────────────────────────────────────

  /// Send a new change‐request.
  Future<void> requestChange(GroupTxnChangeRequestModel req) =>
      _runProcessing(() async {
        await _service.requestChange(req);
        await synchronize();
      });

  /// Approve an existing request.
  Future<void> approveChange({
    required String requestId,
    required String approverId,
  }) =>
      _runProcessing(() async {
        await _service.approveChange(
          requestId: requestId,
          approverId: approverId,
        );
        await synchronize();
      });

  /// Reject an existing request.
  Future<void> rejectChange({
    required String requestId,
    required String approverId,
    String? reason,
  }) =>
      _runProcessing(() async {
        await _service.rejectChange(
          requestId: requestId,
          approverId: approverId,
          reason: reason,
        );
        await synchronize();
      });

  /// Manually trigger a sync.
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
