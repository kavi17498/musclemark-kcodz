import 'package:flutter/material.dart';
import 'package:musclemark/models/workout.dart';
import 'package:musclemark/routes/app_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocDir.path);
  Hive.registerAdapter(WorkoutAdapter());

  await Hive.openBox<Workout>('workouts');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
