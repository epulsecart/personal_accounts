import 'package:hive/hive.dart';
part 'templates.g.dart';

@HiveType(typeId: 2)
enum Frequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  custom,
}

@HiveType(typeId: 3)
class TemplateModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? categoryId;

  @HiveField(5)
  final Frequency frequency;

  @HiveField(6)
  final DateTime nextRun;

  @HiveField(7)
  final bool autoAdd;

  TemplateModel({
    required this.id,
    required this.title,
    required this.amount,
    this.description,
    this.categoryId,
    required this.frequency,
    required this.nextRun,
    required this.autoAdd,
  });
}
