import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthController extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isAuthenticated = false;
  User? _currentUser;
  String? _error;

  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get error => _error;

  // Replace with your machine's IP address (e.g., 'http://192.168.x.x:8080/users')
  final String _baseUrl = 'http://localhost:8080/users';

  AuthController() {
    _initialize();
  }
 Future<void> _initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUserId = prefs.getString('userId');
      final storedUsername = prefs.getString('username');
      
      if (storedUserId != null && storedUsername != null) {
        _currentUser = User(
          id: int.parse(storedUserId), // Convert userId to int
          username: storedUsername,
          email: '', // Update if email is stored locally
          name: storedUsername, // Update if name is stored locally
        );
        _isAuthenticated = true;
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final uri = Uri.parse('$_baseUrl/login');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Login request to $uri');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final userId = data['userId']; // Backend returns userId as int
        if (userId == null) {
          throw Exception('Login failed: Missing userId');
        }

        // Store user details in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId.toString()); // Store as String
        await prefs.setString('username', username);

        // Update current user and authentication state
        _currentUser = User(
          id: userId, // userId is already an int
          username: username,
          email: data['email'] ?? '',
          name: data['name'] ?? username,
        );
        _isAuthenticated = true;
        notifyListeners();
      } else {
        print('Error: ${response.body}');
        throw Exception('Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Login error: $e');
      _error = e.toString();
      rethrow;
    }
  }
  Future<void> register(String username, String email, String password) async {
    try {
      _error = null;
      final uri = Uri.parse('$_baseUrl/register');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      print('Register request to $uri');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _currentUser = User(
          id: data['userId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          username: username,
          email: email,
          name: username,
        );
        _isAuthenticated = true;
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: Check input fields');
      } else {
        throw Exception('Registration failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Register error: $e');
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _error = null;
      // Simulate API logout or clear local session
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
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
