import 'package:hive/hive.dart';

part 'bmi.g.dart';

@HiveType(typeId: 0)
class Bmi extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  double height;

  @HiveField(2)
  double weight;

  @HiveField(3)
  double bmi;

  @HiveField(4)
  double category;

  @HiveField(5)
  DateTime date;

  Bmi({
    required this.id,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.category,
    required this.date,
  });
}
