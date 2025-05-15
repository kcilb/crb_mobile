import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingScreen1({
    super.key,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
            'Your Financial Health Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Monitor your credit score and get alerts about important changes to your financial profile',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSkip,
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: onNext,
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
                  'Next',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingScreen2({
    super.key,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
            'Backed by Financial Experts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Our algorithms are designed by financial experts to give you the most accurate credit insights',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSkip,
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: onNext,
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
                  'Next',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen3 extends StatelessWidget {
  final VoidCallback onGetStarted;

  const OnboardingScreen3({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
            'Share Financial Insights',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Share your credit progress with trusted advisors or family members to get better financial advice',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGetStarted,
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
                "Let's Go",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
