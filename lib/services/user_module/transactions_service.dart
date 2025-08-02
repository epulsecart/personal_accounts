import '../../data/user_module/transactions.dart';

/// Totals for expenses vs incomes.
class Summary {
  final double totalExpense;
  final double totalIncome;
  Summary({required this.totalExpense, required this.totalIncome});
}

abstract class TransactionService {
  /// === Local-only writes (and queue for remote) ===
  Future<void> addTransaction(TransactionModel txn);
  Future<void> updateTransaction(TransactionModel txn);
  Future<void> deleteTransaction(String id);

  /// === Local-only reads from Hive ===

  /// Fetch the full list once (for initial load).
  Future<List<TransactionModel>> fetchAll();

  /// Stream of all transactions in Hive, emitting whenever the box changes.
  /// *Does NOT* hit Firestore—this is purely local so your UI can update immediately.
  Stream<List<TransactionModel>> watchAll();

  /// Search Hive by description substring.
  Future<List<TransactionModel>> searchByDescription(String query);

  /// Most-recent unique descriptions (up to [limit]), for autocomplete.
  Future<List<String>> recentDescriptions({int limit = 10});

  /// Transactions in the given date range (inclusive).
  Future<List<TransactionModel>> fetchByDateRange({
    required DateTime start,
    required DateTime end,
  });

  /// Overall expense vs income totals in the date range.
  Future<Summary> getSummary({
    DateTime? start,
    DateTime? end,
  });

  /// Sum of amounts per categoryId in the date range.
  Future<Map<String, double>> getCategoryTotals({
    DateTime? start,
    DateTime? end,
  });

  /// === Sync with Firestore ===

  /// Push any queued local mutations (creates/updates/deletes) to Firestore.
  Future<void> syncUpstream();

  /// Pull remote changes (since last pull) into Hive using `updatedAt` diffs.
  Future<void> syncDownstream();

  /// Convenience: run both upstream & downstream.
  Future<void> synchronize();

  /// If Hive is empty, fetch all remote docs (paginated under the hood)
  /// into Hive, then set the `lastPulledAt` timestamp.
  Future<void> initialSeed();

  /// === Utility ===

  /// Clear all transactions locally (and drop any queued sync records).
  Future<void> clearAll();
}
