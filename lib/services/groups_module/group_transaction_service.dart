// lib/services/groups/group_transaction_service.dart

import 'package:accounts/data/groups_module/group_transaction_model.dart';
import '../user_module/transactions_service.dart';

abstract class GroupTransactionService {
  /// === Local‐only writes (and enqueue for remote) ===
  Future<void> addTransaction(GroupTransactionModel txn);

  /// === Local reads from Hive (all in-memory) ===
  Future<List<GroupTransactionModel>> fetchAll(String groupId);
  Stream<List<GroupTransactionModel>> watchAll(String groupId);
  Future<List<GroupTransactionModel>> fetchByDateRange({
    required String groupId,
    required DateTime start,
    required DateTime end,
  });
  Future<Summary> getSummary({
    required String groupId,
    required String userId,
    DateTime? start,
    DateTime? end,
  });

  /// === Live Firestore stream (only when online & on-screen) ===
  Stream<List<GroupTransactionModel>> watchRemote(String groupId);

  /// === Sync with Firestore ===
  Future<void> initialSeed(String groupId);
  Future<void> syncDownstream(String groupId);
  Future<void> syncUpstream();
  Future<void> synchronize(String groupId);

  /// === Utility ===
  Future<void> clearAll();
}
