import 'dart:ui' show clampDouble;

import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:crb_mobile/dialogs/otp_dialog.dart';
import 'package:flutter/material.dart';

/// Confirmation dialog for signing out — matches [SuccessDialog] / app dialog shell.
class LogoutDialog {
  LogoutDialog._();

  /// Simulated sign-out work (replace with `auth.signOut()` when wired).
  /// Long enough to show several cycles of [PrimaryBrandLoadingPanel] messages.
  static const Duration _signOutDelay = Duration(milliseconds: 2800);

  /// Returns `true` after progress completes if the user chose **Log out**,
  /// `false` if **Cancel**, `null` if dismissed.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor:
          Color.alphaBlend(kThemeBg.withOpacity(0.35), Colors.black.withOpacity(0.5)),
      builder: (ctx) => const _LogoutDialogWidget(),
    );
  }
}

class _LogoutDialogWidget extends StatefulWidget {
  const _LogoutDialogWidget();

  @override
  State<_LogoutDialogWidget> createState() => _LogoutDialogWidgetState();
}

class _LogoutDialogWidgetState extends State<_LogoutDialogWidget> {
  bool _loading = false;

  Future<void> _onConfirmLogout() async {
    setState(() => _loading = true);
    await Future<void>.delayed(LogoutDialog._signOutDelay);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_loading,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
        child:
            _loading
                ? ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: const PrimaryBrandLoadingPanel(
                    headerLabel: 'Signing you out',
                    messages: kSignOutLoadingMessages,
                    featureHints: kSignOutLoadingFeatureHints,
                    variant: BrandLoadingVariant.inverted,
                  ),
                )
                : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Material(
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 12,
                    shadowColor: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      child: _buildConfirmContent(),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildConfirmContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: _AnimatedLogoutIconBadge(),
        ),
        const SizedBox(height: 12),
        const Text(
          'Log out',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: kFieldTextColor,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You will be signed out on this device. '
          'You can sign in again anytime.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            height: 1.35,
            color: kFieldTextColor.withOpacity(0.82),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryBlue,
                  side: BorderSide(color: kPrimaryBlue.withOpacity(0.85)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: _onConfirmLogout,
                style: FilledButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Gentle scale + opacity pulse (aligned with [SuccessDialog] icon motion).
class _AnimatedLogoutIconBadge extends StatefulWidget {
  const _AnimatedLogoutIconBadge();

  @override
  State<_AnimatedLogoutIconBadge> createState() =>
      _AnimatedLogoutIconBadgeState();
}

class _AnimatedLogoutIconBadgeState extends State<_AnimatedLogoutIconBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scalePulse;
  late final Animation<double> _opacityPulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scalePulse = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
    _opacityPulse = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kPrimaryBlue,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.30),
          ),
        ),
        child: const Icon(
          Icons.logout_rounded,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}
