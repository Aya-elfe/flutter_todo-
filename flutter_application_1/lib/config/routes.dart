import 'package:flutter/material.dart';
import '../screens/onboarding/intro_screen.dart';
import '../screens/onboarding/login_screen.dart';
import '../screens/onboarding/register_screen.dart';
import '../screens/main_navigator.dart'; // Make sure this is imported.
import '../screens/home/add_task_screen.dart';
import '../screens/home/edit_task_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/focus/focus_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../models/task.dart'; // Import Task model

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const MainNavigator());
      case '/add-task':
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      case '/edit-task':
        final task = settings.arguments as Task; // Retrieve the Task object
        return MaterialPageRoute(builder: (_) => EditTaskScreen(task: task));
      case '/calendar':
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case '/focus':
        return MaterialPageRoute(builder: (_) => const FocusScreen());
      case '/profile':
  return MaterialPageRoute(builder: (_) => ProfileScreen()); // No 'const'

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
