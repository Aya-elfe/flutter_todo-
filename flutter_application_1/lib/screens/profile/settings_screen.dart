import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';
  ThemeMode _themeMode = ThemeMode.dark;
  String _selectedTypography = 'Default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Settings',
            [
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: const Text('Change app color'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () => _showColorPicker(),
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Change app typography'),
                trailing: Text(_selectedTypography),
                onTap: () => _showTypographyPicker(),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Change app language'),
                trailing: Text(_selectedLanguage),
                onTap: () => _showLanguagePicker(),
              ),
            ],
          ),
          _buildSection(
            'Import',
            [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Import from Google calendar'),
                onTap: () {
                  // TODO: Implement Google Calendar import
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose app color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildColorOption(Colors.purple),
            _buildColorOption(Colors.blue),
            _buildColorOption(Colors.green),
            _buildColorOption(Colors.orange),
            _buildColorOption(Colors.red),
            _buildColorOption(Colors.pink),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement color change
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return InkWell(
      onTap: () {
        // TODO: Implement color selection
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void _showTypographyPicker() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose typography'),
        children: [
          _buildTypographyOption('Default'),
          _buildTypographyOption('Modern'),
          _buildTypographyOption('Classic'),
          _buildTypographyOption('Casual'),
        ],
      ),
    );
  }

  Widget _buildTypographyOption(String name) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedTypography = name;
        });
        Navigator.pop(context);
      },
      child: Text(
        name,
        style: TextStyle(
          fontWeight:
              _selectedTypography == name ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose language'),
        children: [
          _buildLanguageOption('English'),
          _buildLanguageOption('Spanish'),
          _buildLanguageOption('French'),
          _buildLanguageOption('German'),
          _buildLanguageOption('Chinese'),
          _buildLanguageOption('Japanese'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
      child: Text(
        language,
        style: TextStyle(
          fontWeight:
              _selectedLanguage == language ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}