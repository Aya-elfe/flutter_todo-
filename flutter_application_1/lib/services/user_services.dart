import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://localhost:8080/users';

  // Dynamic authentication using stored username and password
  String _generateBasicAuth(String username, String password) {
    return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }

  Future<bool> updateUsername(String userId, String newUsername, String username, String password) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$userId/username?username=$newUsername'),
      headers: {
        HttpHeaders.authorizationHeader: _generateBasicAuth(username, password),
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update username: ${response.statusCode}');
      return false;
    }
  }
}
