import 'package:couver_ui/src/core/painter/c_circle_border.dart';
import 'package:couver_ui/src/core/painter/c_rounded_rectangle_border.dart';
import 'package:couver_ui/src/core/painter/c_stadium_border.dart';
import 'package:flutter/material.dart';

extension GradientShapeBorder on ShapeBorder {
  ShapeBorder copyWithGradient(Gradient? gradient) {
    // print("copyWithGradient");
    // print(this.runtimeType);
    // print("this is RoundedRectangleBorder");
    // print(this is RoundedRectangleBorder);
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
