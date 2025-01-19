import 'package:flutter/material.dart';

class CustomBottomDialog {
  static void showBrooklynBusinessSchoolDialog({
    required BuildContext context,
    String title = 'Welcome to Brooklyn Business School',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensures height matches content
              children: [
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Brooklyn Business School was established in 2009 as an Academy of excellence for the design, delivery, and dissemination of training and professional development programs in a variety of domains and fields aiming at the formulation of world-class managers, experts, practitioners, and trainers.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                const Divider(),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Dynamically calculate item width based on screen width
                    final itemWidth = (constraints.maxWidth - 36) / 2;
                    return Wrap(
                      spacing: 12, // Space between items horizontally
                      runSpacing: 12, // Space between items vertically
                      children: [
                        _buildFeatureItem(
                          icon: Icons.school,
                          text: 'Professional Instructors',
                          width: itemWidth,
                        ),
                        _buildFeatureItem(
                          icon: Icons.sd_card_alert_outlined,
                          text: 'International Certificate',
                          width: itemWidth,
                        ),
                        _buildFeatureItem(
                          icon: Icons.handyman,
                          text: 'Practical Training',
                          width: itemWidth,
                        ),
                        _buildFeatureItem(
                          icon: Icons.update,
                          text:
                              'We Provide The Latest Version of Management Knowledge',
                          width: itemWidth,
                        ),
                        _buildFeatureItem(
                          icon: Icons.verified,
                          text: 'Good Preparation to Pass The Certificate Exam',
                          width: itemWidth,
                        ),
                        _buildFeatureItem(
                          icon: Icons.support_agent,
                          text: 'Full Consultation After Training',
                          width: itemWidth,
                        ),
                        _buildFeatureItem(
                          icon: Icons.description,
                          text: 'Provide All Useful Documents & Templates',
                          width: itemWidth,
                        ),
                        _buildFeatureItem(
                          icon: Icons.people,
                          text: 'All Trainers Are Professional in Management',
                          width: itemWidth,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required double width,
  }) {
    return Container(
      width: width, // Dynamically set width for uniformity
      height: 100, // Fixed height for consistent layout
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 3, // Allow text to wrap within the height
              overflow: TextOverflow.ellipsis, // Handle overflow gracefully
            ),
          ),
        ],
      ),
    );
  }
}
