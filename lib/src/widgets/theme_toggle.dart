import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeToggleOption extends StatelessWidget {
  const ThemeToggleOption({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Match ProfileOption background
        borderRadius: BorderRadius.circular(12), // Same border radius
      ),
      margin: const EdgeInsets.symmetric(vertical: 4), // Consistent margin
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12), // Consistent padding
      child: InkWell(
        onTap: () {
          AdaptiveTheme.of(context).toggleThemeMode();
        },
        child: Row(
          children: [
            // Icon that changes based on theme
            Icon(
              isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              color: isDarkMode
                  ? Colors.amber
                  : Colors.orange, // Custom icon colors
            ),
            const SizedBox(width: 16),
            // Text
            Text(
              'Toggle Theme',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const Spacer(),
            // Switch with custom colors
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              activeColor:
                  Theme.of(context).primaryColor, // Switch color in dark mode
              inactiveThumbColor:
                  Theme.of(context).primaryColor, // Switch color in light mode
              inactiveTrackColor: Colors.grey[300], // Track color in light mode
            ),
          ],
        ),
      ),
    );
  }
}
