import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../../config/theme.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest'; // Default to 'Guest' if not found
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              username, // Display the username here
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('10', 'Tasks left'),
                _buildStatCard('5', 'Tasks done'),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Settings',
              [
                SettingsItem(
                  icon: Icons.settings,
                  title: 'App Settings',
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),
            _buildSection(
              'Account',
              [
                SettingsItem(
                  icon: Icons.person_outline,
                  title: 'Change account name',
                  onTap: () => _showChangeNameDialog(context),
                ),
                SettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Change account password',
                  onTap: () => _showChangePasswordDialog(context),
                ),
                SettingsItem(
                  icon: Icons.image_outlined,
                  title: 'Change account Image',
                  onTap: () => _showChangeImageOptions(context),
                ),
              ],
            ),
            _buildSection(
              'Uptodo',
              [
                SettingsItem(
                  icon: Icons.info_outline,
                  title: 'About US',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.feedback_outlined,
                  title: 'Help & Feedback',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.thumb_up_outlined,
                  title: 'Support US',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: AppTheme.errorColor),
              label: const Text(
                'Log out',
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<SettingsItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
void _showChangeNameDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Change account name'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: 'Enter new name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final newName = nameController.text.trim();
            if (newName.isNotEmpty) {
              await _updateUsername(context, newName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Name cannot be empty.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
 // For HttpHeaders

Future<void> _updateUsername(BuildContext context, String newName) async {
  try {
    // Retrieve userId, username, and password from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final username = prefs.getString('username'); // Stored username
    final password = prefs.getString('password'); // Stored password

    if (userId == null || username == null || password == null) {
      throw Exception('User credentials not found. Please log in again.');
    }

    final uri = Uri.parse('http://localhost:8080/users/username/$userId');

    // Construct Basic Auth header
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    // Make the PUT request
    final response = await http.put(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: basicAuth, // Include Basic Auth header
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': newName}), // Encode body as JSON
    );

    if (response.statusCode == 200) {
      // Update the username in SharedPreferences
      await prefs.setString('username', newName);

      // Update the UI
      setState(() {
        this.username = newName;
      });

      // Close the dialog and show success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      throw Exception('Failed to update username: ${response.body}');
    }
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
}
void _showChangePasswordDialog(BuildContext context) {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Change account password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter current password',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter new password',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final currentPassword = currentPasswordController.text.trim();
            final newPassword = newPasswordController.text.trim();

            if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
              await _updatePassword(context, currentPassword, newPassword);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Both fields are required.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

Future<void> _updatePassword(
    BuildContext context, String currentPassword, String newPassword) async {
  try {
    // Retrieve userId, username, and password from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final username = prefs.getString('username'); // Stored username
    final password = prefs.getString('password'); // Stored password

    if (userId == null || username == null || password == null) {
      throw Exception('User credentials not found. Please log in again.');
    }

    final uri = Uri.parse('http://localhost:8080/users/password/$userId');

    // Construct Basic Auth header
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    // Make the PUT request
    final response = await http.put(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: basicAuth, // Include Basic Auth header
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }), // Encode body as JSON
    );

    if (response.statusCode == 200) {
      // Password updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Close the dialog
    } else {
      throw Exception('Failed to update password: ${response.body}');
    }
  } catch (e) {
    Navigator.pop(context); // Close the dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  void _showChangeImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take picture'),
            onTap: () {
              // TODO: Implement camera capture
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () {
              // TODO: Implement gallery picker
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Import from Google Drive'),
            onTap: () {
              // TODO: Implement Google Drive import
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement logout
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
