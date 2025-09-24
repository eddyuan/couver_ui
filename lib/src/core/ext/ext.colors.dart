import 'package:flutter/material.dart';
import 'dart:math' as math;

extension CouverLinearGradientExt on LinearGradient {
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

extension CouverRadialGradientExt on RadialGradient {
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

extension CouverSweepGradientExt on SweepGradient {
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

extension NSColorExt on Color {
  Color blendWithOpacity(Color bottomColor) {
    final topColor = this;
    final double tAlpha = topColor.opacity;
    if (tAlpha >= 1) {
      return topColor;
    }

    final double tBeta = 1 - tAlpha;
    final int tRed = (tAlpha * topColor.red + tBeta * bottomColor.red).round();
    final int tGreen =
        (tAlpha * topColor.green + tBeta * bottomColor.green).round();
    final int tBlue =
        (tAlpha * topColor.blue + tBeta * bottomColor.blue).round();
    return Color.fromRGBO(tRed, tGreen, tBlue, 1);
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Judge if a color is dark
  bool isDark([double threshold = 0.15]) {
    final double relativeLuminance = computeLuminance();
    return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) <=
        threshold);
  }

  /// Return a black or white color based on darkness
  Color contrastColor([double threshold = 0.15]) {
    return isDark(threshold)
        ? const Color(0xffffffff)
        : const Color(0xff000000);
  }

  /// Return a black or white color based on darkness but with opacity
  Color contrastColorTrans({
    double blackOpacity = 0.12,
    double whiteOpacity = 0.24,
    double threshold = 0.15,
  }) {
    return isDark(threshold)
        ? const Color(0xffffffff).withAlpha((whiteOpacity * 255).round())
        : const Color(0xff000000).withAlpha((blackOpacity * 255).round());
  }

  static int _shadeValue(int value, double factor) =>
      math.max(0, math.min(value - (value * factor).round(), 255));

  /// Shade a color
  Color withShade(double factor) => Color.fromARGB(
        255,
        _shadeValue((r * 255).round(), factor),
        _shadeValue((g * 255).round(), factor),
        _shadeValue((b * 255).round(), factor),
      );

  static int _lightenValue(int value, double factor) =>
      math.max(0, math.min(value + (value * factor).round(), 255));

  /// Lighten a color
  Color withLighten(double factor) => Color.fromARGB(
        255,
        _lightenValue((r * 255).round(), factor),
        _lightenValue((g * 255).round(), factor),
        _lightenValue((b * 255).round(), factor),
      );

  static int _tintValue(int value, double factor) =>
      math.max(0, math.min((value + ((255 - value) * factor)).round(), 255));

  /// Tint a color
  Color withTint(double factor) => Color.fromARGB(
        255,
        _tintValue((r * 255).round(), factor),
        _tintValue((g * 255).round(), factor),
        _tintValue((b * 255).round(), factor),
      );

  /// Generate [MaterialColor] from [Color]
  MaterialColor toMaterialColor() => MaterialColor(toARGB32(), {
        50: withTint(1 * 0.95),
        100: withTint(0.8 * 0.95),
        200: withTint(0.6 * 0.95),
        300: withTint(0.4 * 0.95),
        400: withTint(0.2 * 0.95),
        500: this,
        600: withTint(0.15),
        700: withTint(0.3),
        800: withTint(0.45),
        900: withTint(0.6),
      });

  Color darkenOrLightenByContrast({
    double threshold = 0.15,
    double darken = 0.1,
    double lighten = 0.1,
  }) {
    final isDarkColor = isDark(threshold);
    if (isDarkColor) return withLighten(lighten);
    return withShade(darken);
  }
}
