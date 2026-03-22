import 'package:flutter/material.dart';

/// Raster from [tool/generate_launcher_icons.mjs] — same artwork as launcher / native splash.
class CreditTrackAppIconMark extends StatelessWidget {
  const CreditTrackAppIconMark({
    super.key,
    this.size = 46,
    this.clipStyle = CreditTrackAppIconMarkClip.squircle,
  });

  static const assetPath = 'assets/images/credittrack_app_icon.png';

  final double size;
  final CreditTrackAppIconMarkClip clipStyle;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
    return switch (clipStyle) {
      CreditTrackAppIconMarkClip.squircle => ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.2237),
          child: image,
        ),
      CreditTrackAppIconMarkClip.circle => ClipOval(child: image),
    };
  }
}

enum CreditTrackAppIconMarkClip { squircle, circle }
