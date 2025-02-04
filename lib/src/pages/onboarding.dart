import 'package:flutter/foundation.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  final VoidCallback onboardingComplete;
  const OnBoardingPage({required this.onboardingComplete, super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTime', false);

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
      titleTextStyle: TextStyle(
          fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyTextStyle: TextStyle(fontSize: 18.0, color: Colors.black54),
      imagePadding: EdgeInsets.all(20),
      contentMargin: EdgeInsets.symmetric(horizontal: 20),
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
          pages: [
            PageViewModel(
              title: "📅 Booking Exams",
              body: "You can now book exams with ease.",
              image: _buildImage('booking.png', width: screenWidth * 0.7),
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
              image: _buildImage('bookingexam.png', width: screenWidth * 0.7),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "🚀 Join the Future",
              body: "Start your journey with us today!",
              image: _buildImage('loading.png', width: screenWidth * 0.7),
              decoration: pageDecoration,
              footer: Center(
                // ✅ Center the button
                child: SizedBox(
                  width: 140, // ✅ Set a fixed width for the button
                  height: 40, // ✅ Set a fixed height (optional)
                  child: ElevatedButton(
                    onPressed: () => _onIntroEnd(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 20),
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
          onDone: () => _onIntroEnd(context),
          onSkip: () => _onIntroEnd(context),
          showSkipButton: true,
          skip: Text('Skip',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).scaffoldBackgroundColor)),
          next: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
          ),
          done: Text('Done',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).scaffoldBackgroundColor)),
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: Colors.grey.shade400,
            activeSize: const Size(22.0, 10.0),
            activeColor: Theme.of(context).scaffoldBackgroundColor,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          dotsContainerDecorator:
              const BoxDecoration(color: Colors.transparent),
        ),
      ),
    );
  }
}
