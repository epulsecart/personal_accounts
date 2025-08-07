// lib/models/group_transaction_model.dart

import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'group_transaction_model.g.dart';

@HiveType(typeId: 21)
class GroupTransactionModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String groupId;
  @HiveField(2) final String fromUserId;
  @HiveField(3) final String toUserId;
  @HiveField(4) final String createdBy;
  @HiveField(5) final double amount;
  @HiveField(6) final String description;
  @HiveField(7) final String? fileUrl;
  @HiveField(8) final DateTime date;
  @HiveField(9) final bool isApproved;
  @HiveField(10) final String? approvedBy;
  @HiveField(11) final DateTime createdAt;
  @HiveField(12) final DateTime updatedAt;
  @HiveField(13) final bool isDeleted;
  @HiveField(14) final String payerName;
  @HiveField(15) final String receiverName;

  GroupTransactionModel({
    required this.id,
    required this.groupId,
    required this.fromUserId,
    required this.toUserId,
    required this.createdBy,
    required this.amount,
    required this.description,
    this.fileUrl,
    required this.date,
    this.isApproved = false,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.payerName,
    required this.receiverName,
  });

  factory GroupTransactionModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return GroupTransactionModel(
      id: doc.id,
      groupId: d['groupId'] as String,
      fromUserId: d['fromUserId'] as String,
      toUserId: d['toUserId'] as String,
      createdBy: d['createdBy'] as String,
      amount: (d['amount'] as num).toDouble(),
      description: d['description'] as String,
      fileUrl: d['fileUrl'] as String?,
      date: (d['date'] as Timestamp).toDate(),
      isApproved: d['isApproved'] as bool? ?? false,
      isDeleted: d['isDeleted'] as bool? ?? false,
      approvedBy: d['approvedBy'] as String?,
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      updatedAt: (d['updatedAt'] as Timestamp).toDate(),
        payerName: d['payerName'] as String,
        receiverName: d['receiverName'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'groupId': groupId,
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'createdBy': createdBy,
    'amount': amount,
    'description': description,
    'fileUrl': fileUrl,
    'date': date,
    'isApproved': isApproved,
    'approvedBy': approvedBy,
    'isDeleted': isDeleted,
    'createdAt': createdAt,
    'payerName':payerName,
   'receiverName':receiverName,
    'updatedAt': DateTime.now(),
  };

  GroupTransactionModel copyWith({
    double? amount,
    String? description,
    String? fileUrl,
    bool? isApproved,
    bool? isDeleted,
    String? approvedBy,
    DateTime? updatedAt,
  }) {
    return GroupTransactionModel(
      id: id,
      groupId: groupId,
      fromUserId: fromUserId,
      toUserId: toUserId,
      createdBy: createdBy,
      payerName: payerName,
      receiverName: receiverName,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
      date: date,
      isApproved: isApproved ?? this.isApproved,
      isDeleted: isDeleted ?? this.isDeleted,
      approvedBy: approvedBy ?? this.approvedBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
