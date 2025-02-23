import 'package:flutter/material.dart';

class CustomBottomDialog {
  static void showBrooklynBusinessSchoolDialog({
    required BuildContext context,
    String title = 'Welcome to Brooklyn Business School',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: _buildDialogContent(context, title),
        );
      },
    );
  }

  static Widget _buildDialogContent(BuildContext context, String title) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final cardBackground = theme.cardColor;
    final iconColor = theme.iconTheme.color ?? Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.dialogBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(title, textColor),
                const SizedBox(height: 10),
                _buildDescription(textColor),
                const SizedBox(height: 20),
                _buildFeatureGrid(cardBackground, iconColor, textColor),
                const SizedBox(height: 20),
                _buildCloseButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildHeader(String title, Color textColor) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget _buildDescription(Color textColor) {
    return Text(
      'Brooklyn Business School was established in 2009 as an Academy of excellence for the design, delivery, and dissemination of training and professional development programs in various domains, aiming at forming world-class managers, experts, and trainers.',
      style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
      textAlign: TextAlign.justify,
    );
  }

  static Widget _buildFeatureGrid(
      Color cardBackground, Color iconColor, Color textColor) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemWidth = (constraints.maxWidth - 32) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildFeatureItem(Icons.school, 'Professional Instructors',
                itemWidth, cardBackground, iconColor, textColor),
            _buildFeatureItem(
                Icons.card_membership,
                'International Certificate',
                itemWidth,
                cardBackground,
                iconColor,
                textColor),
            _buildFeatureItem(Icons.build, 'Practical Training', itemWidth,
                cardBackground, iconColor, textColor),
            _buildFeatureItem(
                Icons.update,
                'We Provide The Latest Version of Management Knowledge',
                itemWidth,
                cardBackground,
                iconColor,
                textColor),
            _buildFeatureItem(
                Icons.verified,
                'Good Preparation to Pass The Certificate Exam',
                itemWidth,
                cardBackground,
                iconColor,
                textColor),
            _buildFeatureItem(
                Icons.support_agent,
                'Full Consultation After Training',
                itemWidth,
                cardBackground,
                iconColor,
                textColor),
            _buildFeatureItem(
                Icons.description,
                'Provide All Useful Documents & Templates',
                itemWidth,
                cardBackground,
                iconColor,
                textColor),
            _buildFeatureItem(
                Icons.people,
                'All Trainers Are Professional in Management',
                itemWidth,
                cardBackground,
                iconColor,
                textColor),
          ],
        );
      },
    );
  }

  static Widget _buildFeatureItem(IconData icon, String text, double width,
      Color cardBackground, Color iconColor, Color textColor) {
    return SizedBox(
      width: width,
      child: IntrinsicHeight(
        // Ensures all cards have the same height
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCloseButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
