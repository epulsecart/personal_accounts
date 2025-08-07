// lib/models/group_model.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'group_model.g.dart';

@HiveType(typeId: 20)
class GroupModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final String createdBy;
  @HiveField(3) final List<Map<String, String>> memberIds;
  @HiveField(4) final Uint8List? joinCode;
  @HiveField(5) final DateTime createdAt;
  @HiveField(6) final DateTime updatedAt;
  @HiveField(7) final String? description;
  @HiveField(8) final List<String>? memberUids;


  GroupModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.memberIds,
     this.joinCode,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
     this.memberUids,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    var members = (data['memberIds'] as List<dynamic>?)
        ?.map((e) => Map<String, String>.from(e as Map))
        .toList() ?? [] ;
    return GroupModel(
      id: doc.id,
      name: data['name'] as String,
      createdBy: data['createdBy'] as String,
      memberIds: (data['memberIds'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList() ?? [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      description: (data['description']),
      memberUids: members.map((e) => e.keys.first).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'createdBy': createdBy,
    'memberIds': memberIds,
    'description': description,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'memberUids': memberIds.map((e) => e.keys.first).toList(),

  };

  GroupModel copyWith({
    String? name,
    List<Map<String, String>>? memberIds,
    String? description,
    DateTime? updatedAt,
  }) {
    List<Map<String, String>> members = List<Map<String, String>>.from(memberIds ?? this.memberIds) ;

    return GroupModel(
      id: id,
      name: name ?? this.name,
      createdBy: createdBy,
      memberIds: memberIds ?? this.memberIds,
        memberUids: members.map((e) => e.keys.first).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
        description:description
    );
  }
}
