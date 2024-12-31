import 'dart:convert';
import 'dart:io';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  // Base URL for the API
  final String _baseUrl = 'http://localhost:8080/tasks';

  // Helper to generate Basic Auth header
  Future<String> _basicAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username'); // Retrieve stored username
    final password = prefs.getString('password'); // Retrieve stored password

    if (username == null || password == null) {
      throw Exception('User credentials not found. Please log in again.');
    }

    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }

  // HTTP client with logging middleware
  final HttpWithMiddleware httpClient = HttpWithMiddleware.build(
    middlewares: [
      HttpLogger(logLevel: LogLevel.BODY), // Log requests and responses
    ],
  );

  // Fetch all tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    // Retrieve the userId from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      throw Exception('User not logged in. Please log in again.');
    }

    // Construct the endpoint with the userId
    final url = Uri.parse('$_baseUrl/user/$userId');

    // Retrieve the Basic Auth header
    final basicAuth = await _basicAuthHeader();

    // Make the GET request
    final response = await httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: basicAuth,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tasksJson = json.decode(response.body);
      return tasksJson.cast<Map<String, dynamic>>(); // Cast to List<Map<String, dynamic>>
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

  // Create a new task
  Future<Task> createTask(Task task) async {
    final taskJson = json.encode(task.toJsonForCreate()); // Use toJsonForCreate()
    print('Task JSON to be sent: $taskJson'); // Log the task JSON

    // Retrieve the Basic Auth header
    final basicAuth = await _basicAuthHeader();

    final response = await httpClient.post(
      Uri.parse(_baseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: basicAuth,
      },
      body: taskJson,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.statusCode}');
    }
  }

  // Update an existing task
  Future<Task> updateTask(Task task) async {
    final taskJson = json.encode(task.toJson()); // Use toJson()
    print('Task JSON to be updated: $taskJson'); // Log the task JSON

    // Retrieve the Basic Auth header
    final basicAuth = await _basicAuthHeader();

    final response = await httpClient.put(
      Uri.parse('$_baseUrl/${task.id}'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: basicAuth,
      },
      body: taskJson,
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  }

  // Delete a task
  Future<void> deleteTask(int taskId) async {
    print('Deleting task with ID: $taskId'); // Log task ID being deleted

    // Retrieve the Basic Auth header
    final basicAuth = await _basicAuthHeader();

    final response = await httpClient.delete(
      Uri.parse('$_baseUrl/$taskId'),
      headers: {
        HttpHeaders.authorizationHeader: basicAuth,
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task: ${response.statusCode}');
    }
  }
}
