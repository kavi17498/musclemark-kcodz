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
    // Find the key for this workout by searching through all values
    final key = _box.keys.firstWhere(
      (key) => _box.get(key)?.id == id,
      orElse: () => null,
    );

    if (key != null) {
      await _box.delete(key);
    }
  }

  //update workout
  Future<Workout> updateWorkout(Workout workout) async {
    // Find the key for this workout by searching through all values
    final key = _box.keys.firstWhere(
      (key) => _box.get(key)?.id == workout.id,
      orElse: () => null,
    );

    if (key != null) {
      await _box.put(key, workout);
    }
    return workout;
  }
}
