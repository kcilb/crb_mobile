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
      title: 'CRB Express',
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
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
