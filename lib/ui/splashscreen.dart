//This page contains the splash screen
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to main screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FU Parking',
              style: TextStyle(
                fontSize: 48,
                color: Color(0xFF8B9EFF),
                fontWeight: FontWeight.w900,
              ),
            ),
            // Add your app logo/image here
            const Icon(
              Icons.directions_car,
              size: 100,
              color: Color(0xFF8B9EFF),
            ),
            // Add your app name or loading text
            const Text(
              'Overnight Parking Made Easy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
