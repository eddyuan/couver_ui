import 'dart:ui' as ui show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'gradient_border_side.dart';

extension GradientRoundedRectangleBorderExt on RoundedRectangleBorder {
  GradientRoundedRectangleBorder toGradient(Gradient? gradient) =>
      GradientRoundedRectangleBorder.fromBorder(
          border: this, gradient: gradient);
}

/// A rectangular border with rounded corners.
///
/// Typically used with [ShapeDecoration] to draw a box with a rounded
/// rectangle.
///
/// This shape can interpolate to and from [CircleBorder].
///
/// See also:
///
///  * [BorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also
///    describe a rounded rectangle.
class GradientRoundedRectangleBorder extends RoundedRectangleBorder {
  /// Creates a rounded rectangle border.
  ///
  /// The arguments must not be null.
  const GradientRoundedRectangleBorder({
    GradientBorderSide side = GradientBorderSide.none,
    super.borderRadius = BorderRadius.zero,
  }) : super(side: side);

  // final Gradient? gradient;

  factory GradientRoundedRectangleBorder.fromBorder({
    required RoundedRectangleBorder border,
    Gradient? gradient,
  }) =>
      GradientRoundedRectangleBorder(
        side: border.side.toGradient(gradient),
        borderRadius: border.borderRadius,
      );

  RoundedRectangleBorder dropGradient() =>
      RoundedRectangleBorder(borderRadius: borderRadius, side: side);

  /// The radii for each corner.
  // final BorderRadiusGeometry borderRadius;

  @override
  ShapeBorder scale(double t) {
    return GradientRoundedRectangleBorder(
      side: side.toGradient().scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is RoundedRectangleBorder) {
      return GradientRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    if (a is CircleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius: borderRadius,
        circularity: 1.0 - t,
        eccentricity: a.eccentricity,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is RoundedRectangleBorder) {
      return GradientRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    if (b is CircleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius: borderRadius,
        circularity: t,
        eccentricity: b.eccentricity,
      );
    }
    return super.lerpTo(b, t);
  }

  /// Returns a copy of this CRoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  GradientRoundedRectangleBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
    Gradient? gradient,
  }) {
    return GradientRoundedRectangleBorder(
      side: (side ?? this.side).toGradient(),
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final side = this.side.toGradient();
    if (side.gradient == null) {
      super.paint(canvas, rect, textDirection: textDirection);
    } else {
      switch (side.style) {
        case BorderStyle.none:
          break;
        case BorderStyle.solid:
          if (side.width == 0.0) {
            canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect),
                side.toGradientPaint(rect));
          } else {
            final Paint paint = Paint()..color = side.color;
            final RRect borderRect =
                borderRadius.resolve(textDirection).toRRect(rect);
            final RRect inner = borderRect.deflate(side.strokeInset);
            final RRect outer = borderRect.inflate(side.strokeOutset);
            if (side.gradient != null) {
              paint.shader = side.gradient?.createShader(rect);
            }
            canvas.drawDRRect(outer, inner, paint);
          }
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GradientRoundedRectangleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CRoundedRectangleBorder')}($side, $borderRadius)';
  }
}

class _GradientRoundedRectangleToCircleBorder extends OutlinedBorder {
  const _GradientRoundedRectangleToCircleBorder({
    GradientBorderSide side = GradientBorderSide.none,
    this.borderRadius = BorderRadius.zero,
    required this.circularity,
    required this.eccentricity,
  }) : super(side: side);

  final BorderRadiusGeometry borderRadius;
  final double circularity;
  final double eccentricity;

  @override
  ShapeBorder scale(double t) {
    return _GradientRoundedRectangleToCircleBorder(
      side: side.toGradient().scale(t),
      borderRadius: borderRadius * t,
      circularity: t,
      eccentricity: eccentricity,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientRoundedRectangleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        circularity: circularity * t,
        eccentricity: eccentricity,
      );
    }
    if (a is CircleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius: borderRadius,
        circularity: circularity + (1.0 - circularity) * (1.0 - t),
        eccentricity: a.eccentricity,
      );
    }
    if (a is _GradientRoundedRectangleToCircleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        circularity: ui.lerpDouble(a.circularity, circularity, t)!,
        eccentricity: eccentricity,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientRoundedRectangleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        circularity: circularity * (1.0 - t),
        eccentricity: eccentricity,
      );
    }
    if (b is CircleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius: borderRadius,
        circularity: circularity + (1.0 - circularity) * t,
        eccentricity: b.eccentricity,
      );
    }
    if (b is _GradientRoundedRectangleToCircleBorder) {
      return _GradientRoundedRectangleToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        circularity: ui.lerpDouble(circularity, b.circularity, t)!,
        eccentricity: eccentricity,
      );
    }
    return super.lerpTo(b, t);
  }

  Rect _adjustRect(Rect rect) {
    if (circularity == 0.0 || rect.width == rect.height) {
      return rect;
    }
    if (rect.width < rect.height) {
      final double partialDelta = (rect.height - rect.width) / 2;
      final double delta = circularity * partialDelta * (1.0 - eccentricity);
      return Rect.fromLTRB(
        rect.left,
        rect.top + delta,
        rect.right,
        rect.bottom - delta,
      );
    } else {
      final double partialDelta = (rect.width - rect.height) / 2;
      final double delta = circularity * partialDelta * (1.0 - eccentricity);
      return Rect.fromLTRB(
        rect.left + delta,
        rect.top,
        rect.right - delta,
        rect.bottom,
      );
    }
  }

  BorderRadius? _adjustBorderRadius(Rect rect, TextDirection? textDirection) {
    final BorderRadius resolvedRadius = borderRadius.resolve(textDirection);
    if (circularity == 0.0) {
      return resolvedRadius;
    }
    if (eccentricity != 0.0) {
      if (rect.width < rect.height) {
        return BorderRadius.lerp(
          resolvedRadius,
          BorderRadius.all(Radius.elliptical(
              rect.width / 2, (0.5 + eccentricity / 2) * rect.height / 2)),
          circularity,
        )!;
      } else {
        return BorderRadius.lerp(
          resolvedRadius,
          BorderRadius.all(Radius.elliptical(
              (0.5 + eccentricity / 2) * rect.width / 2, rect.height / 2)),
          circularity,
        )!;
      }
    }
    return BorderRadius.lerp(resolvedRadius,
        BorderRadius.circular(rect.shortestSide / 2), circularity);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect borderRect =
        _adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect));
    final RRect adjustedRect =
        borderRect.deflate(ui.lerpDouble(side.width, 0, side.strokeAlign)!);
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
          _adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect)));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    final BorderRadius adjustedBorderRadius =
        _adjustBorderRadius(rect, textDirection)!;
    if (adjustedBorderRadius == BorderRadius.zero) {
      canvas.drawRect(_adjustRect(rect), paint);
    } else {
      canvas.drawRRect(adjustedBorderRadius.toRRect(_adjustRect(rect)), paint);
    }
  }

  @override
  bool get preferPaintInterior => true;

  @override
  _GradientRoundedRectangleToCircleBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
    double? circularity,
    double? eccentricity,
  }) {
    return _GradientRoundedRectangleToCircleBorder(
      side: (side ?? this.side).toGradient(),
      borderRadius: borderRadius ?? this.borderRadius,
      circularity: circularity ?? this.circularity,
      eccentricity: eccentricity ?? this.eccentricity,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final side = this.side.toGradient();
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final BorderRadius adjustedBorderRadius =
            _adjustBorderRadius(rect, textDirection)!;
        final RRect borderRect =
            adjustedBorderRadius.toRRect(_adjustRect(rect));
        canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2),
            side.toGradientPaint(rect));
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _GradientRoundedRectangleToCircleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.circularity == circularity;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, circularity);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return 'CRoundedRectangleBorder($side, $borderRadius, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder that is ${(eccentricity * 100).toStringAsFixed(1)}% oval)';
    }
    return 'CRoundedRectangleBorder($side, $borderRadius, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder)';
  }
}
