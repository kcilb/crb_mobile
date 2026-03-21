import 'dart:math' as math;

import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Horizontal slide that completes with [LocalAuthentication] (fingerprint / Face ID).
class SlideToBiometricBar extends StatefulWidget {
  const SlideToBiometricBar({
    super.key,
    required this.onAuthenticated,
  });

  /// Called after biometric succeeds (navigate / complete login).
  final Future<void> Function() onAuthenticated;

  @override
  State<SlideToBiometricBar> createState() => _SlideToBiometricBarState();
}

class _SlideToBiometricBarState extends State<SlideToBiometricBar> {
  double _dragPx = 0;
  bool _busy = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  static const double _height = 52;
  static const double _thumbSize = 46;
  static const double _pad = 3;

  Future<void> _runBiometricThenComplete() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: 'Authenticate to sign in to CreditTrack',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (!mounted) return;
      if (ok) {
        HapticFeedback.mediumImpact();
        await widget.onAuthenticated();
      } else {
        HapticFeedback.selectionClick();
        setState(() => _dragPx = 0);
      }
    } on PlatformException catch (_) {
      if (mounted) {
        HapticFeedback.selectionClick();
        setState(() => _dragPx = 0);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final trackW = maxW - _pad * 2;
        final maxDrag = math.max(0.0, trackW - _thumbSize);

        void clampDrag() {
          _dragPx = _dragPx.clamp(0.0, maxDrag);
        }

        return SizedBox(
          height: _height,
          width: double.infinity,
          child: Material(
            color: kFieldFill,
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  child: Center(
                    child: IgnorePointer(
                      child: Text(
                        _busy ? 'Authenticating…' : 'Slide to use biometric',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kFieldTextColor.withOpacity(0.45),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: _pad + _dragPx,
                  top: (_height - _thumbSize) / 2,
                  child: GestureDetector(
                    onHorizontalDragUpdate: _busy
                        ? null
                        : (d) {
                            setState(() {
                              _dragPx += d.delta.dx;
                              clampDrag();
                            });
                          },
                    onHorizontalDragEnd: _busy
                        ? null
                        : (_) {
                            if (maxDrag <= 0) return;
                            if (_dragPx >= maxDrag * 0.88) {
                              _runBiometricThenComplete();
                            } else {
                              setState(() => _dragPx = 0);
                            }
                          },
                    child: Material(
                      color: kPrimaryBlue,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.35),
                      shape: const CircleBorder(),
                      child: SizedBox(
                        width: _thumbSize,
                        height: _thumbSize,
                        child: Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
