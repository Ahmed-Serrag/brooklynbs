import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

// Light Theme Data (based on website)
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,

  primaryColor: const Color(0xFF000000), // Deep Black
  secondaryHeaderColor: const Color(0xFFF2F3F5),
  primaryColorLight: Color(0xFF012868),
  canvasColor: const Color.fromRGBO(153, 57, 66, 100),
  splashColor: const Color(0xFF000000),
  scaffoldBackgroundColor: const Color(0xFF012868), // Light Greyish Background
  cardColor: const Color(0xFFFFFFFF),
  dialogBackgroundColor: Colors.grey[100], // Light Greyish Background
  iconTheme: const IconThemeData(color: Color(0xFF012868)), // Dark Icons

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Dark Text for readability
    bodyMedium: TextStyle(color: Colors.black), // Dark Text for readability
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFD4AF37), // Gold Button Color
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF012868), // Deep Blue for AppBar background
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.white),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFF000000), // Light text color on buttons
      backgroundColor: const Color(0xFFF2F3F5), // Gold button color
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, // You can customize this as needed
  ).copyWith(
    secondary: const Color(0xFFD4AF37), // Secondary Color as Gold
    brightness: Brightness.light, // Ensure brightness matches
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,

  primaryColor: const Color(0xFFE4E6EB), // Gold Accent
  secondaryHeaderColor: const Color(0xFF242526),
  primaryColorLight: Colors.white,
  splashColor: Colors.white,
  cardColor: const Color(0xFF1A1A1A), // Slightly lighter dark for cards
  iconTheme:
      const IconThemeData(color: Color.fromRGBO(1, 40, 104, 1)), // Light Icons

  scaffoldBackgroundColor:
      const Color(0xFF012868), // Dark Grey/Black Background
  dialogBackgroundColor: Colors.grey[800],
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Light Text for contrast
    bodyMedium: TextStyle(color: Colors.white), // Light Text for contrast
  ),

  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFD4AF37), // Gold Button Color
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF012868), // Deep Blue for AppBar background
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFFF0F0F0), // Light text color on buttons
      backgroundColor: const Color(0xFF242526), // Gold button color
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, // You can customize this as needed
  ).copyWith(
    secondary: const Color(0xFFD4AF37), // Secondary Color as Gold
    brightness: Brightness.dark, // Ensure brightness matches
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.black,
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.white),
    ),
  ),
);
// Function to wrap your app with AdaptiveTheme
Widget buildAppWithAdaptiveTheme({
  required Widget home,
  required AdaptiveThemeMode? savedThemeMode,
}) {
  return AdaptiveTheme(
    light: lightTheme,
    dark: darkTheme,
    initial: savedThemeMode ?? AdaptiveThemeMode.light, // Ensure default theme
    debugShowFloatingThemeButton: true,
    builder: (lightTheme, darkTheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Brooklyn',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: home,
      );
    },
  );
}
