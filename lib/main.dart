import 'package:flutter/material.dart';
import 'package:musclemark/models/workout.dart';
import 'package:musclemark/models/workoutLog.dart';
import 'package:musclemark/routes/app_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocDir.path);
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutLogAdapter());

  try {
    await Hive.openBox<Workout>('workouts');
    await Hive.openBox<WorkoutLog>('workoutLogs');
  } catch (e) {
    // If there's an error opening boxes (usually due to data structure changes),
    // delete the old data and recreate the boxes
    print('Error opening Hive boxes, clearing old data: $e');

    // Delete the Hive directory to clear all old data
    try {
      await Hive.deleteBoxFromDisk('workouts');
      await Hive.deleteBoxFromDisk('workoutLogs');
    } catch (deleteError) {
      print('Error deleting old boxes: $deleteError');
    }

    // Reopen the boxes
    await Hive.openBox<Workout>('workouts');
    await Hive.openBox<WorkoutLog>('workoutLogs');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
