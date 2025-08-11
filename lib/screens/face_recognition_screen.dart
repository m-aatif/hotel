import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key});

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;
  String _statusMessage = "";

  Future<void> _chooseCameraAndStart() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_front),
              title: const Text("Use Front Camera"),
              onTap: () {
                Navigator.pop(context);
                _startFaceRecognition(CameraDevice.front);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_rear),
              title: const Text("Use Back Camera"),
              onTap: () {
                Navigator.pop(context);
                _startFaceRecognition(CameraDevice.rear);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startFaceRecognition(CameraDevice cameraDevice) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: cameraDevice,
      imageQuality: 85, // optimized for speed
    );

    if (pickedFile == null) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Processing face...';
    });

    try {
      final result = await _apiService.recognizeFaceFromImage(File(pickedFile.path));

      if (result['success'] == true) {
        final isNewGuest = result['is_new_guest'] ?? false;
        final guestName = result['guest_name'] ?? "Guest";
        final greeting = result['message'] ??
            (isNewGuest
                ? "🌟 Hello $guestName, Welcome to Grand Hotel! 🌟"
                : "✨ Welcome Back, $guestName! ✨");

        // Auto play TTS greeting
        await _apiService.textToSpeech(greeting);

        _showAnimatedMessage(
          greeting,
          isNewGuest ? Colors.pinkAccent : Colors.greenAccent,
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      isNewGuest ? const RegisterScreen() : const LoginScreen()),
            );
          },
        );
      } else {
        _showAnimatedMessage(
          "❌ Face not recognized. Please try again.",
          Colors.redAccent,
          () => Navigator.pop(context),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showAnimatedMessage(String text, Color glitterColor, VoidCallback onComplete) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: DefaultTextStyle(
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: glitterColor),
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                text,
                textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                colors: [glitterColor, Colors.white, glitterColor],
              ),
            ],
            totalRepeatCount: 1,
            onFinished: onComplete,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Recognition")),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(_statusMessage),
                ],
              )
            : ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text("Start Recognition"),
                onPressed: _chooseCameraAndStart,
              ),
      ),
    );
  }
}
