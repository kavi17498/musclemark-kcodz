import 'package:hive/hive.dart';
import 'package:musclemark/models/workoutLog.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double weightUsed;

  @HiveField(3)
  String? type;

  @HiveField(4)
  List<double>? incrementOptions;

  @HiveField(5)
  List<WorkoutLog>? workoutLogs;

  Workout({
    required this.id,
    required this.name,
    required this.weightUsed,
    required this.type,
  });
}
