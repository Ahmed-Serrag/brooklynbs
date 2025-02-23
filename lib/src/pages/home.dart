import 'package:brooklynbs/src/pages/course.dart';
import 'package:brooklynbs/src/pages/local.dart';
import 'package:brooklynbs/src/pages/payment.dart';
import 'package:brooklynbs/src/pages/profile.dart';
import 'package:brooklynbs/src/pages/reset_password.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class HomePageWithNav extends ConsumerStatefulWidget {
  const HomePageWithNav({super.key});

  @override
  _HomePageWithNavState createState() => _HomePageWithNavState();
}

class _HomePageWithNavState extends ConsumerState<HomePageWithNav> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final deepLinkUri = ref.watch(deepLinkStateProvider);

    final widgetOptions = <Widget>[
      HomePage(),
      const CoursePage(),
      const TransactionsPage(),
      const ProfilePage(),
    ];

    if (deepLinkUri != null) {
      final token = deepLinkUri.queryParameters["token"];
      final email = deepLinkUri.queryParameters["email"];

      // Navigate to ResetPasswordPage if token and email are available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(
                token: token!,
                email: email!,
              ),
            ),
          );
        }
      });

      // Reset the deep link state to avoid multiple navigations
      ref.read(deepLinkStateProvider.notifier).state = null;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: widgetOptions
            .elementAt(selectedIndex), // Displays content based on selected tab
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          boxShadow: [
            BoxShadow(
              // blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            color: Theme.of(context).cardColor,
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              activeColor: Colors.white, // selected icon and text color
              tabBackgroundColor:
                  Color(0xFF012868), // selected tab background color
              color: Theme.of(context).primaryColor, // unselected icon color
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.file,
                  text: 'Courses',
                ),
                GButton(
                  icon: LineIcons.wallet,
                  text: 'Payments',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  ref.read(selectedIndexProvider.notifier).state =
                      index; // Updates the selected index
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
