import 'dart:ui';
import 'package:brooklynbs/src/model/user_model.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:brooklynbs/src/widgets/fourm_complain.dart';
import 'package:brooklynbs/src/widgets/profile_option.dart';
import 'package:brooklynbs/src/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../widgets/dialog.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _openForm(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal adjust for keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ReusableForm(user: user),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final backgroundColor = Theme.of(context).cardColor;

    if (user == null || user.name.isEmpty || user.email.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(user),
            const SizedBox(height: 16),
            Expanded(
              child: _buildScrollableSettings(
                  context, ref, user, backgroundColor, textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            user.ppURL.isNotEmpty
                ? user.ppURL
                : 'https://via.placeholder.com/150',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableSettings(BuildContext context, WidgetRef ref,
      UserModel user, Color backgroundColor, Color? textColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                ProfileOption(
                  icon: Icons.security,
                  title: 'Manage Account Data',
                  onTap: () => _openForm(context, user),
                ),
                ProfileOption(icon: Icons.person, title: 'ID: ${user.stID}'),
                const ThemeToggleOption(),
                ProfileOption(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  onTap: () => _showLogoutConfirmationDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'About Us',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 7),
            ProfileOption(
                icon: Icons.info,
                title: 'About Brooklyn Academy',
                onTap: () {
                  CustomBottomDialog.showBrooklynBusinessSchoolDialog(
                      context: context);
                }),
            ProfileOption(
                icon: Icons.description,
                title: 'Terms and Conditions',
                onTap: () {
                  CustomBottomDialog.showBrooklynBusinessSchoolDialog(
                      context: context);
                }),
          ],
        ),
      ),
    );
  }
}

/// **✅ Fixed Logout Confirmation Dialog with Loading & Navigation**
void _showLogoutConfirmationDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Confirm Logout",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to log out?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first

                // Show loading overlay
                if (context.mounted) {
                  context.loaderOverlay.show();
                }

                // Perform logout
                await ref.read(userStateProvider.notifier).logout(context, ref);

                // Ensure the widget is still mounted before navigation
                if (context.mounted) {
                  context.loaderOverlay.hide(); // Hide loader
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LoginPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
              child: const Text("Log Out",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      );
    },
  );
}
