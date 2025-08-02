// lib/models/group_model.dart

import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'group_model.g.dart';

@HiveType(typeId: 20)
class GroupModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final String createdBy;
  @HiveField(3) final List<String> memberIds;
  @HiveField(4) final String joinCode;
  @HiveField(5) final DateTime createdAt;
  @HiveField(6) final DateTime updatedAt;
  @HiveField(7) final String? description;

  GroupModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.memberIds,
    required this.joinCode,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      name: data['name'] as String,
      createdBy: data['createdBy'] as String,
      memberIds: List<String>.from(data['memberIds'] ?? []),
      joinCode: data['joinCode'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      description: (data['description']),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'createdBy': createdBy,
    'memberIds': memberIds,
    'joinCode': joinCode,
    'description': description,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  GroupModel copyWith({
    String? name,
    List<String>? memberIds,
    String? joinCode,
    String? description,
    DateTime? updatedAt,
  }) {
    return GroupModel(
      id: id,
      name: name ?? this.name,
      createdBy: createdBy,
      memberIds: memberIds ?? this.memberIds,
      joinCode: joinCode ?? this.joinCode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
        description:description
    );
  }
}
