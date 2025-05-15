import 'package:crb_mobile/modules/auth/user_auth.dart';
import 'package:crb_mobile/modules/splash-screen/onboarding_page.dart';
import 'package:crb_mobile/modules/splash-screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'modules/splash-screen/splash_screen.dart';
import 'modules/auth/user_auth.dart';

void main() {
  runApp(const CreditTrackApp());
}

class CreditTrackApp extends StatelessWidget {
  const CreditTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreditTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[800],
          secondary: Colors.blue[600],
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme().apply(
          bodyColor: Colors.grey[800],
          displayColor: Colors.black,
          fontFamily: 'Roboto',
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onComplete: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserAuth()),
        );
      },
    );
  }
}
