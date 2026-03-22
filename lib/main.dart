import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:crb_mobile/modules/auth/user_auth.dart';
import 'package:crb_mobile/modules/splash-screen/onboarding_page.dart';
import 'package:crb_mobile/modules/splash-screen/splash_screen.dart';
import 'package:flutter/material.dart';

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
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryBlue,
          primary: kPrimaryBlue,
        ),
        textTheme: const TextTheme().apply(
          bodyColor: Colors.grey[800],
          displayColor: Colors.black,
          fontFamily: 'Roboto',
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: kFieldLabelStyle,
          floatingLabelStyle: kFieldLabelStyle,
          hintStyle: TextStyle(
            color: kFieldTextColor.withOpacity(0.65),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: kPrimaryBlue,
          selectionColor: kPrimaryBlue.withOpacity(0.28),
          selectionHandleColor: kPrimaryBlue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryBlue,
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
      routes: {
        '/login': (context) => const UserAuth(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOnboarding = false;

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserAuth()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingPage(onComplete: _goToLogin);
    }
    return SplashScreen(
      onSkipPressed: _goToLogin,
      onNextPressed: () => setState(() => _showOnboarding = true),
    );
  }
}
