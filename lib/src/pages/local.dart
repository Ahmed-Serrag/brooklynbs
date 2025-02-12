import 'package:brooklynbs/src/model/user_model.dart';
import 'package:brooklynbs/src/pages/loadingscreentest.dart';
import 'package:brooklynbs/src/pages/request_page.dart';
import 'package:brooklynbs/src/widgets/popup_dialog.dart';
import 'package:brooklynbs/src/widgets/progress_card.dart';
import 'package:brooklynbs/src/widgets/request_page.dart';
import 'package:brooklynbs/src/widgets/widget_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_provider.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  void _openForm(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RequestFormPage(user: user), // Navigates to the full page
      ),
    );
  }

  final List<Map<String, String>> oldRequests = [
    {'description': 'Request 1: Lorem', 'status': 'done'},
    {'description': 'Complain 1: Dolor', 'status': 'waiting'},
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);
    final currentTheme = Theme.of(context);

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
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
            const SizedBox(width: 12), // Adjust spacing
            Expanded(
              child: Text(
                'Welcome back\n  ${user.name.split(' ').first}  ${user.name.split(' ').last}',
                style: GoogleFonts.poppins(
                  fontSize: 18, // Reduce font size slightly
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Ensures name does not break layout
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomPopup();
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
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
                    ProgressCard(
                      title: "Course Progress",
                      secTitle: "Course Progress",
                      thirdTitle: "Final Project",
                      currentProgress: "70%",
                      totalProgress: "100%",
                      currentProgressIcon: Icons.check_circle_outline,
                      totalProgressIcon: Icons.assessment,
                      titleIcon: Icons.info_outline,
                      onTitleIconPressed: () {
                        // Navigate to the CoursesPage
                        ref.read(selectedIndexProvider.notifier).state = 1;
                      },
                    ),
                    const SizedBox(height: 10),
                    ProgressCard(
                      title: "Payments Progress",
                      secTitle: "Payments Progress",
                      thirdTitle: "",
                      currentProgress: "70%",
                      totalProgress: "100%",
                      currentProgressIcon: Icons.check_circle_outline,
                      totalProgressIcon: Icons.assessment,
                      titleIcon: Icons.info_outline,
                      onTitleIconPressed: () {
                        // Navigate to the CoursesPage
                        ref.read(selectedIndexProvider.notifier).state = 2;
                      },
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   'Request',
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: currentTheme.primaryColor,
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    OldRequestsWidget(
                      requests: oldRequests,
                      reqIcon: "dynamic",
                      onNewRequestTap: () {
                        _openForm(
                          context,
                          user,
                        ); // Correctly invoke the _openForm method
                      },
                      onCheckOldRequestsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OldRequestsPage(
                                    user: user,
                                  )),
                        );
                      },
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
