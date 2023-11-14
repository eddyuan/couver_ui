import 'package:flutter/material.dart';

extension CouverBorderRadiusExtension on BorderRadius {
  BorderRadius modifyBy(double amount) {
    if (amount != 0) {
      final double tl = topLeft.x + amount;
      final double tr = topRight.x + amount;
      final double bl = bottomLeft.x + amount;
      final double br = bottomRight.x + amount;
      return BorderRadius.only(
        topLeft: tl > 0 ? Radius.circular(tl) : Radius.zero,
        topRight: tr > 0 ? Radius.circular(tr) : Radius.zero,
        bottomLeft: bl > 0 ? Radius.circular(bl) : Radius.zero,
        bottomRight: br > 0 ? Radius.circular(br) : Radius.zero,
      );
    }
    return this;
  }
}
