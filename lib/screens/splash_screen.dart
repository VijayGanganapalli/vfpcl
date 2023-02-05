import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/screens/landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/company_no_bg_logo.png",
                width: 80,
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                  animatedTexts: [
                    FadeAnimatedText(
                      duration: const Duration(seconds: 12),
                      "VASUDHAIKA",
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 32,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedTextKit(
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
                onFinished: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingScreen(),
                    ),
                  );
                },
                animatedTexts: [
                  WavyAnimatedText(
                    speed: const Duration(milliseconds: 300),
                    "FARMER PRODUCER COMPANY LIMITED",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: primaryColor.withOpacity(0.2),
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
