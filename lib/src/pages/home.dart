import 'package:clean_one/src/pages/course.dart';
import 'package:clean_one/src/pages/local.dart';
import 'package:clean_one/src/pages/payment.dart';
import 'package:clean_one/src/pages/profile.dart';
import 'package:clean_one/src/provider/user_provider.dart';
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
  // final int _selectedIndex = 0;

  // List of pages as widgets

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    final widgetOptions = <Widget>[
      const HomePage(),
      const CoursePage(),
      const TransactionsPage(),
      const ProfilePage(),
    ];

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
              tabBackgroundColor: Theme.of(context)
                  .iconTheme
                  .color!, // selected tab background color
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
