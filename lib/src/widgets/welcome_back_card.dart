import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeBackCard extends StatelessWidget {
  final String username;
  final String profileImageUrl;

  const WelcomeBackCard({
    super.key,
    required this.username,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              username,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
      ],
    );
  }
}
