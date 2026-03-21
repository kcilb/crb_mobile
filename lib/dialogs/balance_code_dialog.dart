import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:crb_mobile/dialogs/dialog_theme.dart';

/// View-balances code entry — **same visuals and layout as [OtpDialog]** (dark card,
/// pattern, chip, digits). Only the top icon is a wallet instead of mail; no resend row.
class BalanceCodeDialog extends StatefulWidget {
  const BalanceCodeDialog({
    super.key,
    this.title = 'View balances',
    this.subtitle = 'Enter your 4‑digit code to reveal amounts.',
    this.validCode = '1234',
  });

  final String title;
  final String subtitle;

  /// Demo / stub: when all digits match this string, [show] returns `true`.
  final String validCode;

  /// Returns `true` if the entered code matches [validCode], `false` if wrong,
  /// `null` if dismissed (outside tap, system back, etc.) without submitting.
  static Future<bool?> show(
    BuildContext context, {
    String title = 'View balances',
    String subtitle = 'Enter your 4‑digit code to reveal amounts.',
    String validCode = '1234',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => BalanceCodeDialog(
            title: title,
            subtitle: subtitle,
            validCode: validCode,
          ),
    );
  }

  @override
  State<BalanceCodeDialog> createState() => _BalanceCodeDialogState();
}

class _BalanceCodeDialogState extends State<BalanceCodeDialog>
    with SingleTickerProviderStateMixin {
  static const int _codeLength = 4;
  static const double _minBoxSize = 36;
  static const double _maxBoxSize = 48;
  static const double _gap = 8;

  late final AnimationController _moneyIconController;
  late final Animation<double> _moneyPulse;

  final List<TextEditingController> _digitControllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _digitFocusNodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );

  bool _popped = false;

  String get _code => _digitControllers.map((c) => c.text).join();

  bool get _codeComplete {
    if (_code.length != _codeLength) return false;
    return !_code.contains(RegExp(r'[^0-9]'));
  }

  void _tryComplete() {
    if (!mounted || _popped) return;
    if (!_codeComplete) return;
    _popped = true;
    final ok = _code == widget.validCode;
    Navigator.of(context).pop(ok);
  }

  void _onControllersChanged() {
    if (!mounted || _popped) return;
    if (!_codeComplete) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tryComplete();
    });
  }

  @override
  void initState() {
    super.initState();
    _moneyIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _moneyPulse = CurvedAnimation(
      parent: _moneyIconController,
      curve: Curves.easeInOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _digitFocusNodes.first.requestFocus();
    });
    for (final c in _digitControllers) {
      c.addListener(_onControllersChanged);
    }
  }

  @override
  void dispose() {
    _moneyIconController.dispose();
    for (final c in _digitControllers) {
      c.removeListener(_onControllersChanged);
      c.dispose();
    }
    for (final f in _digitFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Same as [OtpDialog] digit styling.
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
        if (targetIndex >= _codeLength) break;
        _digitControllers[targetIndex].text = digits[offset];
      }
    });

    final nextIndex = index + digits.length;
    if (nextIndex < _codeLength) {
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
                    final boxSize =
                        ((availableWidth - (_codeLength - 1) * _gap) /
                                _codeLength)
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
                            Center(child: _buildMoneyIconChip()),
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
                            if (widget.subtitle.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitle,
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
                                    for (int i = 0; i < _codeLength; i++) ...[
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

  /// Same chip layout as [OtpDialog] envelope; wallet icon + "CODE" label.
  Widget _buildMoneyIconChip() {
    return AnimatedBuilder(
      animation: _moneyPulse,
      builder: (context, child) {
        final t = _moneyPulse.value;
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
              Icons.account_balance_wallet_rounded,
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
}
