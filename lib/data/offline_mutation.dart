// lib/data/offline_mutation.dart
import 'package:hive/hive.dart';

part 'offline_mutation.g.dart';

@HiveType(typeId: 100)
enum MutationOp {
  @HiveField(0) create,
  @HiveField(1) update,
  @HiveField(2) delete,
}

@HiveType(typeId: 101)
class OfflineMutation extends HiveObject {
  /// e.g. 'users/123/groups' or 'users/123/groups/xyz/transactions'
  @HiveField(0)
  final String collection;

  /// the document ID
  @HiveField(1)
  final String docId;

  @HiveField(2)
  final MutationOp operation;

  /// full map for create/update, empty for delete
  @HiveField(3)
  final Map<String, dynamic>? data;

  @HiveField(4)
  final DateTime timestamp;

  OfflineMutation({
    required this.collection,
    required this.docId,
    required this.operation,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Factories for convenience in your service:
  factory OfflineMutation.create({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) => OfflineMutation(
    collection: collection,
    docId:       docId,
    operation:   MutationOp.create,
    data:        data,
  );

  factory OfflineMutation.update({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) => OfflineMutation(
    collection: collection,
    docId:       docId,
    operation:   MutationOp.update,
    data:        data,
  );

  factory OfflineMutation.delete({
    required String collection,
    required String docId,
  }) => OfflineMutation(
    collection: collection,
    docId:       docId,
    operation:   MutationOp.delete,
    data:        null,
  );
}
