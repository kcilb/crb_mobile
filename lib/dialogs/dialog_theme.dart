import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared theme for app dialogs (OTP, success, etc.).
const Color kPrimaryBlue = Color(0xFFEA580C);
const Color kThemeBg = Color(0xFF7C2D12);

/// Light surface tint of [kPrimaryBlue] (orange-50) — form field backgrounds.
const Color kFieldFill = Color(0xFFFFF7ED);

/// Mid tint of [kPrimaryBlue] (orange-200) — field outlines; reads on light fills.
const Color kFieldBorder = Color(0xFFFED7AA);

/// Soft dark gray for labels and body text (easier than pure black on light UI).
const Color kFieldTextColor = Color(0xFF4B5563);

/// Resting / floating label for text fields.
const TextStyle kFieldLabelStyle = TextStyle(
  color: kFieldTextColor,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

/// Typed text inside text fields.
const TextStyle kFieldInputTextStyle = TextStyle(
  color: kFieldTextColor,
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

// --- OTP-style dialogs ([OtpDialog], [BalanceCodeDialog]) ---

/// Blended surface behind OTP / balance code entry.
Color get kOtpDialogBackground => Color.lerp(kThemeBg, kPrimaryBlue, 0.42)!;

/// Icon chip fill (envelope / lock) on OTP-style dialogs.
Color get kOtpDialogCardFill => Color.lerp(kFieldFill, Colors.white, 0.6)!;

/// Icon stroke and digit focus ring color on OTP-style dialogs.
Color get kOtpDialogOutline => kThemeBg;

/// Paints subtle white circles and plus signs (OTP / balance code dialogs).
class OtpDialogBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    final rnd = (int seed) => (seed * 97 + 31) % 100 / 100.0;
    for (int i = 0; i < 24; i++) {
      final x = size.width * (0.1 + rnd(i * 7) * 0.8);
      final y = size.height * (0.05 + rnd(i * 11) * 0.35);
      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), 4 + rnd(i * 13) * 6, paint);
      } else {
        final s = 3 + rnd(i * 17) * 3;
        canvas.drawLine(Offset(x - s, y), Offset(x + s, y), paint);
        canvas.drawLine(Offset(x, y - s), Offset(x, y + s), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Light card surface for [BalanceCodeDialog] (inverted vs dark OTP card).
Color get kBalanceDialogBackground =>
    Color.lerp(Colors.white, kOtpDialogBackground, 0.07)!;

/// Subtle dark pattern on [kBalanceDialogBackground] (inverse of [OtpDialogBackgroundPainter]).
class BalanceDialogBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = kThemeBg.withOpacity(0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    final rnd = (int seed) => (seed * 97 + 31) % 100 / 100.0;
    for (int i = 0; i < 24; i++) {
      final x = size.width * (0.1 + rnd(i * 7) * 0.8);
      final y = size.height * (0.05 + rnd(i * 11) * 0.35);
      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), 4 + rnd(i * 13) * 6, paint);
      } else {
        final s = 3 + rnd(i * 17) * 3;
        canvas.drawLine(Offset(x - s, y), Offset(x + s, y), paint);
        canvas.drawLine(Offset(x, y - s), Offset(x, y + s), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Decorative gradient blobs at the bottom of dialog cards.
/// [phase] in \[0,1\] drives gentle motion on blobs, rings, and dots (loop the animation).
class BottomAbstractShapesPainter extends CustomPainter {
  const BottomAbstractShapesPainter({
    required this.backgroundColor,
    required this.accentColor,
    this.phase = 0,
  });

  final Color backgroundColor;
  final Color accentColor;

  /// Normalized animation phase for subtle movement.
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final baseShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        backgroundColor.withOpacity(0.00),
        backgroundColor.withOpacity(0.24),
        accentColor.withOpacity(0.28),
      ],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = baseShader);

    // Rings / dots use accent tints only (no white).
    final ringPaint = Paint()
      ..color = accentColor.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final dotPaint = Paint()
      ..color = accentColor.withOpacity(0.42)
      ..style = PaintingStyle.fill;
    final accentDotPaint = Paint()
      ..color = accentColor.withOpacity(0.22)
      ..style = PaintingStyle.fill;

    final t = phase * 2 * math.pi;

    void blob(Offset c, double r, double opacity) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = accentColor.withOpacity(opacity)
          ..style = PaintingStyle.fill,
      );
    }

    // Large blobs — slow drift
    final driftX = math.sin(t) * size.width * 0.024;
    final driftY = math.cos(t * 0.85) * size.height * 0.02;
    blob(
      Offset(-size.width * 0.05 + driftX, size.height * 0.98 + driftY),
      size.height * 0.62,
      0.14,
    );
    blob(
      Offset(
        size.width * 0.62 + math.sin(t + 1.2) * size.width * 0.018,
        size.height * 0.80 + math.cos(t + 0.7) * size.height * 0.014,
      ),
      size.height * 0.58,
      0.11,
    );
    blob(
      Offset(
        size.width * 0.78 + math.sin(t + 2.1) * size.width * 0.014,
        size.height * 0.64 + math.cos(t + 1.4) * size.height * 0.012,
      ),
      size.height * 0.36,
      0.12,
    );

    void dottedRing(Offset c, double r, int dots, double spin) {
      final dotR = (r * 0.08).clamp(1.0, 4.5);
      for (int i = 0; i < dots; i++) {
        final a = (i / dots) * 2 * math.pi + spin;
        final p = Offset(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r);
        canvas.drawCircle(p, dotR, dotPaint);
      }
    }

    for (int i = 0; i < 28; i++) {
      final fx = (((i * 73) % 100) / 100.0);
      final fy = (((i * 41) % 100) / 100.0);
      final x = fx * size.width;
      final y = (0.10 + fy * 0.90) * size.height;
      final pulse = 1 + 0.045 * math.sin(t + i * 0.31);
      final r =
          ((size.height * 0.06) + (((i * 19) % 100) / 100.0) * (size.height * 0.14)) *
          pulse;

      if (i % 4 == 0) {
        dottedRing(Offset(x, y), r, 18 + (i % 6) * 2, t * 0.4 + i * 0.05);
      } else if (i % 4 == 1) {
        dottedRing(Offset(x, y), r, 10 + (i % 5) * 3, -t * 0.35);
      } else {
        canvas.drawCircle(Offset(x, y), r, ringPaint);
      }
    }

    for (int k = 0; k < 70; k++) {
      final fx = (((k * 37) % 100) / 100.0);
      final fy = (((k * 53) % 100) / 100.0);
      var x = fx * size.width;
      var y = (0.25 + fy * 0.70) * size.height;
      if (k % 5 == 0) {
        x += math.sin(t + k * 0.2) * 2.8;
        y += math.cos(t * 1.1 + k * 0.15) * 2.2;
      }
      final r =
          (1.4 + (((k * 11) % 100) / 100.0) * 2.6) *
          (k % 6 == 0 ? 1 + 0.12 * math.sin(t * 1.3 + k) : 1.0);
      if (k % 7 == 0) {
        canvas.drawCircle(Offset(x, y), r, accentDotPaint);
      } else {
        canvas.drawCircle(Offset(x, y), r, dotPaint);
      }
    }

    final lineY = size.height * 0.82 + math.sin(t * 0.6) * 3;
    for (double x = -size.width * 0.05; x < size.width * 0.55; x += size.width * 0.02) {
      canvas.drawCircle(Offset(x, lineY), 2.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is BottomAbstractShapesPainter &&
        (oldDelegate.backgroundColor != backgroundColor ||
            oldDelegate.accentColor != accentColor ||
            oldDelegate.phase != phase);
  }
}
