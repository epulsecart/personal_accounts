// lib/services/groups/group_service.dart

import 'dart:async';

import '../../data/groups_module/group_model.dart';
import '../../data/groups_module/group_transaction_model.dart';
import '../../data/offline_mutation.dart';
import '../user_module/transactions_service.dart';

/// Simple totals container.


/// Offline‐first CRUD & sync for “groups” + handy lookups.
abstract class GroupService {
  /// === Local writes (and queue for remote) ===
  Future<void> createGroup(GroupModel group);
  Future<void> updateGroup(GroupModel group);
  Future<void> deleteGroup(String groupId);

  /// === Local reads from Hive ===
  List<GroupModel> fetchAllGroups();
  Stream<List<GroupModel>> watchAllGroups();
  Future<GroupModel?> getGroupById(String groupId);

  /// === Local reads of transactions ===
  List<GroupTransactionModel> fetchTransactions(String groupId);
  Stream<List<GroupTransactionModel>> watchTransactions(String groupId);

  /// === Summary helpers ===
  Future<Summary> getGroupSummary(String groupId);
  Future<Map<String,double>> getMemberNetBalances(String groupId);

  /// === Sync with Firestore ===
  Future<void> initialSeed();
  Future<void> syncUpstream();
  Future<void> syncDownstream();
  Future<void> synchronize();
}
