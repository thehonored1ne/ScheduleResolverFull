import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {

  final List<TaskModel>  _tasks = [];
  final Uuid _uuid = const Uuid();

  List<TaskModel> get tasks => _tasks;

  // BUG FIX: Renamed addTasks to addTask to match UI screen calls
  void addTask({
    required String title,
    required String category,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int urgency,
    required int importance,
    required double estimatedEffortHours,
    required String energyLevel
  }) {
    // BUG FIX: Renamed newTasks to newTask for consistency
    final newTask = TaskModel(
        id: _uuid.v4(),
        title: title,
        category: category,
        date: date,
        startTime: startTime,
        endTime: endTime,
        urgency: urgency,
        importance: importance,
        estimatedEffortHours: estimatedEffortHours,
        energyLevel: energyLevel
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  // BUG FIX: Renamed removeTasks to removeTask to match UI screen calls
  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}