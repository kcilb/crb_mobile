import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onSkipPressed;
  final VoidCallback onNextPressed;

  const SplashScreen({
    super.key,
    required this.onSkipPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CreditTrack',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Financial Health Partner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Access your credit reports, monitor your score, and get personalized financial insights',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onSkipPressed,
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
