import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clean_one/src/Theme/themedata.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:clean_one/src/services/auth_manager.dart'; // Import AuthManager
import 'src/pages/home.dart';
import 'src/pages/login.dart';
import 'src/pages/onboarding.dart';
import 'src/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get saved theme mode and SharedPreferences
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(
        savedThemeMode: savedThemeMode,
        isFirstTime: isFirstTime,
        prefs: prefs,
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final bool isFirstTime;
  final SharedPreferences prefs;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    this.savedThemeMode,
    required this.isFirstTime,
    required this.prefs,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the user provider to determine the initial screen
    final user = ref.watch(userStateProvider);

    // If user is already logged in, trigger auto-login
    if (isLoggedIn && user == null) {
      AuthManager.autoLogin(ref); // Use the centralized auto-login logic
    }

    return buildAppWithAdaptiveTheme(
      home: isFirstTime
          ? OnBoardingPage(onboardingComplete: () {
              // After onboarding, set 'isFirstTime' to false
              prefs.setBool('isFirstTime', false);
            })
          : (user != null ? const HomePageWithNav() : const LoginPage()),
      savedThemeMode: savedThemeMode,
    );
  }
}
