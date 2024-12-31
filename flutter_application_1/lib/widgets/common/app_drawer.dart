import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Martha Hays'),
            accountEmail: const Text('martha.hays@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          _buildSection(
            context,
            'Tasks',
            [
              DrawerTile(
                icon: Icons.inbox,
                title: 'All Tasks',
                onTap: () => _navigateToTaskList(context, 'all'),
              ),
              DrawerTile(
                icon: Icons.today,
                title: 'Today',
                onTap: () => _navigateToTaskList(context, 'today'),
              ),
              DrawerTile(
                icon: Icons.calendar_today,
                title: 'Upcoming',
                onTap: () => _navigateToTaskList(context, 'upcoming'),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'Categories',
            [
              DrawerTile(
                icon: Icons.work,
                title: 'Work',
                color: Colors.blue,
                count: 5,
                onTap: () => _navigateToCategory(context, 'work'),
              ),
              DrawerTile(
                icon: Icons.school,
                title: 'University',
                color: Colors.orange,
                count: 3,
                onTap: () => _navigateToCategory(context, 'university'),
              ),
              DrawerTile(
                icon: Icons.home,
                title: 'Personal',
                color: Colors.green,
                count: 2,
                onTap: () => _navigateToCategory(context, 'personal'),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'Settings',
            [
              DrawerTile(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              DrawerTile(
                icon: Icons.help_outline,
                title: 'Help & Feedback',
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),
              DrawerTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),
        ...items,
      ],
    );
  }

  void _navigateToTaskList(BuildContext context, String filter) {
    Navigator.pop(context);
    // Implement navigation to filtered task list
  }

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.pop(context);
    // Implement navigation to category
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
              // Implement logout logic
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;
  final Color? color;
  final VoidCallback onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.count,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: count != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: color ?? Colors.grey,
                  fontSize: 12,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}