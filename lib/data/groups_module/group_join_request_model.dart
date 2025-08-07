// lib/models/group_join_request_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'group_join_request_model.g.dart';

@HiveType(typeId: 22)
enum JoinStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  approved,
  @HiveField(2)
  rejected,
}

@HiveType(typeId: 23)
class GroupJoinRequestModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String groupId;

  /// Who created the request (could be admin‐invite or self‐join)
  @HiveField(2)
  final String requesterId;

  /// Human name of the requester
  @HiveField(3)
  final String requesterName;

  /// Who is being invited (for admin‐invite) or who must approve (for self‐join)
  @HiveField(4)
  final String inviteeId;

  /// Human name of the invitee
  @HiveField(5)
  final String inviteeName;

  @HiveField(6)
  final JoinStatus status;

  /// Whoever actually approved/rejected (once status != pending)
  @HiveField(7)
  final String? approverId;

  @HiveField(8)
  final DateTime requestedAt;

  @HiveField(9)
  final DateTime? respondedAt;

  @HiveField(10)
  final String? message;

  GroupJoinRequestModel({
    required this.id,
    required this.groupId,
    required this.requesterId,
    required this.requesterName,
    required this.inviteeId,
    required this.inviteeName,
    this.status = JoinStatus.pending,
    this.approverId,
    required this.requestedAt,
    this.respondedAt,
    this.message,
  });

  factory GroupJoinRequestModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return GroupJoinRequestModel(
      id: doc.id,
      groupId: d['groupId'] as String,
      requesterId: d['requesterId'] as String,
      requesterName: d['requesterName'] as String,
      inviteeId: d['inviteeId'] as String,
      inviteeName: d['inviteeName'] as String,
      status: JoinStatus.values.byName(d['status'] as String),
      approverId: d['approverId'] as String?,
      requestedAt: (d['requestedAt'] as Timestamp).toDate(),
      respondedAt:
      d['respondedAt'] != null ? (d['respondedAt'] as Timestamp).toDate() : null,
      message: d['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'groupId': groupId,
    'requesterId': requesterId,
    'requesterName': requesterName,
    'inviteeId': inviteeId,
    'inviteeName': inviteeName,
    'status': status.name,
    'approverId': approverId,
    'requestedAt': requestedAt,
    'respondedAt': respondedAt != null ? respondedAt! : null,
    'message': message,
  };

  GroupJoinRequestModel copyWith({
    JoinStatus? status,
    String? approverId,
    DateTime? respondedAt,
    String? message,
  }) {
    return GroupJoinRequestModel(
      id: id,
      groupId: groupId,
      requesterId: requesterId,
      requesterName: requesterName,
      inviteeId: inviteeId,
      inviteeName: inviteeName,
      status: status ?? this.status,
      approverId: approverId ?? this.approverId,
      requestedAt: requestedAt,
      respondedAt: respondedAt ?? this.respondedAt,
      message: message ?? this.message,
    );
  }
}
