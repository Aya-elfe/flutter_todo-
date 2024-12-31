/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/common/app_drawer.dart';
import 'home/home_screen.dart';
import 'calendar/calendar_screen.dart';
import 'focus/focus_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = const [
    HomeScreen(),
    CalendarScreen(),
    FocusScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Index',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(Icons.access_time),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}*/

// File: lib/screens/main_navigator.dart
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/main_controller.dart';
import '../controllers/task_controller.dart';
import '../widgets/common/loading_overlay.dart';
import 'home/home_screen.dart';
import 'calendar/calendar_screen.dart';
import 'focus/focus_screen.dart';
import 'profile/profile_screen.dart';
import '../widgets/common/app_drawer.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainController, TaskController>(
      builder: (context, mainController, taskController, _) {
        return LoadingOverlay(
          isLoading: taskController.isLoading,
          child: Scaffold(
            key: mainController.scaffoldKey,
            drawer: const AppDrawer(),
            body: IndexedStack(
              index: mainController.selectedIndex,
              children: const [
                HomeScreen(),
                CalendarScreen(),
                FocusScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: mainController.selectedIndex,
              onDestinationSelected: mainController.setIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.timer_outlined),
                  selectedIcon: Icon(Icons.timer),
                  label: 'Focus',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'addTask',
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/add-task');
                if (result == true) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task added successfully!')),
                  );
                }
              },
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/main_controller.dart';
import '../controllers/task_controller.dart';
import '../widgets/common/loading_overlay.dart';
import 'home/home_screen.dart';
import 'calendar/calendar_screen.dart';
import 'focus/focus_screen.dart';
import 'profile/profile_screen.dart';
import '../widgets/common/app_drawer.dart'; // One consistent drawer

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainController, TaskController>(
      builder: (context, mainController, taskController, _) {
        return LoadingOverlay(
          isLoading: taskController.isLoading,
          child: Scaffold(
            key: mainController.scaffoldKey,
            drawer: const AppDrawer(),  // Ensure this drawer is what you want
            body: IndexedStack(
              index: mainController.selectedIndex,
              children: const [
                HomeScreen(),
                CalendarScreen(),
                FocusScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: mainController.selectedIndex,
              onDestinationSelected: mainController.setIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.timer_outlined),
                  selectedIcon: Icon(Icons.timer),
                  label: 'Focus',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'addTask',
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/add-task');
                if (result == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task added successfully!')),
                  );
                }
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}
