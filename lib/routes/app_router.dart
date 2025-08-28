import 'package:go_router/go_router.dart';
import 'package:musclemark/views/BmiView.dart';
import 'package:musclemark/views/Home.dart';
import 'package:musclemark/views/selectworkout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'home', builder: (context, state) => home()),
    GoRoute(
      path: '/workout',
      name: 'workout',
      builder: (context, state) => WorkoutScreen(),
    ),
    GoRoute(path: '/bmi', name: 'bmi', builder: (context, state) => Bmiview()),
  ],
);
