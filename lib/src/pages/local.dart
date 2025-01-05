import 'package:clean_one/src/model/user_model.dart';
import 'package:clean_one/src/pages/course.dart';
import 'package:clean_one/src/pages/payment.dart';
import 'package:clean_one/src/widgets/fullform.dart';
import 'package:clean_one/src/widgets/popup_dialog.dart';
import 'package:clean_one/src/widgets/progress_card.dart';
import 'package:clean_one/src/widgets/request.dart';
import 'package:clean_one/src/widgets/simple_form.dart';
import 'package:clean_one/src/widgets/widget_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_provider.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  void _openForm(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CombinedForm(user: user); // Use CombinedForm
      },
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
            const SizedBox(width: 16),
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
                const SizedBox(height: 7),
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
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
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
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: OldRequestsWidget(
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
                                builder: (context) => const OldRequestsPage()),
                          );
                        },
                      ),
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

class OldRequestsPage extends StatelessWidget {
  const OldRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: const Text('All Requests'),
      ),
      body: Center(
        child: const Text('OLD REQUESTS PAGE'),
      ),
    );
  }
}
