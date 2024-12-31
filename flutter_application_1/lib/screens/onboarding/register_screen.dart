

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
Future<void> _handleRegister() async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text.trim();
  final confirmPassword = _confirmPasswordController.text.trim();

  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passwords do not match')),
    );
    return;
  }

  try {
    await context.read<AuthController>().register(
      username,
      '$username@example.com', // Assuming email format; adjust as needed
      password,
    );
    Navigator.pushReplacementNamed(context, '/login');
  } on Exception catch (e) {
    final errorMessage = e.toString().contains('Username already exists')
        ? 'Username is already taken'
        : 'Failed to connect to the server';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration failed: $errorMessage')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _usernameController,
              label: 'Username',
              hintText: 'Enter your username',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hintText: 'Confirm your password',
              isPassword: true,
            ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: _handleRegister,
              text: 'Register',
            ),
            const SizedBox(height: 24),
            const Center(child: Text('or')),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                // TODO: Implement Google register
              },
              text: 'Register with Google',
              icon: Image.asset('assets/images/google_icon.png', height: 24),
              backgroundColor: AppTheme.surfaceColor,
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                // TODO: Implement Apple register
              },
              text: 'Register with Apple',
              icon: const Icon(Icons.apple),
              backgroundColor: AppTheme.surfaceColor,
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Already have an account? Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
