import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../services/workout_hive_service.dart';

class WorkoutViewModel extends Notifier<List<Workout>> {
  final WorkoutHiveService _service = WorkoutHiveService();

  @override
  List<Workout> build() {
    return _service.getAllWorkouts();
  }

  void refresh() {
    state = _service.getAllWorkouts();
  }

  Future<void> addWorkout(Workout workout) async {
    await _service.addWorkout(workout);
    refresh();
  }

  Future<void> deleteWorkout(int id) async {
    await _service.deleteWorkout(id);
    refresh();
  }

  Future<void> updateWorkout(Workout workout) async {
    // Update the state immediately for real-time UI update
    final currentWorkouts = List<Workout>.from(state);
    final index = currentWorkouts.indexWhere((w) => w.id == workout.id);

    if (index != -1) {
      currentWorkouts[index] = workout;
      state = currentWorkouts;
    }

    // Also update in Hive storage
    await _service.updateWorkout(workout);
  }
}
