import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brooklynbs/src/Theme/themedata.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:brooklynbs/src/services/auth_manager.dart';
import 'src/pages/home.dart';
import 'src/pages/login.dart';
import 'src/pages/onboarding.dart';
import 'src/provider/user_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

class MyApp extends ConsumerStatefulWidget {
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
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool? _isFirstTime;

  @override
  void initState() {
    super.initState();

    _isFirstTime = widget.isFirstTime;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FlutterNativeSplash.remove();

      // if (_isFirstTime == true) {
      //   await widget.prefs.setBool('isFirstTime', false);
      //   setState(() {
      //     _isFirstTime = false;
      //   });
      // }

      Future.delayed(const Duration(milliseconds: 300), () {
        if (widget.isLoggedIn && ref.read(userStateProvider) == null) {
          AuthManager.autoLogin(ref);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildAppWithAdaptiveTheme(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => _isFirstTime == true
                ? OnBoardingPage(
                    onboardingComplete: () {
                      setState(() {
                        _isFirstTime = false;
                      });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.isLoggedIn
                              ? const HomePageWithNav()
                              : const LoginPage(),
                        ),
                      );
                    },
                  )
                : (ref.watch(userStateProvider) != null
                    ? const HomePageWithNav()
                    : const LoginPage()),
          );
        },
      ),
      savedThemeMode: widget.savedThemeMode,
    );
  }
}
