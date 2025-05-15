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
        duration: const Duration(milliseconds: 500),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
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
              top: 16,
              right: 16,
              child:
                  _currentPage < 2
                      ? TextButton(
                        onPressed: _skipToEnd,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color:
                          _currentPage == index
                              ? Colors.blue[800]
                              : Colors.grey[300],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
