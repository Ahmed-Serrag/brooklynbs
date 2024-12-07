import 'package:clean_one/src/provider/user_provider.dart';
import 'package:clean_one/src/widgets/popup_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access user state from userStateProvider
    final user = ref.watch(userProvider);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final backgroundColor = Theme.of(context).cardColor;

    if (user.name.isEmpty || user.email.isEmpty) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Show loading indicator until data is loaded
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // const Color(0xFF4A5EE4), // Light background for the lower section
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          // Upper Section with Profile Picture and Name (Purple Background)
          Container(
            // color: const Color(0xFF4A5EE4), // Purple background colo
            child: Column(
              children: [
                // Profile Picture Section
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user.ppURL.isNotEmpty
                        ? user.ppURL
                        : 'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(height: 16),

                // Name and Email Section
                Text(
                  user.name.isNotEmpty ? user.name : 'Unknown Name',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email.isNotEmpty ? user.email : 'Unknown Email',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),

          // Lower Section with Account Settings (White Background and Border Radius)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), // Rounded top-left corner
                  topRight: Radius.circular(30), // Rounded top-right corner
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Settings Section Header (Fixed)
                  Text(
                    'Account Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Wrap only the options in SingleChildScrollView
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileOption(
                              icon: Icons.security,
                              title: 'Manage Account Data',
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const ChangeUserDetailsPopup();
                                    });
                              }),
                          // const ProfileOption(
                          //     icon: Icons.notifications, title: 'Change Email'),
                          // const ProfileOption(
                          //     icon: Icons.access_alarm,
                          //     title: 'Learning reminders'),

                          // ID and Phone Number Section (Under Account Settings)
                          ProfileOption(
                              icon: Icons.person, title: 'ID: ${user.stID}'),
                          ProfileOption(icon: Icons.phone, title: user.phone),
                          ProfileOption(
                              icon: Icons.logout_rounded,
                              title: 'Log Out',
                              onTap: () {
                                ref.read(userStateProvider.notifier).logout();
                              }),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'About Us',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const ProfileOption(
                      icon: Icons.info, title: 'About Brooklyn Academy'),
                  const ProfileOption(
                      icon: Icons.description, title: 'Terms and Conditions'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).secondaryHeaderColor,
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.grey[600]),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: textColor,
            ),
          ),
          trailing: onTap != null
              ? Icon(Icons.chevron_right, color: Colors.grey[600])
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
