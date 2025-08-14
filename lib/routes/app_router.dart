import 'package:go_router/go_router.dart';
import 'package:musclemark/views/Home.dart';
import 'package:musclemark/views/selectworkout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'home', builder: (context, state) => Home()),
    GoRoute(
      path: '/workout',
      name: 'workout',
      builder: (context, state) => WorkoutScreen(),
    ),
  ],
);
