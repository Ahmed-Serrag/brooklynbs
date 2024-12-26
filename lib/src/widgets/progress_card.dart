import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String currentProgress;
  final String totalProgress;
  final String secTitle;
  final String thirdTitle;
  final IconData currentProgressIcon; // Icon for current progress
  final IconData totalProgressIcon; // Icon for total progress
  final IconData titleIcon; // Icon next to the title

  const ProgressCard({
    super.key,
    required this.title,
    required this.secTitle,
    required this.thirdTitle,
    required this.currentProgress,
    required this.totalProgress,
    required this.currentProgressIcon,
    required this.totalProgressIcon,
    required this.titleIcon, // Add the title icon parameter
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: currentTheme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon in the top right corner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: currentTheme.primaryColor,
                ),
              ),
              Icon(
                titleIcon,
                color: currentTheme
                    .primaryColor, // You can change this to any color you like
                size: 24, // Adjust this size based on the image reference
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Current Progress Column
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        currentProgressIcon,
                        color: Colors.grey,
                        size: 24, // Adjust this size as needed
                      ),
                      const SizedBox(width: 8),
                      Text(
                        secTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: currentTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    currentProgress,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              // Total Progress Column
              thirdTitle.isNotEmpty
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              totalProgressIcon,
                              color: Colors.grey,
                              size: 24, // Adjust this size as needed
                            ),
                            const SizedBox(width: 8),
                            Text(
                              thirdTitle,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: currentTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          totalProgress,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: currentTheme.primaryColor,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 1,
                    ),
            ],
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              return SimpleAnimationProgressBar(
                height: 30,
                width: constraints.maxWidth, // Use the full width of the card
                backgroundColor: Colors.grey.shade300,
                foregrondColor: Color(0xFF3BBAFF),
                ratio: 0.5, // Set your progress ratio here
                direction: Axis.horizontal,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 3),
                borderRadius: BorderRadius.circular(10),
              );
            },
          )
        ],
      ),
    );
  }
}
