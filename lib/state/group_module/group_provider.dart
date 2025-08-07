// lib/state/groups_module/group_provider.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../data/groups_module/group_model.dart';
import '../../services/groups_module/group_service.dart' as ser;
import '../../services/user_module/transactions_service.dart' as sumarry;
/// Exposes your list of groups + sync/CRUD to the UI.
class GroupProvider extends ChangeNotifier {
  final ser.GroupService _service;

  GroupProvider(this._service) {
    _initialize();
  }

  // ─── State ────────────────────────────────────────────────────────────────
  Map<String, sumarry.Summary> _groupSummary={};

  Map<String, sumarry.Summary> get groupSummary => _groupSummary;
  List<GroupModel> _groups = [];
  List<GroupModel> get groups => _groups;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  String? _error;
  String? get error => _error;

  late final StreamSubscription<List<GroupModel>> _sub;

  // ─── Initialization ───────────────────────────────────────────────────────

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      // 1) Seed Hive from Firestore if empty
      await _service.initialSeed();

      // 2) Subscribe to local updates
      _sub = _service.watchAllGroups().listen((list) {
        _groups = list;
        notifyListeners();
      });

      // 3) Kick off a first full sync
      await synchronize();
    } catch (e) {
      print ("error in sync 50 $e");
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }




  // ─── CRUD ─────────────────────────────────────────────────────────────────

  Future<void> createGroup(GroupModel group) =>
      _runProcessing(() async {
        await _service.createGroup(group);
        await _service.synchronize();
      });

  Future<void> updateGroup(GroupModel group) =>
      _runProcessing(() async {
        await _service.updateGroup(group);
        await _service.synchronize();
      });

  Future<void> deleteGroup(String groupId) =>
      _runProcessing(() async {
        await _service.deleteGroup(groupId);
        await _service.synchronize();
      });

  // ─── Summaries & Helpers ─────────────────────────────────────────────────

  /// Total expense/income for _you_ in the given group.
  Future<sumarry.Summary> getGroupSummary(String groupId) {
    // final returnSummary =await  _service.getGroupSummary(groupId);
    // _groupSummary[groupId] = returnSummary;
    // print ("i have got group summary ")
    // notifyListeners();
    return  _service.getGroupSummary(groupId);
  }

  /// Net balance per member in that group.
  Future<Map<String,double>> getMemberBalances(String groupId) =>
      _service.getMemberNetBalances(groupId);

  // ─── Manual Sync ─────────────────────────────────────────────────────────

  Future<void> synchronize() async {
    _setProcessing(true);
    try {
      await _service.syncUpstream();
      await _service.syncDownstream();
    } catch (e) {
      print ("error in sync 98 $e");
      _setError(e);
    } finally {
      _setProcessing(false);
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  // ─── Internals ────────────────────────────────────────────────────────────

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
      print ("error in runproccess 129 $e");
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
