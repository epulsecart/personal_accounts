import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'categories.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String iconName;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final bool isExpense;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    required this.isExpense,
  });

  /// Construct from a Firestore document.
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] as String,
      iconName: data['iconName'] as String,
      colorValue: data['colorValue'] as int,
      isExpense: data['isExpense'] as bool,
    );
  }

  /// Convert to a map for writing to Firestore.
  /// Includes a server-timestamped `updatedAt` field.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'iconName': iconName,
      'colorValue': colorValue,
      'isExpense': isExpense,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
