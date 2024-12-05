import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String currentProgress;
  final String totalProgress;
  final IconData currentProgressIcon; // Icon for current progress
  final IconData totalProgressIcon; // Icon for total progress
  final IconData titleIcon; // Icon next to the title

  const ProgressCard({
    super.key,
    required this.title,
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
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     blurRadius: 1,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
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
                        'Current Progress',
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
              Column(
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
                        'Total Progress',
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
              ),
            ],
          ),
          const SizedBox(height: 30),
          LinearProgressIndicator(
            value: 0.7, // Replace with dynamic progress value
            backgroundColor: Colors.grey[300],
            color: const Color(0xFF4A5EE4),
          ),
        ],
      ),
    );
  }
}
