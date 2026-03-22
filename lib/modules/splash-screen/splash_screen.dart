import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:crb_mobile/widgets/brand_app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

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
              child: Stack(
                children: [
                  const IgnorePointer(child: SplashBackgroundAccents()),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            const CreditTrackAppIconMark(size: 46),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CreditTrack',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: kOnboardingOnCardTitle,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Smart credit, simple decisions.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kOnboardingOnCardBody,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        Text(
                          'Stay ahead of\nyour credit score.',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: kOnboardingOnCardTitle,
                            height: 1.1,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Track your score in real time, get alerts, and unlock smarter loan offers tailored to you.',
                          style: TextStyle(
                            fontSize: 15,
                            color: kOnboardingOnCardBody,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SplashFeatureRow(
                              icon: Icons.shield_moon_sharp,
                              label: 'Bank–grade security for your data',
                            ),
                            const SizedBox(height: 10),
                            _SplashFeatureRow(
                              icon: Icons.trending_up_rounded,
                              label: 'Actionable tips to improve your score',
                            ),
                            const SizedBox(height: 10),
                            _SplashFeatureRow(
                              icon: Icons.notifications_active_rounded,
                              label: 'Instant alerts on important changes',
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            TextButton(
                              onPressed: onSkipPressed,
                              child: Text(
                                'Skip for now',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kFieldTextColor.withOpacity(0.85),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: onNextPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 14,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Get started',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
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

class _SplashFeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SplashFeatureRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(kPrimaryBlue, Colors.white, 0.72)!
                .withOpacity(0.2),
          ),
          child: Icon(
            icon,
            size: 16,
            color: kOnboardingOnCardTitle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: kOnboardingOnCardBody,
            ),
          ),
        ),
      ],
    );
  }
}
