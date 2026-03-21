import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Business-themed Lottie JSONs in `assets/lottie/onboarding_business_*.json`.

/// Pastel card + circular Lottie + copy + dots + Skip / primary CTA (reference layout).
class OnboardingBase extends StatelessWidget {
  const OnboardingBase({
    super.key,
    required this.lottieAsset,
    required this.cardColor,
    required this.activePage,
    required this.title,
    required this.description,
    required this.onNext,
    required this.onSkip,
    required this.buttonText,
    this.showSkip = true,
  });

  final String lottieAsset;
  final Color cardColor;

  /// Currently visible page from [PageView] (for dot indicators).
  final int activePage;
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final String buttonText;
  final bool showSkip;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: _PastelOnboardingCard(
            lottieAsset: lottieAsset,
            cardColor: cardColor,
            activePage: activePage,
            title: title,
            description: description,
            onNext: onNext,
            onSkip: onSkip,
            buttonText: buttonText,
            showSkip: showSkip,
          ),
        ),
      ),
    );
  }
}

class _PastelOnboardingCard extends StatelessWidget {
  const _PastelOnboardingCard({
    required this.lottieAsset,
    required this.cardColor,
    required this.activePage,
    required this.title,
    required this.description,
    required this.onNext,
    required this.onSkip,
    required this.buttonText,
    required this.showSkip,
  });

  final String lottieAsset;
  final Color cardColor;
  final int activePage;
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final String buttonText;
  final bool showSkip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: kThemeBg.withOpacity(0.35),
              blurRadius: 28,
              offset: const Offset(0, 16),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: kPrimaryBlue.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Lottie (faint ring like reference)
              Hero(
                tag: lottieAsset,
                child: Material(
                  color: Colors.transparent,
                  child: _CircularLottieFrame(lottieAsset: lottieAsset),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.35,
                  height: 1.25,
                  color: kOnboardingLightCardTitle,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                  color: kOnboardingLightCardBody,
                ),
              ),
              const SizedBox(height: 22),
              // Page dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final active = activePage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 7,
                    width: active ? 22 : 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color:
                          active
                              ? kPrimaryBlue
                              : kPrimaryBlue.withOpacity(0.22),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 22),
              // Skip + pill CTA
              Row(
                children: [
                  if (showSkip)
                    TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: kFieldTextColor.withOpacity(0.82),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.8,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 56),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: onNext,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF111111),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        child: Text(buttonText.toUpperCase()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lottie inside a soft circular frame (reference: illustration in a circle).
class _CircularLottieFrame extends StatelessWidget {
  const _CircularLottieFrame({required this.lottieAsset});

  final String lottieAsset;

  @override
  Widget build(BuildContext context) {
    const size = 220.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.lerp(kFieldFill, Colors.white, 0.4),
        border: Border.all(color: kFieldBorder.withOpacity(0.85), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: kPrimaryBlue.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ColorFiltered(
            colorFilter: kLottieBrandColorFilter,
            child: Lottie.asset(
              lottieAsset,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              repeat: true,
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({
    super.key,
    required this.onNext,
    required this.onSkip,
    required this.activePage,
  });

  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int activePage;

  @override
  Widget build(BuildContext context) {
    return OnboardingBase(
      lottieAsset: 'assets/lottie/onboarding_business_1.json',
      cardColor: kOnboardingThemedCard1,
      activePage: activePage,
      title: 'A clear view of your credit profile',
      description:
          'Bring your bureau and account signals into one business-grade dashboard. '
          'Monitor score drivers and exposure in real time.',
      onNext: onNext,
      onSkip: onSkip,
      buttonText: 'Next',
      showSkip: true,
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({
    super.key,
    required this.onNext,
    required this.onSkip,
    required this.activePage,
  });

  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int activePage;

  @override
  Widget build(BuildContext context) {
    return OnboardingBase(
      lottieAsset: 'assets/lottie/onboarding_business_2.json',
      cardColor: kOnboardingThemedCard2,
      activePage: activePage,
      title: 'Actionable intelligence for decisions',
      description:
          'See what moved your profile, which factors weigh most, and recommended '
          'actions your team can track.',
      onNext: onNext,
      onSkip: onSkip,
      buttonText: 'Next',
      showSkip: true,
    );
  }
}

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({
    super.key,
    required this.onGetStarted,
    required this.onSkip,
    required this.activePage,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onSkip;
  final int activePage;

  @override
  Widget build(BuildContext context) {
    return OnboardingBase(
      lottieAsset: 'assets/lottie/onboarding_business_3.json',
      cardColor: kOnboardingThemedCard3,
      activePage: activePage,
      title: 'Controlled sharing with your circle',
      description:
          'Invite colleagues or advisors with granular, revocable access when you '
          'need alignment—activity stays auditable.',
      onNext: onGetStarted,
      onSkip: onSkip,
      buttonText: 'Start',
      showSkip: true,
    );
  }
}
