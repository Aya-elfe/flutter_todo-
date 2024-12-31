import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_services.dart';

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

 Future<void> loadTasks() async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final response = await _taskService.getTasks();
    print('Raw response: $response'); // Log the raw response
    _tasks = response.map((json) => Task.fromJson(json)).toList();
    print('Parsed tasks: ${_tasks.map((task) => task.toJson())}');
  } catch (e) {
    _error = e.toString();
    print('Error loading tasks: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  Future<void> addTask(Task task) async {
    try {
      final newTask = await _taskService.createTask(task);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await _taskService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async { // Change taskId type to int
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}