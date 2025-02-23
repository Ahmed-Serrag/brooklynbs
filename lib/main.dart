import 'dart:async';

import 'package:brooklynbs/src/pages/reset_password.dart';
import 'package:brooklynbs/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brooklynbs/src/Theme/themedata.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:uni_links3/uni_links.dart';
import 'src/pages/home.dart';
import 'src/pages/login.dart';
import 'src/pages/onboarding.dart';
import 'src/provider/user_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('_isFirstTime') ?? true;

  runApp(
    ProviderScope(
      child: MyApp(
        savedThemeMode: savedThemeMode,
        isFirstTime: isFirstTime,
        prefs: prefs,
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final bool isFirstTime;
  final SharedPreferences prefs;

  MyApp({
    super.key,
    this.savedThemeMode,
    required this.isFirstTime,
    required this.prefs,
  });

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  bool? _isFirstTime;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _isFirstTime = widget.isFirstTime;
    WidgetsBinding.instance.addObserver(this);
    _initDeepLinkListener();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FlutterNativeSplash.remove();

      ref.read(loadingStateProvider).startLoader(context);
      await AuthService().autoLogin(ref);
      ref.read(loadingStateProvider).stopLoader(context); // ✅ Hide Loader
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("Lifecycle state changed to: $state");

    switch (state) {
      case AppLifecycleState.resumed:
        print("App resumed - checking for deep links");
        _initDeepLinkListener();
        // Explicitly check for initial URI when resuming
        getInitialUri().then((uri) {
          if (uri != null) {
            print("Found initial URI on resume: $uri");
            handleDeepLink(uri);
          }
        });
        break;
      case AppLifecycleState.paused:
        print("App paused - cleaning up deep link listener");
        _sub?.cancel();
        break;
      default:
        break;
    }
  }

  void _initDeepLinkListener() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        handleDeepLink(initialUri);
      }
    } catch (e) {
      print("Error getting initial URI: $e");
    }
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      print("Error handling deep link: $err");
    });
  }

  void handleDeepLink(Uri uri) {
    print("Processing deep link: $uri");
    String? token = uri.queryParameters["token"];
    String? email = uri.queryParameters["email"];

    if (token != null && email != null) {
      // Update the deep link state
      ref.read(deepLinkStateProvider.notifier).state = uri;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateProvider);

    ref.listen<Uri?>(deepLinkStateProvider, (previous, current) {
      if (current != null) {
        final token = current.queryParameters['token'];
        final email = current.queryParameters['email'];

        if (token != null && email != null) {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(
                token: token,
                email: email,
              ),
            ),
          );
        }
      }
    });
    return GlobalLoaderOverlay(
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 350),
      overlayColor: Colors.grey.withOpacity(0.1),
      overlayWidgetBuilder: (_) => Center(
        child: Lottie.asset(
          'assets/icons/loading.json',
          width: 250,
          height: 250,
        ),
      ),
      child: buildAppWithAdaptiveTheme(
        home: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                if (_isFirstTime == true) {
                  return OnBoardingPage(
                    onboardingComplete: () async {
                      setState(() {
                        _isFirstTime = false;
                      });

                      await widget.prefs.setBool('_isFirstTime', false);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ref.watch(userStateProvider) != null
                                  ? const HomePageWithNav()
                                  : const LoginPage(),
                        ),
                      );
                    },
                  );
                }
                return user != null
                    ? const HomePageWithNav()
                    : const LoginPage();
              },
            );
          },
        ),
        savedThemeMode: widget.savedThemeMode,
      ),
    );
  }
}
