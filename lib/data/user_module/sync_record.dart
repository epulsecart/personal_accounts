import 'package:accounts/data/user_module/transactions.dart';
import 'package:hive/hive.dart';

part 'sync_record.g.dart';

/// What kind of Firestore operation to perform.
@HiveType(typeId: 4)
enum SyncOperation {
  @HiveField(0)
  create,

  @HiveField(1)
  update,

  @HiveField(2)
  delete,
}

/// A record of a local change to be pushed upstream.
@HiveType(typeId: 5)
class SyncRecord extends HiveObject {
  /// The ID of the transaction this record refers to.
  @HiveField(0)
  final String id;

  /// Which operation (create/update/delete) to perform.
  @HiveField(1)
  final SyncOperation operation;

  /// The full TransactionModel for create/update. Null for delete.
  @HiveField(2)
  final TransactionModel? txn;

  /// When the user performed the change (for ordering/retries).
  @HiveField(3)
  final DateTime timestamp;

  SyncRecord({
    required this.id,
    required this.operation,
    this.txn,
    required this.timestamp,
  });

  /// Factory for a brand-new transaction.
  factory SyncRecord.create(TransactionModel txn) => SyncRecord(
    id: txn.id,
    operation: SyncOperation.create,
    txn: txn,
    timestamp: DateTime.now(),
  );

  /// Factory for an updated transaction.
  factory SyncRecord.update(TransactionModel txn) => SyncRecord(
    id: txn.id,
    operation: SyncOperation.update,
    txn: txn,
    timestamp: DateTime.now(),
  );

  /// Factory for a deleted transaction.
  factory SyncRecord.delete(String id) => SyncRecord(
    id: id,
    operation: SyncOperation.delete,
    txn: null,
    timestamp: DateTime.now(),
  );
}
