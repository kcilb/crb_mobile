import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:crb_mobile/dialogs/otp_dialog.dart';
import 'package:crb_mobile/modules/auth/widgets/slide_to_biometric_bar.dart';
import 'package:crb_mobile/modules/dashboard/credit_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Card: only top-right corner rounded; top-left square.
const BorderRadius _kCardTopRadius = BorderRadius.only(
  topRight: Radius.circular(36),
);

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth>
    with SingleTickerProviderStateMixin {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _showBiometricSlide = false;
  bool _biometricAvailable = false;
  late final AnimationController _gridController;
  late final Animation<double> _gridOffset;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _emailFieldKey = GlobalKey();
  final GlobalKey _passwordFieldKey = GlobalKey();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // These were used for the tab-based signup. Kept for now to avoid a
  // risky large refactor; they are not shown with tabs removed.
  final GlobalKey _nameFieldKey = GlobalKey();
  final GlobalKey _signupEmailFieldKey = GlobalKey();
  final GlobalKey _signupPasswordFieldKey = GlobalKey();
  final GlobalKey _confirmPasswordFieldKey = GlobalKey();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _signupEmailFocusNode = FocusNode();
  final FocusNode _signupPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _agreeToTerms = false;
  bool _obscureConfirmPassword = true;

  void _scrollToField(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.2,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _gridOffset = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _gridController, curve: Curves.linear));

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) _scrollToField(_emailFieldKey);
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _scrollToField(_passwordFieldKey);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _initBiometric());
  }

  Future<void> _initBiometric() async {
    final auth = LocalAuthentication();
    try {
      final supported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;
      final types = await auth.getAvailableBiometrics();
      if (!mounted) return;
      setState(() {
        _biometricAvailable = supported && canCheck && types.isNotEmpty;
      });
    } catch (_) {
      if (mounted) setState(() => _biometricAvailable = false);
    }
  }

  Future<void> _completeLoginAfterBiometric() async {
    await VerificationProgressDialog.showFor(context);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const CreditDashboard()),
    );
  }

  @override
  void dispose() {
    _gridController.dispose();
    _scrollController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _signupEmailFocusNode.dispose();
    _signupPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const headerFlex = 42;
    const cardFlex = 58;
    const overlap = 28.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(color: kThemeBg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final headerH = h * headerFlex / (headerFlex + cardFlex);
            final bottomInset = MediaQuery.paddingOf(context).bottom;

            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                // —— Blue header ——
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: headerH,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: kThemeBg),
                      ),
                      AnimatedBuilder(
                        animation: _gridController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _GridPatternPainter(
                              offset: _gridOffset.value,
                            ),
                            child: child,
                          );
                        },
                        child: const SizedBox.expand(),
                      ),
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.35),
                                    width: 1.5,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.shield_outlined,
                                      size: 36,
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                    Positioned(
                                      bottom: 18,
                                      child: Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              const Text(
                                'Sign in to your Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Enter your email and password to log in',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // —— White card: from below header overlap to bottom of screen ——
                Positioned(
                  left: 0,
                  right: 16,
                  top: headerH - overlap,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: _kCardTopRadius,
                    ),
                    child: ClipRRect(
                      borderRadius: _kCardTopRadius,
                      child: Stack(
                        children: [
                          // Abstract shapes behind inputs/buttons (background touch).
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 120,
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: const BottomAbstractShapesPainter(
                                  backgroundColor: kThemeBg,
                                  accentColor: kPrimaryBlue,
                                ),
                                child: const SizedBox.expand(),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            controller: _scrollController,
                            padding: EdgeInsets.fromLTRB(
                              24,
                              28,
                              24,
                              24 + bottomInset,
                            ),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 14),

                                Visibility(
                                  visible: true,
                                  maintainState: true,
                                  maintainSize: false,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Email (slight elevation/shadow)
                                      Container(
                                        key: _emailFieldKey,
                                        child: Material(
                                          elevation: 8,
                                          shadowColor: Colors.black.withOpacity(
                                            0.28,
                                          ),
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.zero,
                                          child: TextFormField(
                                            focusNode: _emailFocusNode,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            initialValue:
                                                'Loisbecket@gmail.com',
                                            style: kFieldInputTextStyle,
                                            decoration: _fieldDecoration(
                                              'Email',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Password + eye (slight elevation/shadow)
                                      Container(
                                        key: _passwordFieldKey,
                                        child: Material(
                                          elevation: 8,
                                          shadowColor: Colors.black.withOpacity(
                                            0.28,
                                          ),
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.zero,
                                          child: TextFormField(
                                            focusNode: _passwordFocusNode,
                                            obscureText: _obscurePassword,
                                            style: kFieldInputTextStyle,
                                            decoration: _fieldDecoration(
                                              'Password',
                                            ).copyWith(
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _obscurePassword
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: Colors.grey.shade600,
                                                  size: 22,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _obscurePassword =
                                                        !_obscurePassword;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: (v) {
                                                setState(
                                                  () =>
                                                      _rememberMe = v ?? false,
                                                );
                                              },
                                              activeColor: kPrimaryBlue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              side: BorderSide(
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Remember me',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              /* TODO */
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: const Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kPrimaryBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      if (_biometricAvailable) ...[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.fingerprint_rounded,
                                              size: 22,
                                              color: kPrimaryBlue,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Show slide to use biometric',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      Colors.grey.shade700,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: _showBiometricSlide,
                                              onChanged: (v) {
                                                setState(
                                                  () =>
                                                      _showBiometricSlide = v,
                                                );
                                              },
                                              activeColor: kPrimaryBlue,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                      if (_showBiometricSlide &&
                                          _biometricAvailable)
                                        SlideToBiometricBar(
                                          onAuthenticated:
                                              _completeLoginAfterBiometric,
                                        )
                                      else
                                        SizedBox(
                                          height: 52,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await VerificationProgressDialog
                                                  .showFor(context);
                                              if (!context.mounted) return;
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          const CreditDashboard(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kPrimaryBlue,
                                              foregroundColor: Colors.white,
                                              elevation: 14,
                                              shadowColor: Colors.black
                                                  .withOpacity(0.45),
                                              surfaceTintColor:
                                                  Colors.transparent,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                            ),
                                            child: const Text(
                                              'Log In',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 28),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (ctx) {
                                            return _CreateAccountDialog(
                                              gridOffset: _gridOffset.value,
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: kPrimaryBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 0),

                                Visibility(
                                  visible: false,
                                  maintainState: true,
                                  maintainSize: false,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Signup panel: Account details
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6F7FB),
                                          border: Border.all(
                                            color: kFieldBorder,
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          16,
                                          16,
                                          14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Details',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: kFieldTextColor,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Container(
                                              key: _nameFieldKey,
                                              child: Material(
                                                elevation: 8,
                                                shadowColor: Colors.black
                                                    .withOpacity(0.28),
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.zero,
                                                child: TextFormField(
                                                  focusNode: _nameFocusNode,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  style: kFieldInputTextStyle,
                                                  decoration: _fieldDecoration(
                                                    'Full name',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Container(
                                              key: _signupEmailFieldKey,
                                              child: Material(
                                                elevation: 8,
                                                shadowColor: Colors.black
                                                    .withOpacity(0.28),
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.zero,
                                                child: TextFormField(
                                                  focusNode:
                                                      _signupEmailFocusNode,
                                                  keyboardType:
                                                      TextInputType
                                                          .emailAddress,
                                                  style: kFieldInputTextStyle,
                                                  decoration: _fieldDecoration(
                                                    'Email',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Signup panel: Password
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6F7FB),
                                          border: Border.all(
                                            color: kFieldBorder,
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          16,
                                          16,
                                          14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Password',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: kFieldTextColor,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Container(
                                              key: _signupPasswordFieldKey,
                                              child: Material(
                                                elevation: 8,
                                                shadowColor: Colors.black
                                                    .withOpacity(0.28),
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.zero,
                                                child: TextFormField(
                                                  focusNode:
                                                      _signupPasswordFocusNode,
                                                  obscureText: _obscurePassword,
                                                  style: kFieldInputTextStyle,
                                                  decoration: _fieldDecoration(
                                                    'Password',
                                                  ).copyWith(
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _obscurePassword
                                                            ? Icons
                                                                .visibility_outlined
                                                            : Icons
                                                                .visibility_off_outlined,
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                        size: 22,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscurePassword =
                                                              !_obscurePassword;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Container(
                                              key: _confirmPasswordFieldKey,
                                              child: Material(
                                                elevation: 8,
                                                shadowColor: Colors.black
                                                    .withOpacity(0.28),
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.zero,
                                                child: TextFormField(
                                                  focusNode:
                                                      _confirmPasswordFocusNode,
                                                  obscureText:
                                                      _obscureConfirmPassword,
                                                  style: kFieldInputTextStyle,
                                                  decoration: _fieldDecoration(
                                                    'Confirm password',
                                                  ).copyWith(
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _obscureConfirmPassword
                                                            ? Icons
                                                                .visibility_outlined
                                                            : Icons
                                                                .visibility_off_outlined,
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                        size: 22,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscureConfirmPassword =
                                                              !_obscureConfirmPassword;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: Checkbox(
                                                    value: _agreeToTerms,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        _agreeToTerms =
                                                            v ?? false;
                                                      });
                                                    },
                                                    activeColor: kPrimaryBlue,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    side: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Expanded(
                                                  child: Text(
                                                    'I agree to the Terms & Privacy Policy',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xFF6B7280),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                      SizedBox(
                                        height: 52,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (ctx) {
                                                return _CreateAccountDialog(
                                                  gridOffset: _gridOffset.value,
                                                );
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryBlue,
                                            foregroundColor: Colors.white,
                                            elevation: 14,
                                            shadowColor: Colors.black
                                                .withOpacity(0.45),
                                            surfaceTintColor:
                                                Colors.transparent,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                          child: const Text(
                                            'Create',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: kFieldLabelStyle,
      floatingLabelStyle: kFieldLabelStyle,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: kFieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kFieldBorder, width: 1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kFieldBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: const BorderSide(color: kPrimaryBlue, width: 1.5),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFFDC2626), width: 1.25),
      ),
    );
  }
}

/// Subtle grid on blue header (reference look).
class _GridPatternPainter extends CustomPainter {
  _GridPatternPainter({required this.offset});

  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.10)
          ..strokeWidth = 0.9;
    const step = 22.0;
    final shift = (offset * step * 2) % step;

    for (double x = -step; x < size.width + step; x += step) {
      final dx = x + shift;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }
    for (double y = -step; y < size.height + step; y += step) {
      final dy = y + shift;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Clips a rounded rectangle with a semicircular notch at the bottom center
/// (for the floating action button that sits half in / half out of the card).
class _NotchedBottomClip extends CustomClipper<Path> {
  _NotchedBottomClip({this.cornerRadius = 24, this.notchRadius = 28});

  final double cornerRadius;
  final double notchRadius;

  @override
  Path getClip(Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(cornerRadius),
    );
    final rectPath = Path()..addRRect(rrect);
    final notchCenter = Offset(size.width / 2, size.height + notchRadius);
    final notchPath =
        Path()
          ..addOval(Rect.fromCircle(center: notchCenter, radius: notchRadius));
    return Path.combine(PathOperation.difference, rectPath, notchPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldDelegate) => false;
}

/// Professional "Create Account" form inside a dialog.
class _CreateAccountDialog extends StatefulWidget {
  const _CreateAccountDialog({required this.gridOffset});

  final double gridOffset;

  @override
  State<_CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<_CreateAccountDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _abstractShapeController;

  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _emailKey = GlobalKey();
  final GlobalKey _passwordKey = GlobalKey();
  final GlobalKey _confirmKey = GlobalKey();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _createStepIndex = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool get _detailsComplete =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty;

  bool get _passwordsComplete =>
      _passwordController.text.trim().isNotEmpty &&
      _confirmController.text.trim().isNotEmpty;

  bool get _passwordsMatch =>
      _passwordController.text.trim() == _confirmController.text.trim();

  bool get _passwordStepComplete => _passwordsComplete && _passwordsMatch;

  @override
  void initState() {
    super.initState();
    _abstractShapeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    void wire(FocusNode node, GlobalKey key) {
      node.addListener(() {
        if (node.hasFocus) _ensureVisible(key);
      });
    }

    wire(_nameFocus, _nameKey);
    wire(_emailFocus, _emailKey);
    wire(_passwordFocus, _passwordKey);
    wire(_confirmFocus, _confirmKey);
  }

  void _ensureVisible(GlobalKey key) {
    // Dialog is designed to fit without scrolling.
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _abstractShapeController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: kFieldLabelStyle,
      floatingLabelStyle: kFieldLabelStyle,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: kFieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kFieldBorder, width: 1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kFieldBorder, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kPrimaryBlue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    const notchRadius = 28.0;
    const buttonSize = 56.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // White card with notched bottom (semicircular cutout for the button).
            ClipPath(
              clipper: _NotchedBottomClip(notchRadius: notchRadius),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 110,
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _abstractShapeController,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: BottomAbstractShapesPainter(
                                backgroundColor: kThemeBg,
                                accentColor: kPrimaryBlue,
                                phase: _abstractShapeController.value,
                              ),
                              child: const SizedBox.expand(),
                            );
                          },
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              20,
                              20,
                              20,
                              20 + notchRadius + bottomInset,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Dialog title/subtitle (standalone dialog styling).
                                Center(
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: kFieldTextColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Fill in your details to get started securely',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Horizontal stepper: Details -> Password
                                Column(
                                  children: [
                                    _HorizontalStepIndicator(
                                      currentStepIndex: _createStepIndex,
                                      labels: const ['Details', 'Password'],
                                      onStepTap: (i) {
                                        if (i == 1 && !_detailsComplete) {
                                          // Prevent going to step 2 before required fields are supplied.
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                if (_nameController.text
                                                    .trim()
                                                    .isEmpty) {
                                                  _nameFocus.requestFocus();
                                                } else {
                                                  _emailFocus.requestFocus();
                                                }
                                              });
                                          return;
                                        }

                                        setState(() => _createStepIndex = i);
                                        if (i == 1) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                _passwordFocus.requestFocus();
                                              });
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 280,
                                      ),
                                      switchInCurve: Curves.easeOut,
                                      switchOutCurve: Curves.easeIn,
                                      transitionBuilder: (child, anim) {
                                        final curved = CurvedAnimation(
                                          parent: anim,
                                          curve: Curves.easeOut,
                                        );
                                        return FadeTransition(
                                          opacity: curved,
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0, 0.06),
                                              end: Offset.zero,
                                            ).animate(curved),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child:
                                          _createStepIndex == 0
                                              ? KeyedSubtree(
                                                key: const ValueKey(0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Material(
                                                      key: _nameKey,
                                                      elevation: 8,
                                                      shadowColor: Colors.black
                                                          .withOpacity(0.28),
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                      child: TextFormField(
                                                        controller:
                                                            _nameController,
                                                        focusNode: _nameFocus,
                                                        keyboardType:
                                                            TextInputType.name,
                                                        style:
                                                            kFieldInputTextStyle,
                                                        decoration:
                                                            _fieldDecoration(
                                                              'Full name',
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 14),
                                                    Material(
                                                      key: _emailKey,
                                                      elevation: 8,
                                                      shadowColor: Colors.black
                                                          .withOpacity(0.28),
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                      child: TextFormField(
                                                        controller:
                                                            _emailController,
                                                        focusNode: _emailFocus,
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        style:
                                                            kFieldInputTextStyle,
                                                        decoration:
                                                            _fieldDecoration(
                                                              'Email',
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 18),
                                                  ],
                                                ),
                                              )
                                              : _createStepIndex == 1
                                              ? KeyedSubtree(
                                                key: const ValueKey(1),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Material(
                                                          key: _passwordKey,
                                                          elevation: 8,
                                                          shadowColor: Colors
                                                              .black
                                                              .withOpacity(
                                                                0.28,
                                                              ),
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                          child: TextFormField(
                                                            controller:
                                                                _passwordController,
                                                            focusNode:
                                                                _passwordFocus,
                                                            obscureText:
                                                                _obscurePassword,
                                                            style:
                                                                kFieldInputTextStyle,
                                                            decoration: _fieldDecoration(
                                                              'Password',
                                                            ).copyWith(
                                                              suffixIcon: IconButton(
                                                                icon: Icon(
                                                                  _obscurePassword
                                                                      ? Icons
                                                                          .visibility_outlined
                                                                      : Icons
                                                                          .visibility_off_outlined,
                                                                  color:
                                                                      Colors
                                                                          .grey
                                                                          .shade600,
                                                                  size: 22,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _obscurePassword =
                                                                        !_obscurePassword;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 14,
                                                        ),
                                                        Material(
                                                          key: _confirmKey,
                                                          elevation: 8,
                                                          shadowColor: Colors
                                                              .black
                                                              .withOpacity(
                                                                0.28,
                                                              ),
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                          child: TextFormField(
                                                            controller:
                                                                _confirmController,
                                                            focusNode:
                                                                _confirmFocus,
                                                            obscureText:
                                                                _obscureConfirmPassword,
                                                            style:
                                                                kFieldInputTextStyle,
                                                            decoration: _fieldDecoration(
                                                              'Confirm password',
                                                            ).copyWith(
                                                              suffixIcon: IconButton(
                                                                icon: Icon(
                                                                  _obscureConfirmPassword
                                                                      ? Icons
                                                                          .visibility_outlined
                                                                      : Icons
                                                                          .visibility_off_outlined,
                                                                  color:
                                                                      Colors
                                                                          .grey
                                                                          .shade600,
                                                                  size: 22,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _obscureConfirmPassword =
                                                                        !_obscureConfirmPassword;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 24,
                                                              width: 24,
                                                              child: Checkbox(
                                                                value:
                                                                    _agreeToTerms,
                                                                onChanged: (v) {
                                                                  setState(() {
                                                                    _agreeToTerms =
                                                                        v ??
                                                                        false;
                                                                  });
                                                                },
                                                                activeColor:
                                                                    kPrimaryBlue,
                                                                side: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .grey
                                                                          .shade400,
                                                                ),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            const Expanded(
                                                              child: Text(
                                                                'I agree to the Terms & Privacy Policy',
                                                                style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color(
                                                                    0xFF6B7280,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 18),
                                                  ],
                                                ),
                                              )
                                              : const SizedBox.shrink(),
                                    ),
                                  ],
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
            ),
            // Floating circular action button in the notch (half in / half out of card).
            Positioned(
              left: 0,
              right: 0,
              bottom: -notchRadius,
              height: buttonSize,
              child: Center(
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.25),
                  shape: const CircleBorder(),
                  color:
                      (_createStepIndex == 0 && _detailsComplete) ||
                              (_createStepIndex == 1 && _passwordStepComplete)
                          ? kPrimaryBlue
                          : Colors.grey.shade400,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      if (_createStepIndex == 0 && _detailsComplete) {
                        setState(() => _createStepIndex = 1);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _passwordFocus.requestFocus();
                        });
                      } else if (_createStepIndex == 1 &&
                          _passwordStepComplete) {
                        final overlayContext = Overlay.of(context).context;
                        Navigator.of(context).pop();
                        OtpDialog.show(overlayContext);
                      }
                    },
                    child: SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogPanel extends StatelessWidget {
  const _DialogPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: kFieldTextColor,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DialogStepChip extends StatelessWidget {
  const _DialogStepChip({
    required this.label,
    required this.active,
    required this.completed,
    required this.onTap,
  });

  final String label;
  final bool active;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = active || completed ? kPrimaryBlue : kFieldBorder;
    final Color bgColor =
        active
            ? kPrimaryBlue.withOpacity(0.12)
            : completed
            ? kPrimaryBlue.withOpacity(0.10)
            : const Color(0xFFF3F4F6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: active || completed ? kPrimaryBlue : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active || completed ? kPrimaryBlue : kFieldBorder,
                  width: 1.5,
                ),
              ),
              child: Icon(
                completed ? Icons.check : Icons.circle,
                size: 14,
                color: active || completed ? Colors.white : kPrimaryBlue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w700,
                  color: active ? kPrimaryBlue : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalStepIndicator extends StatelessWidget {
  const _HorizontalStepIndicator({
    required this.currentStepIndex,
    required this.labels,
    this.onStepTap,
  }) : assert(labels.length >= 2 && labels.length <= 3);

  final int currentStepIndex;
  final List<String> labels;
  final ValueChanged<int>? onStepTap;

  @override
  Widget build(BuildContext context) {
    final int stepCount = labels.length;
    const double connectorWidth = 56;

    Color borderColorFor(int stepIndex) {
      if (stepIndex <= currentStepIndex - 1) return kPrimaryBlue;
      if (stepIndex == currentStepIndex) return kPrimaryBlue;
      return kFieldBorder;
    }

    Color fillColorFor(int stepIndex) {
      if (stepIndex <= currentStepIndex - 1) return kPrimaryBlue;
      if (stepIndex == currentStepIndex) return kPrimaryBlue.withOpacity(0.12);
      return Colors.white;
    }

    Widget circle(int stepIndex) {
      final isCompleted = stepIndex <= currentStepIndex - 1;
      final isActive = stepIndex == currentStepIndex;
      final bg = isCompleted ? kPrimaryBlue : fillColorFor(stepIndex);
      final border = Border.all(color: borderColorFor(stepIndex), width: 1.5);

      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: border,
        ),
        child:
            isCompleted
                ? const Icon(Icons.check, size: 15, color: Colors.white)
                : Icon(
                  Icons.circle,
                  size: 14,
                  color: isActive ? kPrimaryBlue : Colors.grey.shade400,
                ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () => onStepTap?.call(0),
                  borderRadius: BorderRadius.circular(14),
                  child: circle(0),
                ),
              ),
            ),
            if (stepCount == 2)
              SizedBox(
                width: connectorWidth,
                child: Center(
                  child: Container(
                    height: 2,
                    color:
                        currentStepIndex >= 1
                            ? kPrimaryBlue.withOpacity(0.9)
                            : kFieldBorder.withOpacity(0.35),
                  ),
                ),
              ),
            if (stepCount == 3)
              SizedBox(
                width: connectorWidth,
                child: Center(
                  child: Container(
                    height: 2,
                    color:
                        currentStepIndex >= 1
                            ? kPrimaryBlue.withOpacity(0.9)
                            : kFieldBorder.withOpacity(0.35),
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () => onStepTap?.call(1),
                  borderRadius: BorderRadius.circular(14),
                  child: circle(1),
                ),
              ),
            ),
            if (stepCount == 3)
              SizedBox(
                width: connectorWidth,
                child: Center(
                  child: Container(
                    height: 2,
                    color:
                        currentStepIndex >= 2
                            ? kPrimaryBlue.withOpacity(0.9)
                            : kFieldBorder.withOpacity(0.35),
                  ),
                ),
              ),
            if (stepCount == 3)
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () => onStepTap?.call(2),
                    borderRadius: BorderRadius.circular(14),
                    child: circle(2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  labels[0],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        currentStepIndex == 0
                            ? FontWeight.w800
                            : FontWeight.w700,
                    color:
                        currentStepIndex == 0
                            ? kPrimaryBlue
                            : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: connectorWidth,
              child: stepCount == 2 ? const SizedBox() : const SizedBox(),
            ),
            Expanded(
              child: Center(
                child: Text(
                  labels[1],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        currentStepIndex == 1
                            ? FontWeight.w800
                            : FontWeight.w700,
                    color:
                        currentStepIndex == 1
                            ? kPrimaryBlue
                            : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            if (stepCount == 3)
              SizedBox(width: connectorWidth, child: const SizedBox()),
            if (stepCount == 3)
              Expanded(
                child: Center(
                  child: Text(
                    labels[2],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          currentStepIndex == 2
                              ? FontWeight.w800
                              : FontWeight.w700,
                      color:
                          currentStepIndex == 2
                              ? kPrimaryBlue
                              : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
