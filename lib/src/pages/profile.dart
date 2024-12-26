import 'package:clean_one/src/model/user_model.dart';
import 'package:clean_one/src/provider/user_provider.dart';
import 'package:clean_one/src/widgets/fourm_complain.dart';
import 'package:clean_one/src/widgets/popup_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dialog.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _openForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal adjust for keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ReusableForm(
          onSubmit: (formData) {
            Navigator.of(context).pop(); // Close the modal
            print('Form Data: $formData'); // Handle the form submission
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Form Submitted: ${formData['name']}')),
            );
          },
        );
      },
    );
  }

  static const List<String> languages = [
    "Bangle",
    "English",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Hindi",
    "Arabic",
    "Russian",
    "Portuguese",
    "Japanese",
    "Italian",
  ];

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 70),
          _buildProfileHeader(user),
          const SizedBox(height: 50),
          Expanded(
            child: _buildSettingsSection(
                context, ref, user, backgroundColor, textColor),
          ),
        ],
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

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref,
      UserModel user, Color backgroundColor, Color? textColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileOption(
                    icon: Icons.security,
                    title: 'Manage Account Data',
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => const ChangeUserDetailsPopup(),
                    ),
                  ),
                  ProfileOption(icon: Icons.person, title: 'ID: ${user.stID}'),
                  ProfileOption(
                    icon: Icons.phone,
                    title: user.phone,
                    onTap: () => _openForm(context),
                  ),
                  ProfileOption(
                    icon: Icons.logout_rounded,
                    title: 'Log Out',
                    onTap: () => ref.read(userStateProvider.notifier).logout(),
                  ),
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
          ProfileOption(
              icon: Icons.description,
              title: 'Terms and Conditions',
              onTap: () {
                CustomBottomDialog.showTermsAndConditions(
                    context: context, title: 'Hello world');
              }),
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
