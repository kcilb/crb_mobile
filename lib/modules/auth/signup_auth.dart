import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:crb_mobile/modules/dashboard/credit_dashboard.dart';
import 'package:flutter/material.dart';

/// Signup screen with panel-style form sections.
class SignupAuth extends StatefulWidget {
  const SignupAuth({super.key});

  @override
  State<SignupAuth> createState() => _SignupAuthState();
}

class _SignupAuthState extends State<SignupAuth>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _emailKey = GlobalKey();
  final GlobalKey _passwordKey = GlobalKey();
  final GlobalKey _confirmKey = GlobalKey();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  late final AnimationController _gridController;
  late final Animation<double> _gridOffset;

  bool _rememberMe = true; // used as "Agree to Terms" checkbox UI
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _gridOffset = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _gridController, curve: Curves.linear),
    );

    void wire(FocusNode node, GlobalKey key) {
      node.addListener(() {
        if (node.hasFocus) _scrollTo(key);
      });
    }

    wire(_nameFocus, _nameKey);
    wire(_emailFocus, _emailKey);
    wire(_passwordFocus, _passwordKey);
    wire(_confirmFocus, _confirmKey);
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.18,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _gridController.dispose();
    _scrollController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const headerFlex = 42;
    const cardFlex = 58;
    const overlap = 28.0;

    // Match the same palette used in `user_auth.dart` but keep local constants
    // to avoid importing private fields.
    const Color primary = Color(0xFFEA580C); // dark orange accent
    const Color themeBg = Color(0xFF7C2D12);

    const panelBorder = Color(0xFFE7E7EA);
    const panelTint = Color(0xFFF6F7FB);
    const fieldFill = Color(0xFFEEF1F6);
    const fieldBorder = Color(0xFFD1D9E3);

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(color: themeBg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final headerH = h * headerFlex / (headerFlex + cardFlex);
            final bottomInset = MediaQuery.paddingOf(context).bottom;

            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                // Header area with animated grid.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: headerH,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(decoration: const BoxDecoration(color: themeBg)),
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
                                child: const Icon(
                                  Icons.shield_outlined,
                                  size: 36,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 28),
                              const Text(
                                'Create your Account',
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
                              Text(
                                'Sign up to get started securely',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.92),
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

                // White card: from below header overlap to bottom of screen.
                Positioned(
                  left: 0,
                  right: 16,
                  top: headerH - overlap,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(36),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(36),
                      ),
                      child: SingleChildScrollView(
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
                            _PanelSection(
                              title: 'Account details',
                              borderColor: panelBorder,
                              tintColor: panelTint,
                              child: Column(
                                children: [
                                  Container(
                                    key: _nameKey,
                                    child: TextFormField(
                                      focusNode: _nameFocus,
                                      textInputAction: TextInputAction.next,
                                      style: kFieldInputTextStyle,
                                      decoration: _fieldDecoration(
                                        label: 'Full name',
                                        fill: fieldFill,
                                        border: fieldBorder,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    key: _emailKey,
                                    child: TextFormField(
                                      focusNode: _emailFocus,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.emailAddress,
                                      style: kFieldInputTextStyle,
                                      decoration: _fieldDecoration(
                                        label: 'Email',
                                        fill: fieldFill,
                                        border: fieldBorder,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            _PanelSection(
                              title: 'Password',
                              borderColor: panelBorder,
                              tintColor: panelTint,
                              child: Column(
                                children: [
                                  Container(
                                    key: _passwordKey,
                                    child: TextFormField(
                                      focusNode: _passwordFocus,
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.next,
                                      style: kFieldInputTextStyle,
                                      decoration: _fieldDecoration(
                                        label: 'Password',
                                        fill: fieldFill,
                                        border: fieldBorder,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.grey.shade600,
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    key: _confirmKey,
                                    child: TextFormField(
                                      focusNode: _confirmFocus,
                                      obscureText: _obscureConfirm,
                                      textInputAction: TextInputAction.done,
                                      style: kFieldInputTextStyle,
                                      decoration: _fieldDecoration(
                                        label: 'Confirm password',
                                        fill: fieldFill,
                                        border: fieldBorder,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirm
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.grey.shade600,
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureConfirm = !_obscureConfirm;
                                            });
                                          },
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
                                            setState(() {
                                              _rememberMe = v ?? false;
                                            });
                                          },
                                          activeColor: primary,
                                          side: BorderSide(
                                            color: Colors.grey.shade400,
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

                            const SizedBox(height: 22),

                            SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CreditDashboard(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shadowColor: Colors.black.withOpacity(0.28),
                                  surfaceTintColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'Log in',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  InputDecoration _fieldDecoration({
    required String label,
    required Color fill,
    required Color border,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: kFieldLabelStyle,
      floatingLabelStyle: kFieldLabelStyle,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: border, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kPrimaryBlue, width: 1.5),
      ),
    );
  }
}

class _PanelSection extends StatelessWidget {
  const _PanelSection({
    required this.title,
    required this.borderColor,
    required this.tintColor,
    required this.child,
  });

  final String title;
  final Color borderColor;
  final Color tintColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tintColor,
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: kFieldTextColor,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  _GridPatternPainter({required this.offset});

  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
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
  bool shouldRepaint(covariant _GridPatternPainter oldDelegate) => true;
}

