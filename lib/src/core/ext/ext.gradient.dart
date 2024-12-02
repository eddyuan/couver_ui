import 'package:flutter/material.dart';

extension LinearGradientExt on LinearGradient {
  LinearGradient withAlpha(int alpha) {
    return LinearGradient(
      begin: begin,
      end: end,
      stops: stops,
      tileMode: tileMode,
      transform: transform,
      colors: colors.map((x) => x.withAlpha(alpha)).toList(),
    );
  }
}

extension RadialGradientExt on RadialGradient {
  RadialGradient withAlpha(int alpha) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: colors.map((x) => x.withAlpha(alpha)).toList(),
      stops: stops,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
    );
  }
}

extension SweepGradientExt on SweepGradient {
  SweepGradient withAlpha(int alpha) {
    return SweepGradient(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      colors: colors.map((x) => x.withAlpha(alpha)).toList(),
      stops: stops,
      tileMode: tileMode,
      transform: transform,
    );
  }
}
