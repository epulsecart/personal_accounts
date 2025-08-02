// lib/models/settlement_request_model.dart

import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'settlement_request_model.g.dart';

@HiveType(typeId: 27)
class SettlementRequestModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String groupId;
  @HiveField(2) final String groupName;
  @HiveField(3) final String creatorId;
  @HiveField(4) final String creatorName;
  @HiveField(5) final String targetMemberId;
  @HiveField(6) final String targetMemberName;
  @HiveField(7) final double amount;
  @HiveField(8) final DateTime dueDate;
  @HiveField(9) final bool settled;
  @HiveField(10) final DateTime requestedAt;
  @HiveField(11) final String? note;

  SettlementRequestModel({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.creatorId,
    required this.creatorName,
    required this.targetMemberId,
    required this.targetMemberName,
    required this.amount,
    required this.dueDate,
    this.settled = false,
    this.note,
    required this.requestedAt,
  });

  factory SettlementRequestModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return SettlementRequestModel(
      id: doc.id,
      groupId: d['groupId'] as String,
      groupName: d['groupName'] as String,
      creatorId: d['creatorId'] as String,
      creatorName: d['creatorName'] as String,
      targetMemberId: d['targetMemberId'] as String,
      note: d['note'] as String?,
      targetMemberName: d['targetMemberName'] as String,
      amount: (d['amount'] as num).toDouble(),
      dueDate: (d['dueDate'] as Timestamp).toDate(),
      settled: d['settled'] as bool? ?? false,
      requestedAt: (d['requestedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'groupId': groupId,
    'groupName': groupName,
    'creatorId': creatorId,
    'creatorName': creatorName,
    'targetMemberId': targetMemberId,
    'targetMemberName': targetMemberName,
    'amount': amount,
    'note': note,
    'dueDate': Timestamp.fromDate(dueDate),
    'settled': settled,
    'requestedAt': Timestamp.fromDate(requestedAt),
  };

  SettlementRequestModel copyWith({
    bool? settled,
    DateTime? dueDate,

  }) {
    return SettlementRequestModel(
      id: id,
      groupId: groupId,
      groupName: groupName,
      creatorId: creatorId,
      creatorName: creatorName,
      targetMemberId: targetMemberId,
      note: note,
      targetMemberName: targetMemberName,
      amount: amount,
      dueDate: dueDate ?? this.dueDate,
      settled: settled ?? this.settled,
      requestedAt: requestedAt,
    );
  }
}
