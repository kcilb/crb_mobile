import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'onboarding_screens.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skipToEnd() {
    widget.onComplete();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kThemeBg,
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: kOnboardingScaffoldGradient),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: OnboardingWaveBackgroundPainter(),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      'CreditTrack',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: Color.lerp(kPrimaryBlue, Colors.white, 0.55)!
                            .withOpacity(0.85),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      children: [
                        OnboardingScreen1(
                          onNext: _nextPage,
                          onSkip: _skipToEnd,
                          activePage: _currentPage,
                        ),
                        OnboardingScreen2(
                          onNext: _nextPage,
                          onSkip: _skipToEnd,
                          activePage: _currentPage,
                        ),
                        OnboardingScreen3(
                          onGetStarted: _nextPage,
                          onSkip: _skipToEnd,
                          activePage: _currentPage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
