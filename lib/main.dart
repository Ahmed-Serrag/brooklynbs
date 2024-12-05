import 'package:clean_one/src/Theme/themedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'src/pages/home.dart';
import 'src/pages/login.dart';
import 'src/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // Wrap your app with ProviderScope here
  runApp(
    ProviderScope(
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the user provider to determine the initial screen
    final user = ref.watch(userStateProvider);

    // Use the buildAppWithAdaptiveTheme function from theme_manager.dart
    return buildAppWithAdaptiveTheme(
      home: user != null ? const HomePageWithNav() : const LoginPage(),
      savedThemeMode: savedThemeMode,
    );
  }
}
