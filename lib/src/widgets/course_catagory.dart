import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CourseCategoryCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final String imageUrl;

  const CourseCategoryCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl, // Replace with the correct image
              height: 50,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
