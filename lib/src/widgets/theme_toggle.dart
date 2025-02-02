import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeToggleOption extends StatelessWidget {
  const ThemeToggleOption({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
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
            onChanged: (value) {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.grey[300],
          ),
          onTap: () {
            AdaptiveTheme.of(context).toggleThemeMode();
          },
        ),
      ),
    );
  }
}
