import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../models/workoutLog.dart';
import '../providers/workout_log_provider.dart';
import '../providers/workout_provider.dart';

class WorkoutLogScreen extends ConsumerStatefulWidget {
  final Workout workout;

  const WorkoutLogScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  ConsumerState<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends ConsumerState<WorkoutLogScreen> {
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load logs for this workout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutLogProvider.notifier).setWorkoutId(widget.workout.id);
    });
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(workoutLogProvider);
    final logViewModel = ref.read(workoutLogProvider.notifier);
    final stats = logViewModel.getStats();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.workout.name} Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics_outlined),
            onPressed: () => _showStatsDialog(stats),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddLogDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Current workout info card
          _buildWorkoutInfoCard(stats),
          
          // Workout history
          Expanded(
            child: logs.isEmpty
                ? _buildEmptyState()
                : _buildLogsList(logs),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLogDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Workout Session',
      ),
    );
  }

  Widget _buildWorkoutInfoCard(Map<String, dynamic> stats) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workout.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Type: ${widget.workout.type ?? 'Unknown'}'),
                    ],
                  ),
                ),
                if (widget.workout.type?.toLowerCase() != 'bodyweight')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.workout.weightUsed} kg',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
              ],
            ),
            if (stats.isNotEmpty) ...[
              SizedBox(height: 12),
              Row(
                children: [
                  _buildStatChip('Sessions', '${stats['totalSessions']}', Icons.fitness_center),
                  SizedBox(width: 8),
                  if (stats['maxWeight'] > 0)
                    _buildStatChip('Max Weight', '${stats['maxWeight']}kg', Icons.trending_up),
                  SizedBox(width: 8),
                  _buildProgressChip(stats['progressTrend']),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChip(String trend) {
    Color color;
    IconData icon;
    String text;
    
    switch (trend) {
      case 'improving':
        color = Colors.green;
        icon = Icons.trending_up;
        text = 'Improving';
        break;
      case 'declining':
        color = Colors.red;
        icon = Icons.trending_down;
        text = 'Declining';
        break;
      case 'stable':
        color = Colors.orange;
        icon = Icons.trending_flat;
        text = 'Stable';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
        text = 'New';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No workout logs yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first workout session',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(List<WorkoutLog> logs) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('${index + 1}'),
            ),
            title: Text(
              '${log.sets} sets × ${log.reps} reps',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workout.type?.toLowerCase() == 'bodyweight'
                      ? log.weight > 0 
                          ? 'Additional weight: ${log.weight} kg'
                          : 'Bodyweight only'
                      : 'Weight: ${log.weight} kg',
                ),
                Text(
                  _formatDate(log.time),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getProgressIcon(index, logs),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteLog(log),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getProgressIcon(int index, List<WorkoutLog> logs) {
    if (index == logs.length - 1) return SizedBox.shrink();
    
    final current = logs[index];
    final previous = logs[index + 1];
    
    final currentVolume = current.sets * current.reps * current.weight;
    final previousVolume = previous.sets * previous.reps * previous.weight;
    
    if (currentVolume > previousVolume) {
      return Icon(Icons.trending_up, color: Colors.green, size: 20);
    } else if (currentVolume < previousVolume) {
      return Icon(Icons.trending_down, color: Colors.red, size: 20);
    } else {
      return Icon(Icons.trending_flat, color: Colors.grey, size: 20);
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showStatsDialog(Map<String, dynamic> stats) {
    if (stats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data available yet')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Workout Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Total Sessions', '${stats['totalSessions']}'),
            _buildStatRow('Total Volume', '${stats['totalVolume']} kg'),
            if (stats['maxWeight'] > 0) ...[
              _buildStatRow('Max Weight', '${stats['maxWeight']} kg'),
              _buildStatRow('Average Weight', '${stats['averageWeight'].toStringAsFixed(1)} kg'),
            ],
            _buildStatRow('Progress', _getProgressText(stats['progressTrend'])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getProgressText(String trend) {
    switch (trend) {
      case 'improving': return 'Improving 📈';
      case 'declining': return 'Declining 📉';
      case 'stable': return 'Stable ➡️';
      default: return 'New workout';
    }
  }

  void _showAddLogDialog() {
    _setsController.clear();
    _repsController.clear();
    _weightController.text = widget.workout.type?.toLowerCase() == 'bodyweight' 
        ? '0' 
        : widget.workout.weightUsed.toString();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Workout Session'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _setsController,
                decoration: InputDecoration(
                  labelText: 'Sets',
                  hintText: 'Number of sets',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _repsController,
                decoration: InputDecoration(
                  labelText: 'Reps',
                  hintText: 'Reps per set',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              if (widget.workout.type?.toLowerCase() != 'bodyweight')
                TextField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    hintText: 'Weight used',
                    border: OutlineInputBorder(),
                    suffixText: 'kg',
                  ),
                  keyboardType: TextInputType.number,
                )
              else
                TextField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Additional Weight (optional)',
                    hintText: 'Added weight like weighted vest',
                    border: OutlineInputBorder(),
                    suffixText: 'kg',
                    helperText: 'Leave as 0 for bodyweight only',
                  ),
                  keyboardType: TextInputType.number,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addWorkoutLog,
            child: Text('Add Session'),
          ),
        ],
      ),
    );
  }

  void _addWorkoutLog() {
    final sets = int.tryParse(_setsController.text);
    final reps = int.tryParse(_repsController.text);
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    
    if (sets == null || sets <= 0 || reps == null || reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid sets and reps'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final newLog = WorkoutLog(
      time: DateTime.now(),
      weight: weight,
      sets: sets,
      reps: reps,
      workoutId: widget.workout.id,
    );
    
    // Add log
    ref.read(workoutLogProvider.notifier).addWorkoutLog(newLog);
    
    // Update workout weight if it's higher (for non-bodyweight exercises)
    if (widget.workout.type?.toLowerCase() != 'bodyweight' && weight > widget.workout.weightUsed) {
      final updatedWorkout = Workout(
        id: widget.workout.id,
        name: widget.workout.name,
        weightUsed: weight,
        type: widget.workout.type,
      );
      ref.read(workoutProvider.notifier).updateWorkout(updatedWorkout);
    }
    
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout session added!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteLog(WorkoutLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Session'),
        content: Text('Are you sure you want to delete this workout session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(workoutLogProvider.notifier).deleteWorkoutLog(log);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Session deleted'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
