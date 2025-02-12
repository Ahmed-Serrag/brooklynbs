import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brooklynbs/src/Theme/themedata.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:brooklynbs/src/services/auth_manager.dart';
import 'package:brooklynbs/src/provider/loading_state.dart'; // ✅ Import Global Loader Provider
import 'src/pages/home.dart';
import 'src/pages/login.dart';
import 'src/pages/onboarding.dart';
import 'src/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

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

      ref.read(loadingStateProvider).startLoader(context); // ✅ Show Loader

      await Future.delayed(const Duration(milliseconds: 300), () async {
        if (widget.isLoggedIn && ref.read(userStateProvider) == null) {
          await AuthManager.autoLogin(ref);
        }
      });

      ref.read(loadingStateProvider).stopLoader(context); // ✅ Hide Loader
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
      overlayColor: Colors.grey.withOpacity(0.8),
      overlayWidgetBuilder: (_) => Center(
        child: Lottie.asset(
          'assets/icons/loading.json',
          width: 250,
          height: 250,
        ),
      ),
      child: buildAppWithAdaptiveTheme(
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
      ),
    );
  }
}
