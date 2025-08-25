import 'package:hive/hive.dart';
import '../models/workoutLog.dart';

class WorkoutLogService {
  final Box<WorkoutLog> _box = Hive.box<WorkoutLog>('workoutLogs');

  // Get all workout logs
  List<WorkoutLog> getAllWorkoutLogs() => _box.values.toList();

  // Get logs for a specific workout ID
  List<WorkoutLog> getWorkoutLogs(int workoutId) {
    return _box.values.where((log) => log.workoutId == workoutId).toList()
      ..sort(
        (a, b) =>
            (b.time ?? DateTime.now()).compareTo(a.time ?? DateTime.now()),
      );
  }

  // Add workout log
  Future<void> addWorkoutLog(WorkoutLog log) async {
    await _box.add(log);
  }

  // Delete workout log
  Future<void> deleteWorkoutLog(dynamic key) async {
    await _box.delete(key);
  }

  // Update workout log
  Future<void> updateWorkoutLog(dynamic key, WorkoutLog log) async {
    await _box.put(key, log);
  }

  // Delete all logs for a specific workout
  Future<void> deleteWorkoutLogs(int workoutId) async {
    final keysToDelete = <dynamic>[];
    for (final key in _box.keys) {
      final log = _box.get(key);
      if (log?.workoutId == workoutId) {
        keysToDelete.add(key);
      }
    }

    for (final key in keysToDelete) {
      await _box.delete(key);
    }
  }
}
