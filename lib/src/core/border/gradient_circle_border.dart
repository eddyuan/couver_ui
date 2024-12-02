import 'dart:ui' as ui show lerpDouble, clampDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'gradient_border_side.dart';

extension GradientCircleBorderExt on CircleBorder {
  GradientCircleBorder toGradient(Gradient? gradient) =>
      GradientCircleBorder.fromBorder(border: this, gradient: gradient);
}

/// A border that fits a circle within the available space.
///
/// Typically used with [ShapeDecoration] to draw a circle.
///
/// The [dimensions] assume that the border is being used in a square space.
/// When applied to a rectangular space, the border paints in the center of the
/// rectangle.
///
/// The [eccentricity] parameter describes how much a circle will deform to
/// fit the rectangle it is a border for. A value of zero implies no
/// deformation (a circle touching at least two sides of the rectangle), a
/// value of one implies full deformation (an oval touching all sides of the
/// rectangle).
///
/// See also:
///
///  * [OvalBorder], which draws a Circle touching all the edges of the box.
///  * [BorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also describe a circle.

class GradientCircleBorder extends CircleBorder {
  /// Create a circle border.
  ///
  /// The [side] argument must not be null.
  const GradientCircleBorder({
    GradientBorderSide side = GradientBorderSide.none,
    super.eccentricity = 0.0,
  }) : super(side: side);

  // final Gradient? gradient;

  CircleBorder dropGradient() =>
      CircleBorder(side: side, eccentricity: eccentricity);

  factory GradientCircleBorder.fromBorder({
    required CircleBorder border,
    Gradient? gradient,
  }) =>
      GradientCircleBorder(
        side: border.side.toGradient(gradient),
        eccentricity: border.eccentricity,
      );

  @override
  ShapeBorder scale(double t) => GradientCircleBorder(
        side: side.toGradient().scale(t),
        eccentricity: eccentricity,
      );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientCircleBorder) {
      return GradientCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        eccentricity: ui.clampDouble(
            ui.lerpDouble(a.eccentricity, eccentricity, t)!, 0.0, 1.0),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientCircleBorder) {
      return GradientCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        eccentricity: ui.clampDouble(
            ui.lerpDouble(eccentricity, b.eccentricity, t)!, 0.0, 1.0),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  GradientCircleBorder copyWith({
    BorderSide? side,
    double? eccentricity,
    Gradient? gradient,
  }) {
    return GradientCircleBorder(
      side: (side ?? this.side).toGradient(),
      eccentricity: eccentricity ?? this.eccentricity,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final side = this.side.toGradient();
    if (side.gradient == null) {
      super.paint(canvas, rect, textDirection: textDirection);
      return;
    }

    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        if (eccentricity == 0.0) {
          canvas.drawCircle(
              rect.center,
              (rect.shortestSide + side.strokeOffset) / 2,
              side.toGradientPaint(rect));
        } else {
          final Rect borderRect = _adjustRect(rect);
          canvas.drawOval(borderRect.inflate(side.strokeOffset / 2),
              side.toGradientPaint(rect));
        }
    }
  }

  Rect _adjustRect(Rect rect) {
    if (eccentricity == 0.0 || rect.width == rect.height) {
      return Rect.fromCircle(
          center: rect.center, radius: rect.shortestSide / 2.0);
    }
    if (rect.width < rect.height) {
      final double delta =
          (1.0 - eccentricity) * (rect.height - rect.width) / 2.0;
      return Rect.fromLTRB(
        rect.left,
        rect.top + delta,
        rect.right,
        rect.bottom - delta,
      );
    } else {
      final double delta =
          (1.0 - eccentricity) * (rect.width - rect.height) / 2.0;
      return Rect.fromLTRB(
        rect.left + delta,
        rect.top,
        rect.right - delta,
        rect.bottom,
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GradientCircleBorder &&
        other.side == side &&
        other.eccentricity == eccentricity;
  }

  @override
  int get hashCode => Object.hash(side, eccentricity);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return '${objectRuntimeType(this, 'GradientCircleBorder')}($side, eccentricity: $eccentricity)';
    }
    return '${objectRuntimeType(this, 'GradientCircleBorder')}($side)';
  }
}
