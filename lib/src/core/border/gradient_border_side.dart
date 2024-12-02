import 'package:flutter/widgets.dart';

import 'dart:math' as math;
import 'dart:ui' as ui show lerpDouble;

extension GradientBorderSideExt on BorderSide {
  GradientBorderSide toGradient([Gradient? gradient]) =>
      GradientBorderSide.fromBorder(border: this, gradient: gradient);
}

class GradientBorderSide extends BorderSide {
  const GradientBorderSide({
    super.color = const Color(0xFF000000),
    super.width = 1.0,
    super.style = BorderStyle.solid,
    super.strokeAlign = BorderSide.strokeAlignInside,
    this.gradient,
  }) : assert(width >= 0.0);

  factory GradientBorderSide.fromBorder({
    required BorderSide border,
    Gradient? gradient,
  }) {
    if (border is GradientBorderSide) {
      return border.copyWith(gradient: gradient);
    }
    return GradientBorderSide(
      color: border.color,
      width: border.width,
      style: border.style,
      strokeAlign: border.strokeAlign,
      gradient: gradient,
    );
  }

  final Gradient? gradient;

  /// Creates a [BorderSide] that represents the addition of the two given
  /// [BorderSide]s.
  ///
  /// It is only valid to call this if [canMerge] returns true for the two
  /// sides.
  ///
  /// If one of the sides is zero-width with [BorderStyle.none], then the other
  /// side is return as-is. If both of the sides are zero-width with
  /// [BorderStyle.none], then [BorderSide.none] is returned.
  static GradientBorderSide merge(GradientBorderSide a, GradientBorderSide b) {
    assert(canMerge(a, b));
    final bool aIsNone = a.style == BorderStyle.none && a.width == 0.0;
    final bool bIsNone = b.style == BorderStyle.none && b.width == 0.0;
    if (aIsNone && bIsNone) {
      return GradientBorderSide.none;
    }
    if (aIsNone) {
      return b;
    }
    if (bIsNone) {
      return a;
    }
    assert(a.color == b.color);
    assert(a.style == b.style);
    return GradientBorderSide(
      color: a.color,
      width: a.width + b.width,
      strokeAlign: math.max(a.strokeAlign, b.strokeAlign),
      style: a.style,
      gradient: a.gradient,
    );
  }

  /// A hairline black border that is not rendered.
  static const GradientBorderSide none =
      GradientBorderSide(width: 0.0, style: BorderStyle.none);

  /// Creates a copy of this border but with the given fields replaced with the new values.
  @override
  GradientBorderSide copyWith({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
    Gradient? gradient,
  }) {
    return GradientBorderSide(
      color: color ?? this.color,
      width: width ?? this.width,
      style: style ?? this.style,
      strokeAlign: strokeAlign ?? this.strokeAlign,
      gradient: gradient ?? this.gradient,
    );
  }

  /// Creates a copy of this border side description but with the width scaled
  /// by the factor `t`.
  ///
  /// The `t` argument represents the multiplicand, or the position on the
  /// timeline for an interpolation from nothing to `this`, with 0.0 meaning
  /// that the object returned should be the nil variant of this object, 1.0
  /// meaning that no change should be applied, returning `this` (or something
  /// equivalent to `this`), and other values meaning that the object should be
  /// multiplied by `t`. Negative values are treated like zero.
  ///
  /// Since a zero width is normally painted as a hairline width rather than no
  /// border at all, the zero factor is special-cased to instead change the
  /// style to [BorderStyle.none].
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  @override
  GradientBorderSide scale(double t) {
    return GradientBorderSide(
      color: color,
      width: math.max(0.0, width * t),
      style: t <= 0.0 ? BorderStyle.none : style,
      gradient: gradient,
    );
  }

  Paint toGradientPaint(Rect rect) {
    final Paint paint = toPaint();
    if (gradient != null) {
      paint.shader = gradient?.createShader(rect);
    }
    return paint;
  }

  /// Whether the two given [BorderSide]s can be merged using
  /// [BorderSide.merge].
  ///
  /// Two sides can be merged if one or both are zero-width with
  /// [BorderStyle.none], or if they both have the same color and style.
  static bool canMerge(GradientBorderSide a, GradientBorderSide b) {
    if ((a.style == BorderStyle.none && a.width == 0.0) ||
        (b.style == BorderStyle.none && b.width == 0.0)) {
      return true;
    }
    return a.style == b.style && a.color == b.color && a.gradient == b.gradient;
  }

  /// Linearly interpolate between two border sides.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static GradientBorderSide lerp(
      GradientBorderSide a, GradientBorderSide b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    final double width = ui.lerpDouble(a.width, b.width, t)!;
    if (width < 0.0) {
      return GradientBorderSide.none;
    }
    if (a.style == b.style && a.strokeAlign == b.strokeAlign) {
      return GradientBorderSide(
        color: Color.lerp(a.color, b.color, t)!,
        width: width,
        style: a.style, // == b.style
        strokeAlign: a.strokeAlign, // == b.strokeAlign
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
      );
    }
    final Color colorA = switch (a.style) {
      BorderStyle.solid => a.color,
      BorderStyle.none => a.color.withAlpha(0x00),
    };
    final Color colorB = switch (b.style) {
      BorderStyle.solid => b.color,
      BorderStyle.none => b.color.withAlpha(0x00),
    };
    final Gradient? gradientA = switch (a.style) {
      BorderStyle.solid => a.gradient,
      BorderStyle.none => null,
    };
    final Gradient? gradientB = switch (b.style) {
      BorderStyle.solid => b.gradient,
      BorderStyle.none => null,
    };
    if (a.strokeAlign != b.strokeAlign) {
      return GradientBorderSide(
        color: Color.lerp(colorA, colorB, t)!,
        width: width,
        strokeAlign: ui.lerpDouble(a.strokeAlign, b.strokeAlign, t)!,
        gradient: Gradient.lerp(gradientA, gradientB, t),
      );
    }
    return GradientBorderSide(
      color: Color.lerp(colorA, colorB, t)!,
      width: width,
      strokeAlign: a.strokeAlign, // == b.strokeAlign
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GradientBorderSide &&
        other.color == color &&
        other.width == width &&
        other.style == style &&
        other.strokeAlign == strokeAlign &&
        other.gradient == gradient;
  }

  @override
  int get hashCode => Object.hash(color, width, style, strokeAlign, gradient);

  @override
  String toStringShort() => 'GradientBorderSide';
}
