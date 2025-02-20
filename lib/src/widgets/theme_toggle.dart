import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeToggleOption extends StatefulWidget {
  const ThemeToggleOption({super.key});

  @override
  _ThemeToggleOptionState createState() => _ThemeToggleOptionState();
}

class _ThemeToggleOptionState extends State<ThemeToggleOption> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    // ✅ Ensuring AdaptiveTheme is accessed after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTheme();
    });
  }

  void _loadTheme() {
    final mode = AdaptiveTheme.of(context).mode;
    setState(() {
      isDarkMode = mode == AdaptiveThemeMode.dark;
    });
  }

  void _toggleTheme() {
    final currentMode = AdaptiveTheme.of(context).mode;

    // Toggle theme correctly
    if (currentMode == AdaptiveThemeMode.light) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }

    // Delay updating state to ensure UI refresh
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).secondaryHeaderColor,
        ),
        child: ListTile(
          leading: Icon(
            isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            'Toggle Theme',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) => _toggleTheme(),
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.grey[300],
          ),
          onTap: _toggleTheme,
        ),
      ),
    );
  }
}
