import 'dart:async';
import 'dart:ui' show clampDouble;

import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:crb_mobile/modules/dashboard/credit_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Success confirmation after progress completes.
/// Uses a flat-style SVG in [assetPath] (replace `assets/images/success_flaticon.svg`
/// with your own Flaticon download; keep filename or update this constant).
class SuccessDialog {
  SuccessDialog._();

  /// Default bundled flat success illustration (Flaticon-style aesthetic).
  static const String assetPath = 'assets/images/success_flaticon.svg';

  /// Shows a compact success confirmation. Returns when the user taps Continue to app.
  static Future<void> show(
    BuildContext context, {
    String title = 'Verification complete',
    String message =
        'Your information has been verified successfully. You may continue to access your account.',
    String? svgAssetPath,
    double iconSize = 88,
  }) {
    final path = svgAssetPath ?? assetPath;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Material(
              color: Colors.white,
              elevation: 16,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: _AnimatedSuccessIcon(
                          assetPath: path,
                          size: iconSize,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kFieldTextColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: kFieldTextColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: FilledButton(
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            await _showTransparentProgressLoader(context);
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const CreditDashboard(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: kPrimaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          child: const Text('Continue to app'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Full-screen dimmed overlay, bottom sheet with horizontal bar + finalizing narration.
Future<void> _showTransparentProgressLoader(BuildContext context) async {
  if (!context.mounted) return;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (dialogContext) {
      final size = MediaQuery.sizeOf(dialogContext);
      return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: _ContinueToAppOverlay(),
        ),
      );
    },
  );
  await Future<void>.delayed(const Duration(milliseconds: 2400));
  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();
}

/// Bottom-anchored panel: indeterminate horizontal progress + rotating finalizing copy.
class _ContinueToAppOverlay extends StatefulWidget {
  const _ContinueToAppOverlay();

  @override
  State<_ContinueToAppOverlay> createState() => _ContinueToAppOverlayState();
}

class _ContinueToAppOverlayState extends State<_ContinueToAppOverlay> {
  static const List<String> _narrationSteps = [
    'Finalizing your session…',
    'Securing your profile…',
    'Preparing your dashboard…',
    'Almost there…',
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _narrationSteps.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            padding: EdgeInsets.fromLTRB(22, 22, 22, 18 + bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'FINALIZING',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: kFieldTextColor.withOpacity(0.55),
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    minHeight: 7,
                    backgroundColor: kFieldFill,
                    color: kPrimaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: Text(
                    _narrationSteps[_index],
                    key: ValueKey<int>(_index),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: kFieldTextColor,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Scale + fade-in for the success illustration.
class _AnimatedSuccessIcon extends StatefulWidget {
  const _AnimatedSuccessIcon({
    required this.assetPath,
    required this.size,
  });

  final String assetPath;
  final double size;

  @override
  State<_AnimatedSuccessIcon> createState() => _AnimatedSuccessIconState();
}

class _AnimatedSuccessIconState extends State<_AnimatedSuccessIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scalePulse;
  late final Animation<double> _opacityPulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _scalePulse = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    // Subtle brightness pulse in sync with scale
    _opacityPulse = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the derived animations so rebuilds stay in sync with curved
    // tweens (controller alone can miss ticks in some Flutter versions).
    return AnimatedBuilder(
      animation: Listenable.merge([_scalePulse, _opacityPulse]),
      builder: (context, child) {
        final opacity = clampDouble(_opacityPulse.value, 0.0, 1.0);
        final scale = clampDouble(_scalePulse.value, 0.01, 4.0);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: SvgPicture.asset(
          widget.assetPath,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => Icon(
            Icons.check_circle_rounded,
            size: widget.size * 0.85,
            color: kPrimaryBlue,
          ),
        ),
      ),
    );
  }
}
