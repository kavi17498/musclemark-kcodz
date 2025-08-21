import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

part 'workoutLog.g.dart';

@HiveType(typeId: 1)
class WorkoutLog extends HiveObject {
  @HiveField(0)
  DateTime? time;

  @HiveField(1)
  double weight;

  @HiveField(2)
  int sets;

  @HiveField(3)
  int reps;

  WorkoutLog({
    required this.time,
    required this.weight,
    required this.sets,
    required this.reps,
  });
}
