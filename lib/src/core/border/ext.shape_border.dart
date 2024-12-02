import 'package:couver_ui/src/core/border/gradient_circle_border.dart';
import 'package:couver_ui/src/core/border/gradient_rounded_rectangle_border.dart';
import 'package:couver_ui/src/core/border/gradient_stadium_border.dart';
import 'package:flutter/material.dart';

extension GradientShapeBorderExt on ShapeBorder {
  ShapeBorder copyWithGradient([Gradient? gradient]) {
    if (this is RoundedRectangleBorder) {
      return (this as RoundedRectangleBorder).toGradient(gradient);
    }
    if (this is CircleBorder) {
      return (this as CircleBorder).toGradient(gradient);
    }
    if (this is StadiumBorder) {
      return (this as StadiumBorder).toGradient(gradient);
    }
    return this;
  }
}
