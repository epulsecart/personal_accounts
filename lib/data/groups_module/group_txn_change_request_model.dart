// lib/models/group_txn_change_request_model.dart

import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'group_txn_change_request_model.g.dart';

@HiveType(typeId: 24)
enum ChangeType {
  @HiveField(0) update,
  @HiveField(1) delete,
}

@HiveType(typeId: 25)
enum RequestStatus {
  @HiveField(0) pending,
  @HiveField(1) approved,
  @HiveField(2) rejected,
}

@HiveType(typeId: 26)
class GroupTxnChangeRequestModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String groupId;
  @HiveField(2) final String transactionId;
  @HiveField(3) final ChangeType type;
  @HiveField(4) final String requestedBy;
  @HiveField(5) final double? oldAmount;
  @HiveField(6) final double? newAmount;
  @HiveField(7) final String? oldDescription;
  @HiveField(8) final String? newDescription;
  @HiveField(9) final RequestStatus status;
  @HiveField(10) final String? approvedBy;
  @HiveField(11) final DateTime requestedAt;
  @HiveField(12) final DateTime? respondedAt;
  @HiveField(13) final String? reason;

  GroupTxnChangeRequestModel({
    required this.id,
    required this.groupId,
    required this.transactionId,
    required this.type,
    required this.requestedBy,
    this.oldAmount,
    this.newAmount,
    this.oldDescription,
    this.newDescription,
    this.status = RequestStatus.pending,
    this.approvedBy,
    required this.requestedAt,
    this.respondedAt,
    this.reason,
  });

  factory GroupTxnChangeRequestModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return GroupTxnChangeRequestModel(
      id: doc.id,
      groupId: d['groupId'] as String,
      transactionId: d['transactionId'] as String,
      type: ChangeType.values.byName(d['type'] as String),
      requestedBy: d['requestedBy'] as String,
      oldAmount: (d['oldAmount'] as num?)?.toDouble(),
      newAmount: (d['newAmount'] as num?)?.toDouble(),
      oldDescription: d['oldDescription'] as String?,
      reason: d['reason'] as String?,
      newDescription: d['newDescription'] as String?,
      status: RequestStatus.values.byName(d['status'] as String),
      approvedBy: d['approvedBy'] as String?,
      requestedAt: (d['requestedAt'] as Timestamp).toDate(),
      respondedAt: d['respondedAt'] != null
          ? (d['respondedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'groupId': groupId,
    'transactionId': transactionId,
    'type': type.name,
    'requestedBy': requestedBy,
    'oldAmount': oldAmount,
    'newAmount': newAmount,
    'oldDescription': oldDescription,
    'reason': reason,
    'newDescription': newDescription,
    'status': status.name,
    'approvedBy': approvedBy,
    'requestedAt': requestedAt,
    'respondedAt':
    respondedAt != null ? respondedAt! : null,
  };

  GroupTxnChangeRequestModel copyWith({
    RequestStatus? status,
    String? approvedBy,
    DateTime? respondedAt,
  }) {
    return GroupTxnChangeRequestModel(
      id: id,
      groupId: groupId,
      transactionId: transactionId,
      type: type,
      requestedBy: requestedBy,
      oldAmount: oldAmount,
      newAmount: newAmount,
      oldDescription: oldDescription,
      reason: reason,
      newDescription: newDescription,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      requestedAt: requestedAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}
