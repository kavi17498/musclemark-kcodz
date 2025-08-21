import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musclemark/models/workout.dart';
import '../providers/workout_provider.dart';
import 'package:flutter/material.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${workout.type ?? 'Unknown'}'),
                Text(
                  workout.type?.toLowerCase() == 'bodyweight'
                      ? 'Bodyweight Exercise'
                      : 'Weight: ${workout.weightUsed} kg',
                ),
              ],
            ),
            trailing: workout.type?.toLowerCase() == 'bodyweight'
                ? SizedBox.shrink() // No weight controls for bodyweight
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          final newWeight = _getNextWeight(
                            workout.weightUsed,
                            workout.type,
                            false,
                          );
                          if (newWeight >= 0) {
                            _updateWorkoutWeight(viewModel, workout, newWeight);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          final newWeight = _getNextWeight(
                            workout.weightUsed,
                            workout.type,
                            true,
                          );
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
      type: workout.type,
    );

    // Update using the view model which should trigger UI refresh
    viewModel.updateWorkout(updatedWorkout);
  }

  // Get increment amount based on workout type
  double _getIncrementAmount(String? type) {
    switch (type?.toLowerCase()) {
      case 'dumbbell':
        return 5.0; // 5kg increments for dumbbells
      case 'barbell':
      case 'plates':
        return 1.25; // 1.25kg increments for plates/barbell
      case 'machine':
        return 5.0; // 5kg increments for machines
      case 'cable':
        return 2.5; // 2.5kg increments for cables
      case 'bodyweight':
        return 0.0; // No weight increment for bodyweight
      default:
        return 1.25; // Default increment
    }
  }

  // Get next weight based on workout type
  double _getNextWeight(double currentWeight, String? type, bool isIncrease) {
    final increment = _getIncrementAmount(type);

    if (type?.toLowerCase() == 'bodyweight') {
      return currentWeight; // No weight change for bodyweight exercises
    }

    if (type?.toLowerCase() == 'dumbbell') {
      // Dumbbell progression: 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60+
      final dumbbellWeights = [
        0,
        5,
        10,
        15,
        20,
        25,
        30,
        35,
        40,
        45,
        50,
        55,
        60,
        65,
        70,
        75,
        80,
      ];
      final currentIndex = dumbbellWeights.indexWhere(
        (w) => w >= currentWeight,
      );

      if (isIncrease) {
        if (currentIndex < dumbbellWeights.length - 1) {
          return dumbbellWeights[currentIndex + 1].toDouble();
        } else {
          return currentWeight + 5; // Continue with 5kg increments above 80kg
        }
      } else {
        if (currentIndex > 0) {
          return dumbbellWeights[currentIndex - 1].toDouble();
        } else {
          return 0;
        }
      }
    }

    // For other types, use regular increment/decrement
    if (isIncrease) {
      return currentWeight + increment;
    } else {
      return (currentWeight - increment).clamp(0.0, double.infinity);
    }
  }

  void _showAddWorkoutDialog(BuildContext context, dynamic viewModel) {
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    String selectedType = 'Dumbbell';

    final workoutTypes = [
      'Dumbbell',
      'Barbell',
      'Plates',
      'Machine',
      'Cable',
      'Bodyweight',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Workout'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Workout Name',
                        hintText: 'e.g., Push Ups, Bench Press, etc.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Workout Type',
                        border: OutlineInputBorder(),
                      ),
                      items: workoutTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(
                        labelText: selectedType == 'Bodyweight'
                            ? 'Starting Weight (optional)'
                            : 'Starting Weight (kg)',
                        hintText: selectedType == 'Bodyweight'
                            ? 'Leave empty for bodyweight'
                            : 'Enter starting weight',
                        border: OutlineInputBorder(),
                        suffixText: selectedType == 'Bodyweight' ? '' : 'kg',
                      ),
                      keyboardType: TextInputType.number,
                      enabled: selectedType != 'Bodyweight',
                    ),
                    if (selectedType != 'Bodyweight') ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Weight Progression Info:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _getProgressionInfo(selectedType),
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
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

                    if (name.isNotEmpty) {
                      final weight = selectedType == 'Bodyweight'
                          ? 0.0
                          : (double.tryParse(weightText) ?? 0.0);

                      final newWorkout = Workout(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: name,
                        weightUsed: weight,
                        type: selectedType,
                      );
                      viewModel.addWorkout(newWorkout);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a workout name'),
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
      },
    );
  }

  String _getProgressionInfo(String type) {
    switch (type.toLowerCase()) {
      case 'dumbbell':
        return 'Progression: 5kg → 10kg → 15kg → 20kg → 25kg...';
      case 'barbell':
      case 'plates':
        return 'Progression: +1.25kg → +2.5kg → +5kg → +10kg...';
      case 'machine':
        return 'Progression: +5kg increments (varies by machine)';
      case 'cable':
        return 'Progression: +2.5kg increments';
      case 'bodyweight':
        return 'Progress by increasing reps/sets or adding resistance';
      default:
        return 'Standard weight progression';
    }
  }
}
