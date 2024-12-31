import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfileTap;
  final List<Widget>? additionalActions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onProfileTap,
    this.additionalActions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          (automaticallyImplyLeading
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    if (onMenuPressed != null) {
                      onMenuPressed!();
                    } else {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                )
              : null),
      actions: [
        if (additionalActions != null) ...additionalActions!,
        if (onProfileTap != null) ...[
          GestureDetector(
            onTap: onProfileTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
          ),
        ],
      ],
      elevation: 0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback? onMenuPressed;
  final Function(String)? onSearch;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onMenuPressed,
    this.onSearch,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          if (onMenuPressed != null) {
            onMenuPressed!();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
      ),
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              if (onSearch != null) {
                onSearch!('');
              }
            },
          ),
        ),
        onChanged: onSearch,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomBottomAppBar extends StatelessWidget {
  final List<Widget> children;
  final double height;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomBottomAppBar({
    super.key,
    required this.children,
    this.height = 56.0,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}