import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:brooklynbs/src/pages/login.dart';

class OnBoardingPage extends StatefulWidget {
  final VoidCallback onboardingComplete;
  const OnBoardingPage({required this.onboardingComplete, super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(BuildContext context) async {
    widget.onboardingComplete();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _buildImage(String assetName, {double width = 250}) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(
          fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyTextStyle: const TextStyle(fontSize: 18.0, color: Colors.black54),
      imagePadding: const EdgeInsets.all(20),
      contentMargin: const EdgeInsets.symmetric(horizontal: 20),
      pageColor: Theme.of(context).secondaryHeaderColor,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Theme.of(context).secondaryHeaderColor,
          allowImplicitScrolling: true,
          autoScrollDuration: 5000,
          infiniteAutoScroll: true,
          animationDuration: 600,
          done: const Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // ✅ Optional: Add a "Next" button for navigation
          next: const Icon(Icons.arrow_forward),
          skip: const Text("Skip"),
          pages: [
            PageViewModel(
              title: "📅 Booking Exams",
              body: "You can now book exams with ease.",
              image: _buildImage('onboard-1.png', width: screenWidth * 0.7),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "💳 Payments",
              body:
                  "Check your payments, view history, and pay securely with your credit card.",
              image: _buildImage('paying.png', width: screenWidth * 0.9),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "👨‍👩‍👧 Kids and Teens",
              body:
                  "Allow your kids to track stocks and make trades with your approval.",
              image: _buildImage('onboard-2.png', width: screenWidth * 0.7),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "🚀 Join the Future",
              body: "Start your journey with us today!",
              image: _buildImage('MBA_student_female.png',
                  width: screenWidth * 0.7),
              decoration: pageDecoration,
              footer: Center(
                child: SizedBox(
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => _onIntroEnd(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
          onDone: () => widget.onboardingComplete(),
          onSkip: () => _onIntroEnd(context),
          showSkipButton: true,
        ),
      ),
    );
  }
}
