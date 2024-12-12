import 'package:clean_one/src/pages/login.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final Function onboardingComplete;

  const OnboardingPage({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the onboarding page!'),
            ElevatedButton(
              onPressed: () {
                // Call the function when onboarding is complete
                onboardingComplete();
                // Navigate to the next screen (e.g., home or login)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Finish Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}
