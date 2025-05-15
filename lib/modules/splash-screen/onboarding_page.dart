import 'package:flutter/material.dart';
import 'onboarding_screens.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingPage({super.key, required this.onComplete});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skipToEnd() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              OnboardingScreen1(onSkip: _skipToEnd, onNext: _nextPage),
              OnboardingScreen2(onSkip: _skipToEnd, onNext: _nextPage),
              OnboardingScreen3(onGetStarted: _nextPage),
            ],
          ),
          Positioned(
            top: 60,
            right: 24,
            child: TextButton(
              onPressed: _skipToEnd,
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
