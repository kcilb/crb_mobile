import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:crb_mobile/dialogs/success_dialog.dart';

/// Text on primary button fill ([kPrimaryBlue]) — progress loader matches that background.
const Color _loaderOnPrimaryBg = Color(0xFFFFFFFF);
const Color _loaderOnPrimaryBgMuted = Color(0xE6FFF7ED);

/// Login / OTP verification: rotating copy + feature strip (shared with [PrimaryBrandLoadingPanel] defaults).
const List<String> _kOtpVerificationMessages = [
  'Validating your verification code…',
  'Establishing a secure session…',
  'Applying security checks to your account…',
  'Finalizing your request…',
];

const List<({IconData icon, String label})> _kOtpVerificationFeatureHints = [
  (icon: Icons.verified_outlined, label: 'Verified access'),
  (icon: Icons.lock_outline_rounded, label: 'Secure data'),
  (icon: Icons.insights_outlined, label: 'Credit insights'),
  (icon: Icons.notifications_active_outlined, label: 'Smart alerts'),
];

/// [PrimaryBrandLoadingPanel] look: orange card + white text (login), or light card + brand text (logout).
enum BrandLoadingVariant {
  /// Orange [kPrimaryBlue] surface, white copy (default — login / OTP).
  standard,

  /// Light [kFieldFill] surface, dark/brand copy — sign-out progress.
  inverted,
}

/// Sign-out: same layout as login progress; icons + messages tailored to logging out.
const List<String> kSignOutLoadingMessages = [
  'Ending your session securely…',
  'Clearing local credentials from this device…',
  'Disconnecting from secure services…',
  'Returning you to sign in…',
];

const List<({IconData icon, String label})> kSignOutLoadingFeatureHints = [
  (icon: Icons.logout_rounded, label: 'Secure sign out'),
  (icon: Icons.lock_outline_rounded, label: 'Session locked'),
  (icon: Icons.shield_outlined, label: 'Data protected'),
  (icon: Icons.login_rounded, label: 'Sign in again'),
];

/// Orange brand card with feature icons, rotating hints, and status line — used for login & sign-out progress.
class PrimaryBrandLoadingPanel extends StatefulWidget {
  const PrimaryBrandLoadingPanel({
    super.key,
    required this.headerLabel,
    required this.messages,
    required this.featureHints,
    this.variant = BrandLoadingVariant.standard,
  });

  final String headerLabel;
  final List<String> messages;
  final List<({IconData icon, String label})> featureHints;
  final BrandLoadingVariant variant;

  @override
  State<PrimaryBrandLoadingPanel> createState() =>
      _PrimaryBrandLoadingPanelState();
}

class _PrimaryBrandLoadingPanelState extends State<PrimaryBrandLoadingPanel>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  Timer? _timer;
  late final AnimationController _pulseController;

  int get _cycleLen =>
      widget.messages.isEmpty
          ? 1
          : widget.messages.length;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(milliseconds: 750), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _cycleLen);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hints = widget.featureHints;
    final messages = widget.messages;
    final hintIndex = hints.isEmpty ? 0 : _index % hints.length;
    final messageIndex = messages.isEmpty ? 0 : _index % messages.length;
    final inverted = widget.variant == BrandLoadingVariant.inverted;

    final Color surfaceColor =
        inverted ? kFieldFill : kPrimaryBlue;
    final Color shadowColor =
        inverted
            ? Colors.black.withOpacity(0.14)
            : const Color(0x66C2410C);
    final Color headerColor =
        inverted
            ? kFieldTextColor.withOpacity(0.72)
            : _loaderOnPrimaryBgMuted;
    final Color hintLabelColor =
        inverted ? kPrimaryBlue : _loaderOnPrimaryBg.withOpacity(0.92);
    final Color statusColor =
        inverted ? kThemeBg : _loaderOnPrimaryBg;
    final Color ringColor =
        inverted ? kPrimaryBlue.withOpacity(0.14) : Colors.white.withOpacity(0.18);
    final Color progressFg =
        inverted ? kPrimaryBlue : _loaderOnPrimaryBg;
    final Color progressBg =
        inverted ? kPrimaryBlue.withOpacity(0.2) : Colors.white.withOpacity(0.28);

    return Material(
      color: surfaceColor,
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shadowColor: shadowColor,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.headerLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: headerColor,
              ),
            ),
            const SizedBox(height: 14),
            _buildFeatureIconsRow(inverted: inverted),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: Text(
                hints.isEmpty ? '' : hints[hintIndex].label,
                key: ValueKey<int>(_index),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: hintLabelColor,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ringColor,
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      color: progressFg,
                      backgroundColor: progressBg,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: Text(
                      messages.isEmpty ? '' : messages[messageIndex],
                      key: ValueKey<int>(_index),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIconsRow({required bool inverted}) {
    final hints = widget.featureHints;
    if (hints.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final pulse =
            1.0 + 0.07 * math.sin(_pulseController.value * math.pi * 2);

        return Row(
          children: [
            for (int i = 0; i < hints.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: _FeatureLoaderIcon(
                  icon: hints[i].icon,
                  active: i == _index % hints.length,
                  pulseScale: pulse,
                  inverted: inverted,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Loading dialog shown after OTP submit: cycles messages so users see initialization progress.
class _OtpVerificationLoadingDialog extends StatelessWidget {
  const _OtpVerificationLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: const PrimaryBrandLoadingPanel(
          headerLabel: 'Processing your request',
          messages: _kOtpVerificationMessages,
          featureHints: _kOtpVerificationFeatureHints,
        ),
      ),
    );
  }
}

/// One compact icon in the loader feature strip; [pulseScale] animates the active tile.
class _FeatureLoaderIcon extends StatelessWidget {
  const _FeatureLoaderIcon({
    required this.icon,
    required this.active,
    required this.pulseScale,
    this.inverted = false,
  });

  final IconData icon;
  final bool active;
  final double pulseScale;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final scale = active ? pulseScale : 1.0;
    final opacity = active ? 1.0 : 0.55;

    final Color bg;
    final Color borderColor;
    final Color iconColor;
    if (inverted) {
      bg =
          active
              ? kPrimaryBlue.withOpacity(0.18)
              : kFieldTextColor.withOpacity(0.06);
      borderColor =
          active
              ? kPrimaryBlue.withOpacity(0.45)
              : kFieldBorder.withOpacity(0.85);
      iconColor =
          active ? kPrimaryBlue : kFieldTextColor.withOpacity(0.5);
    } else {
      bg =
          active
              ? Colors.white.withOpacity(0.22)
              : Colors.white.withOpacity(0.08);
      borderColor =
          active
              ? Colors.white.withOpacity(0.45)
              : Colors.white.withOpacity(0.12);
      iconColor = Colors.white;
    }

    return AnimatedScale(
      scale: active ? 1.0 : 0.88,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 280),
        child: Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: bg,
              border: Border.all(
                color: borderColor,
                width: active ? 1.2 : 1,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Same full-screen-style loader as after OTP verification (feature icons + messages).
/// Use for login or any step that should show the same progress UI.
class VerificationProgressDialog {
  VerificationProgressDialog._();

  /// Shows the loader, waits [displayDuration], then closes it.
  static Future<void> showFor(
    BuildContext context, {
    Duration displayDuration = const Duration(seconds: 5),
  }) async {
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      builder: (_) => const _OtpVerificationLoadingDialog(),
    );
    await Future<void>.delayed(displayDuration);
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}

/// Injectable OTP verification dialog. Use [OtpDialog.show] to present it.
class OtpDialog extends StatefulWidget {
  const OtpDialog({
    super.key,
    this.title =
        'A one-time verification code has been sent to your registered number',
    this.subtitle,
    this.onVerified,
    this.onResend,
  });

  final String title;
  final String? subtitle;

  /// Called when all digits are entered and "verification" runs.
  final Future<void> Function(String code)? onVerified;

  /// Called when "Resend OTP" is tapped.
  final VoidCallback? onResend;

  static Future<void> show(
    BuildContext context, {
    String title =
        'A one-time verification code has been sent to your registered number',
    String? subtitle,
    Future<void> Function(String code)? onVerified,
    VoidCallback? onResend,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => OtpDialog(
            title: title,
            subtitle: subtitle,
            onVerified: onVerified,
            onResend: onResend,
          ),
    );
  }

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> with SingleTickerProviderStateMixin {
  static const int _otpLength = 4;
  static const double _minBoxSize = 36;
  static const double _maxBoxSize = 48;
  static const double _gap = 8;
  static const Duration _codeExpiryDuration = Duration(minutes: 2);

  late final AnimationController _envelopeIconController;
  late final Animation<double> _envelopePulse;

  final List<TextEditingController> _digitControllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _digitFocusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  bool _verificationTriggered = false;
  bool _resending = false;
  late Duration _timeRemaining;
  Timer? _expiryTimer;

  String get _otpCode => _digitControllers.map((c) => c.text).join();

  /// Empty string suppresses the subtitle line; [null] uses the default copy.
  String get _effectiveSubtitle {
    if (widget.subtitle != null && widget.subtitle!.isEmpty) return '';
    return widget.subtitle ??
        'Enter the code below to complete verification.';
  }

  bool get _otpComplete {
    if (_otpCode.length != _otpLength) return false;
    return !_otpCode.contains(RegExp(r'[^0-9]'));
  }

  bool get _isExpired => _timeRemaining <= Duration.zero;

  String get _expiryLabel {
    final total = _timeRemaining.inSeconds.clamp(0, _codeExpiryDuration.inSeconds);
    final minutes = total ~/ 60;
    final seconds = total % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _onOtpChanged() {
    if (!mounted || _verificationTriggered) return;
    if (_isExpired) return;
    if (!_otpComplete) return;
    _verificationTriggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _runVerification();
    });
  }

  void _startExpiryTimer() {
    _expiryTimer?.cancel();
    _timeRemaining = _codeExpiryDuration;
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timeRemaining <= const Duration(seconds: 1)) {
        setState(() => _timeRemaining = Duration.zero);
        timer.cancel();
        return;
      }
      setState(() => _timeRemaining -= const Duration(seconds: 1));
    });
  }

  void _clearOtpFields() {
    setState(() {
      _verificationTriggered = false;
      for (final c in _digitControllers) {
        c.text = '';
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _digitFocusNodes.first.requestFocus();
    });
  }

  Future<void> _onResendTap() async {
    if (_resending) return;
    setState(() => _resending = true);
    widget.onResend?.call();
    _clearOtpFields();
    _startExpiryTimer();
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Verification code resent'),
        duration: Duration(milliseconds: 1400),
      ),
    );
    setState(() => _resending = false);
  }

  @override
  void initState() {
    super.initState();
    _timeRemaining = _codeExpiryDuration;
    _envelopeIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _envelopePulse = CurvedAnimation(
      parent: _envelopeIconController,
      curve: Curves.easeInOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _digitFocusNodes.first.requestFocus();
    });
    for (final c in _digitControllers) {
      c.addListener(_onOtpChanged);
    }
    _startExpiryTimer();
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    _envelopeIconController.dispose();
    for (final c in _digitControllers) {
      c.removeListener(_onOtpChanged);
    }
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final f in _digitFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _runVerification() {
    final code = _otpCode;
    final navigator = Navigator.of(context);
    final overlayContext = Overlay.of(context).context;
    navigator.pop();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!overlayContext.mounted) return;

      showDialog<void>(
        context: overlayContext,
        barrierDismissible: false,
        barrierColor: Colors.black38,
        builder: (_) => const _OtpVerificationLoadingDialog(),
      );

      try {
        if (widget.onVerified != null) {
          await widget.onVerified!(code);
        } else {
          // Demo path: keep loader visible so feature icons + messages can cycle.
          await Future<void>.delayed(const Duration(seconds: 20));
        }
      } finally {
        if (overlayContext.mounted) {
          Navigator.of(overlayContext, rootNavigator: true).pop();
        }
        if (overlayContext.mounted && widget.onVerified == null) {
          await SuccessDialog.show(overlayContext);
        }
      }
    });
  }

  InputDecoration _digitDecoration(double boxSize, bool hasValue) {
    final radius = boxSize / 2;
    final fill = hasValue ? Colors.white : Colors.white.withOpacity(0.28);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color:
            hasValue
                ? kOtpDialogOutline.withOpacity(0.5)
                : kFieldBorder.withOpacity(0.9),
        width: 1.5,
      ),
    );
    return InputDecoration(
      filled: true,
      fillColor: fill,
      contentPadding: EdgeInsets.zero,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: kOtpDialogOutline, width: 2),
      ),
      counterText: '',
    );
  }

  void _setDigitAndMoveFocus(int index, String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      setState(() => _digitControllers[index].text = '');
      return;
    }

    setState(() {
      for (int offset = 0; offset < digits.length; offset++) {
        final targetIndex = index + offset;
        if (targetIndex >= _otpLength) break;
        _digitControllers[targetIndex].text = digits[offset];
      }
    });

    final nextIndex = index + digits.length;
    if (nextIndex < _otpLength) {
      _digitFocusNodes[nextIndex].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
          decoration: BoxDecoration(
            color: kOtpDialogBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: OtpDialogBackgroundPainter()),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final horizontalPadding = 20.0 * 2;
                    final availableWidth =
                        constraints.maxWidth - horizontalPadding;
                    final boxSize = ((availableWidth -
                                (_otpLength - 1) * _gap) /
                            _otpLength)
                        .clamp(_minBoxSize, _maxBoxSize);
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: _buildEnvelopeIcon()),
                            const SizedBox(height: 16),
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                height: 1.28,
                              ),
                            ),
                            if (_effectiveSubtitle.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                _effectiveSubtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.3,
                                  color: Colors.white.withOpacity(0.92),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Center(
                              child: SizedBox(
                                height: boxSize,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (int i = 0; i < _otpLength; i++) ...[
                                      if (i > 0) SizedBox(width: _gap),
                                      SizedBox(
                                        width: boxSize,
                                        height: boxSize,
                                        child: TextField(
                                          controller: _digitControllers[i],
                                          focusNode: _digitFocusNodes[i],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: (boxSize * 0.38).clamp(
                                              14.0,
                                              20.0,
                                            ),
                                            fontWeight: FontWeight.w700,
                                            color: kFieldTextColor,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged:
                                              (v) =>
                                                  _setDigitAndMoveFocus(i, v),
                                          decoration: _digitDecoration(
                                            boxSize,
                                            _digitControllers[i]
                                                .text
                                                .isNotEmpty,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _isExpired
                                  ? 'Code expired'
                                  : 'Code expires in $_expiryLabel',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: _isExpired
                                    ? const Color(0xFFFCA5A5)
                                    : Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(child: _buildResendRow()),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvelopeIcon() {
    return AnimatedBuilder(
      animation: _envelopePulse,
      builder: (context, child) {
        final t = _envelopePulse.value;
        final scale = 0.92 + (0.08 * t);
        final angle = (t - 0.5) * 0.14;
        return Transform.scale(
          scale: scale,
          child: Transform.rotate(angle: angle, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kOtpDialogCardFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kOtpDialogOutline, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 28,
              color: kOtpDialogOutline,
            ),
            const SizedBox(height: 4),
            Text(
              'CODE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: kOtpDialogOutline,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendRow() {
    return InkWell(
      onTap: _resending ? null : _onResendTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              height: 1.35,
            ),
            children: [
              TextSpan(
                text: _isExpired
                    ? 'Your code has expired. '
                    : "Didn't receive the code? ",
              ),
              TextSpan(
                text: _resending ? 'Resending…' : 'Resend code',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  decoration: _resending
                      ? TextDecoration.none
                      : TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
