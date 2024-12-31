

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../config/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfileTap;
  final bool showProfileButton;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onMenuPressed,
    this.onProfileTap,
    this.showProfileButton = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().currentUser;
    
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuPressed ?? () {
          Scaffold.of(context).openDrawer();
        },
      ),
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      actions: [
        if (actions != null) ...actions!,
        if (showProfileButton) ...[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: onProfileTap,
              child: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: user?.photoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user!.photoUrl!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
