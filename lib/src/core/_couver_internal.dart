import 'dart:ui';

import 'package:flutter/material.dart';

class CouverInternal {
  static bool isDark(Color color, {double threshold = 0.15}) {
    final double relativeLuminance = color.computeLuminance();
    return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) <=
        threshold);
  }

  static Color contrastColor(Color color, {double threshold = 0.15}) {
    return isDark(color, threshold: threshold)
        ? const Color(0xffffffff)
        : const Color(0xff000000);
  }

  static Color contrastColorTrans(
    Color color, {
    double blackOpacity = 0.12,
    double whiteOpacity = 0.24,
    double threshold = 0.15,
  }) {
    return isDark(color, threshold: threshold)
        ? const Color(0xffffffff).withOpacity(whiteOpacity)
        : const Color(0xff000000).withOpacity(blackOpacity);
  }

  static BorderRadius borderRadiusModifyBy(BorderRadius radius, double amount) {
    if (amount != 0) {
      final double tl = radius.topLeft.x + amount;
      final double tr = radius.topRight.x + amount;
      final double bl = radius.bottomLeft.x + amount;
      final double br = radius.bottomRight.x + amount;
      return BorderRadius.only(
        topLeft: tl > 0 ? Radius.circular(tl) : Radius.zero,
        topRight: tr > 0 ? Radius.circular(tr) : Radius.zero,
        bottomLeft: bl > 0 ? Radius.circular(bl) : Radius.zero,
        bottomRight: br > 0 ? Radius.circular(br) : Radius.zero,
      );
    }
    return radius;
  }
}
