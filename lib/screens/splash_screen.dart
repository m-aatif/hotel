import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'face_recognition_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Face Recognition after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FaceRecognitionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/hotel_bg.jpg', // <-- Replace with your hotel image
            fit: BoxFit.cover,
          ),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.4)),

          // Centered logo and text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon
              Image.asset(
                'assets/hotel_logo.png', // <-- Replace with your logo
                height: 120,
              ),
              const SizedBox(height: 20),

              // Animated Text
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Welcome to Grand Hotel'),
                    TypewriterAnimatedText('Your Luxury Stay Awaits'),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
