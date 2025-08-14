import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musclemark/models/workout.dart';
import '../providers/workout_provider.dart';
import 'package:flutter/material.dart';

class WorkoutScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutProvider);
    final viewModel = ref.read(workoutProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Workouts')),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return ListTile(
            title: Text(workout.name),
            subtitle: Text('Weight: ${workout.weightUsed} kg'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    final newWeight = workout.weightUsed - 1.25;
                    if (newWeight >= 0) {
                      _updateWorkoutWeight(viewModel, workout, newWeight);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final newWeight = workout.weightUsed + 1.25;
                    _updateWorkoutWeight(viewModel, workout, newWeight);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddWorkoutDialog(context, viewModel);
        },
      ),
    );
  }

  void _updateWorkoutWeight(
    dynamic viewModel,
    Workout workout,
    double newWeight,
  ) {
    // Create a new workout object with updated weight
    final updatedWorkout = Workout(
      id: workout.id,
      name: workout.name,
      weightUsed: newWeight,
    );

    // Update using the view model which should trigger UI refresh
    viewModel.updateWorkout(updatedWorkout);
  }

  void _showAddWorkoutDialog(BuildContext context, dynamic viewModel) {
    final nameController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  hintText: 'e.g., Push Ups, Squats, etc.',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'Enter weight in kg',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final weightText = weightController.text.trim();

                if (name.isNotEmpty && weightText.isNotEmpty) {
                  final weight = double.tryParse(weightText) ?? 0.0;
                  final newWorkout = Workout(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: name,
                    weightUsed: weight,
                  );
                  viewModel.addWorkout(newWorkout);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
