import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workoutLog.dart';
import '../services/workout_log_service.dart';

class WorkoutLogViewModel extends Notifier<List<WorkoutLog>> {
  final WorkoutLogService _service = WorkoutLogService();
  int _currentWorkoutId = 0;

  @override
  List<WorkoutLog> build() {
    return [];
  }

  void setWorkoutId(int workoutId) {
    _currentWorkoutId = workoutId;
    _loadLogs();
  }

  void _loadLogs() {
    state = _service.getWorkoutLogs(_currentWorkoutId);
  }

  Future<void> addWorkoutLog(WorkoutLog log) async {
    // Add to state immediately for real-time UI update
    final currentLogs = List<WorkoutLog>.from(state);
    currentLogs.add(log);
    currentLogs.sort(
      (a, b) => (b.time ?? DateTime.now()).compareTo(a.time ?? DateTime.now()),
    );
    state = currentLogs;

    // Save to storage
    await _service.addWorkoutLog(log);
  }

  Future<void> deleteWorkoutLog(WorkoutLog log) async {
    // Remove from state immediately
    final currentLogs = List<WorkoutLog>.from(state);
    currentLogs.removeWhere((l) => l.key == log.key);
    state = currentLogs;

    // Delete from storage
    await _service.deleteWorkoutLog(log.key);
  }

  void refresh() {
    _loadLogs();
  }

  // Get statistics
  Map<String, dynamic> getStats() {
    if (state.isEmpty) return {};

    final logs = state;
    final totalSessions = logs.length;
    final totalVolume = logs.fold<double>(
      0,
      (sum, log) => sum + (log.sets * log.reps * log.weight),
    );
    final averageWeight =
        logs.fold<double>(0, (sum, log) => sum + log.weight) / totalSessions;

    final maxWeight = logs
        .map((log) => log.weight)
        .reduce((a, b) => a > b ? a : b);
    final lastWeight = logs.isNotEmpty ? logs.first.weight : 0.0;

    return {
      'totalSessions': totalSessions,
      'totalVolume': totalVolume.round(),
      'averageWeight': averageWeight,
      'maxWeight': maxWeight,
      'lastWeight': lastWeight,
      'progressTrend': _calculateProgressTrend(),
    };
  }

  String _calculateProgressTrend() {
    if (state.length < 2) return 'insufficient_data';

    final recent = state.take(3).toList();
    final older = state.skip(3).take(3).toList();

    if (older.isEmpty) return 'insufficient_data';

    final recentAvg =
        recent.fold<double>(
          0,
          (sum, log) => sum + (log.sets * log.reps * log.weight),
        ) /
        recent.length;

    final olderAvg =
        older.fold<double>(
          0,
          (sum, log) => sum + (log.sets * log.reps * log.weight),
        ) /
        older.length;

    final improvement = ((recentAvg - olderAvg) / olderAvg) * 100;

    if (improvement > 5) return 'improving';
    if (improvement < -5) return 'declining';
    return 'stable';
  }
}
