import 'package:flutter/material.dart';
import '../../config/theme.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Martha Hays',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'martha.hays@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildSection(
            'Tasks',
            [
              DrawerItem(
                icon: Icons.inbox,
                title: 'All Tasks',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement all tasks view
                },
              ),
              DrawerItem(
                icon: Icons.today,
                title: 'Today',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement today's tasks view
                },
              ),
              DrawerItem(
                icon: Icons.calendar_today,
                title: 'Upcoming',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement upcoming tasks view
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Lists',
            [
              DrawerItem(
                icon: Icons.work,
                title: 'Work',
                count: 5,
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement work tasks view
                },
              ),
              DrawerItem(
                icon: Icons.school,
                title: 'University',
                count: 3,
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement university tasks view
                },
              ),
              DrawerItem(
                icon: Icons.home,
                title: 'Personal',
                count: 2,
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement personal tasks view
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Settings',
            [
              DrawerItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              DrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...items,
      ],
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
              // TODO: Implement logout logic
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;
  final Color? color;
  final VoidCallback onTap;

  const DrawerItem({
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
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(title),
      trailing: count != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color?.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2),
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