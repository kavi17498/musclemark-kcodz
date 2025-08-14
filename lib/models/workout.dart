import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double weightUsed;

  Workout({required this.id, required this.name, required this.weightUsed});
}
