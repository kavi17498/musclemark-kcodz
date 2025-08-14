import 'package:hive/hive.dart';
import '../models/workout.dart';

class WorkoutHiveService {
  final Box<Workout> _box = Hive.box<Workout>('workouts');

  //get all workouts
  List<Workout> getAllWorkouts() => _box.values.toList();

  //add workout
  Future<void> addWorkout(Workout workout) async {
    _box.add(workout);
  }

  //delete workout
  Future<void> deleteWorkout(int id) async {
    _box.delete(id);
  }

  //update workout
  Future<Workout> updateWorkout(Workout workout) async {
    _box.put(workout.id, workout);
    return workout;
  }
}
