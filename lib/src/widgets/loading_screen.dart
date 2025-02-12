import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui'; // Required for the blur effect

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔹 Full-Screen Blurred Background Effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 20, sigmaY: 20), // Apply blur to the entire screen
            child: Container(
              color: Colors.black
                  .withOpacity(0.6), // Semi-transparent black overlay
            ),
          ),
        ),

        // 🔹 Centered Circular Loading Animation
        Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Lottie.asset(
                'assets/icons/blueanddark.json', // Path to your Lottie animation
                width: 180, // Adjust according to your desired size
                height: 180,
                fit: BoxFit.contain, // Ensure animation is correctly contained
                repeat: true,
                animate: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
