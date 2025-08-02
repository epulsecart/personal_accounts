// lib/state/groups_module/group_join_request_provider.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../data/groups_module/group_join_request_model.dart';
import '../../services/groups_module/group_join_request_service.dart';

class GroupJoinRequestProvider extends ChangeNotifier {
  final GroupJoinRequestService _service;
  final String                  groupId;

  GroupJoinRequestProvider({
    required GroupJoinRequestService service,
    required this.groupId,
  }) : _service = service {
    _initialize();
  }

  /// The live list of pending/approved/rejected requests for this group.
  List<GroupJoinRequestModel> _requests = [];
  List<GroupJoinRequestModel> get requests => _requests;

  bool _isLoading    = false;
  bool get isLoading => _isLoading;

  bool _isProcessing    = false;
  bool get isProcessing => _isProcessing;

  String? _error;
  String? get error => _error;

  late final StreamSubscription<List<GroupJoinRequestModel>>
  _subscription;

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      // 1) Seed local Hive if empty
      await _service.initialSeed();
      // 2) Subscribe to local box changes for this group
      _subscription = _service
          .watchAllForGroup(groupId)
          .listen((list) {
        _requests = list;
        notifyListeners();
      });
      // 3) Fire off first full sync
      await synchronize();
    } catch (e) {
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new join-request
  Future<void> createRequest(GroupJoinRequestModel req) =>
      _runProcessing(() async {
        await _service.createRequest(req);
        await _service.synchronize();
      });

  /// Admin approves
  Future<void> approveRequest(GroupJoinRequestModel req) =>
      _runProcessing(() async {
        await _service.approveRequest(req);
        await _service.synchronize();
      });

  /// Admin rejects
  Future<void> rejectRequest(GroupJoinRequestModel req) =>
      _runProcessing(() async {
        await _service.rejectRequest(req);
        await _service.synchronize();
      });

  /// Delete a request (e.g. cancel)
  Future<void> deleteRequest(String id) =>
      _runProcessing(() async {
        await _service.deleteRequest(id);
        await _service.synchronize();
      });

  /// Manually trigger a full push/pull sync
  Future<void> synchronize() async {
    _setProcessing(true);
    try {
      await _service.syncUpstream();
      await _service.syncDownstream();
    } catch (e) {
      _setError(e);
    } finally {
      _setProcessing(false);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // ─── Internals ──────────────────────────────────────────────────────────

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setProcessing(bool v) {
    _isProcessing = v;
    notifyListeners();
  }

  Future<void> _runProcessing(Future<void> Function() action) async {
    _setProcessing(true);
    _error = null;
    try {
      await action();
    } catch (e) {
      _setError(e);
    } finally {
      _setProcessing(false);
    }
  }

  void _setError(Object e) {
    _error = e.toString();
    notifyListeners();
  }
}
