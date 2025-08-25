import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/workout_log_view_model.dart';
import '../models/workoutLog.dart';

final workoutLogProvider =
    NotifierProvider<WorkoutLogViewModel, List<WorkoutLog>>(
      WorkoutLogViewModel.new,
    );
