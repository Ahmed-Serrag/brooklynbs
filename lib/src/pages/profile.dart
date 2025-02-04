import 'package:brooklynbs/src/model/user_model.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:brooklynbs/src/widgets/fourm_complain.dart';
import 'package:brooklynbs/src/widgets/profile_option.dart';
import 'package:brooklynbs/src/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  onTap: () => ref.read(userStateProvider.notifier).logout(),
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
                  ;
                }),
            ProfileOption(
                icon: Icons.description,
                title: 'Terms and Conditions',
                onTap: () {
                  CustomBottomDialog.showBrooklynBusinessSchoolDialog(
                      context: context);
                  ;
                }),
          ],
        ),
      ),
    );
  }
}
