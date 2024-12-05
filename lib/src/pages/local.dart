import 'package:clean_one/src/widgets/popup_dialog.dart';
import 'package:clean_one/src/widgets/progress_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access user data from userStateProvider
    final user = ref.watch(userStateProvider);
    final currentTheme = Theme.of(context);

    if (user == null) {
      return const Center(
        child:
            CircularProgressIndicator(), // Show loading indicator if user is null
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // AppBar content for welcome message, name, and avatar
        title: Row(
          children: [
            // Avatar on the Leading
            GestureDetector(
              onTap: () {
                // Change the selected tab index to 3 (Profile)
                ref.read(selectedIndexProvider.notifier).state = 3;
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  user.ppURL.isNotEmpty
                      ? user.ppURL
                      : 'https://via.placeholder.com/150',
                ),
              ),
            ),
            const SizedBox(width: 16), // Space between avatar and text

            // Welcome Back and Name in the Center
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '${user.name.split(' ').first} ${user.name.split(' ').last}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const Spacer(), // Push Notification Icon to the right

            // Notification Icon on the Action Section
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomPopup(); // Your custom popup widget
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // White Rounded Section for Lower Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: currentTheme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Progress Card Positioned at the Top
                    const ProgressCard(
                      title: "Course Progress",
                      currentProgress: "70%",
                      totalProgress: "100%",
                      currentProgressIcon: Icons.check_circle_outline,
                      totalProgressIcon: Icons.assessment,
                      titleIcon: Icons.info_outline,
                    ),
                    const SizedBox(height: 20),

                    // Recommendations Section
                    Text(
                      'Recommendation',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const ProgressCard(
                      title: "Project Progress",
                      currentProgress: "70%",
                      totalProgress: "100%",
                      currentProgressIcon: Icons.check_circle_outline,
                      totalProgressIcon: Icons.assessment,
                      titleIcon: Icons.info_outline,
                    ),
                    const SizedBox(height: 15),

                    // Request Section
                    Text(
                      'Request',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const ProgressCard(
                      title: "Project Progress",
                      currentProgress: "70%",
                      totalProgress: "100%",
                      currentProgressIcon: Icons.check_circle_outline,
                      totalProgressIcon: Icons.assessment,
                      titleIcon: Icons.info_outline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
