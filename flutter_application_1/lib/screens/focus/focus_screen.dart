import 'package:flutter/material.dart';
import '../../config/theme.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final List<AppUsage> _appUsage = [
    AppUsage(
      appName: 'Instagram',
      icon: 'assets/insta.png',
      duration: const Duration(hours: 4),
    ),
    AppUsage(
      appName: 'Twitter',
      icon: 'assets/twitter.png',
      duration: const Duration(hours: 3),
    ),
    AppUsage(
      appName: 'Facebook',
      icon: 'assets/fb.png',
      duration: const Duration(hours: 1),
    ),
    AppUsage(
      appName: 'Telegram',
      icon: 'assets/telegram.png',
      duration: const Duration(minutes: 30),
    ),
    AppUsage(
      appName: 'Gmail',
      icon: 'assets/mail.png',
      duration: const Duration(minutes: 45),
    ),
  ];

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Mode'),
      ),
      body: SingleChildScrollView(
        // Utilisation du défilement
        child: Column(
          children: [
            // Timer Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 180, // Taille du cercle
                      height: 180, // Taille du cercle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '00:00', // Placeholder pour le timer
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'While your focus mode is on, all of your notifications will be off',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Ajout du bouton Start Focusing
                    ElevatedButton(
                      onPressed: () {
                        // Action lors du clic sur le bouton
                        // Ici, on peut commencer la minuterie ou toute autre logique
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 16),
                        backgroundColor:
                            AppTheme.primaryColor, // Couleur du bouton
                      ),
                      child: const Text(
                        'Start Focusing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Applications Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Applications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: _appUsage.map((app) {
                      return ListTile(
                        leading: Image.asset(
                          app.icon,
                          width: 32,
                          height: 32,
                        ),
                        title: Text(app.appName),
                        subtitle: Text(
                          'You spent ${app.duration.inHours}h ${app.duration.inMinutes % 60}m on ${app.appName} today',
                        ),
                        trailing: const Icon(Icons.info_outline),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppUsage {
  final String appName;
  final String icon;
  final Duration duration;

  AppUsage({
    required this.appName,
    required this.icon,
    required this.duration,
  });
}
