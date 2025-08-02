import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'transactions.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final bool isExpense;

  @HiveField(5)
  final String? attachment;

  @HiveField(6)
  final String? categoryId;
  @HiveField(7)
  final DateTime? updatedAt;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.attachment,
    this.categoryId,
    required this.updatedAt
  });

  factory TransactionModel.fromFirestore(String id, Map<String,dynamic> data) => TransactionModel(
    id: id,
    description: data['description'] as String,
    amount: (data['amount'] as num).toDouble(),
    date: (data['date'] as Timestamp).toDate(),
    isExpense: data['isExpense'] as bool,
    attachment: data['attachment'] as String?,
    categoryId: data['categoryId'] as String?,
    updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
  );

  Map<String, dynamic> toFirestoreMap() => {
    'description': description,
    'amount': amount,
    'date': Timestamp.fromDate(date),
    'isExpense': isExpense,
    if (attachment != null) 'attachment': attachment,
    if (categoryId != null) 'categoryId': categoryId,
    'updatedAt': FieldValue.serverTimestamp(),
  };

}
