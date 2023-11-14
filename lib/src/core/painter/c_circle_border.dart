import 'dart:ui' as ui show lerpDouble, clampDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension GradientCircleBorder on CircleBorder {
  CCircleBorder toGradient(Gradient? gradient) =>
      CCircleBorder.fromBorder(border: this, gradient: gradient);
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

class CCircleBorder extends CircleBorder {
  /// Create a circle border.
  ///
  /// The [side] argument must not be null.
  const CCircleBorder({
    super.side,
    super.eccentricity = 0.0,
    this.gradient,
  })  : assert(eccentricity >= 0.0,
            'The eccentricity argument $eccentricity is not greater than or equal to zero.'),
        assert(eccentricity <= 1.0,
            'The eccentricity argument $eccentricity is not less than or equal to one.');

  final Gradient? gradient;

  CircleBorder dropGradient() =>
      CircleBorder(side: side, eccentricity: eccentricity);

  factory CCircleBorder.fromBorder({
    required CircleBorder border,
    Gradient? gradient,
  }) =>
      CCircleBorder(
        side: border.side,
        eccentricity: border.eccentricity,
        gradient: gradient,
      );

  @override
  ShapeBorder scale(double t) => CCircleBorder(
        side: side.scale(t),
        eccentricity: eccentricity,
        gradient: gradient,
      );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CCircleBorder) {
      return CCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        eccentricity: ui.clampDouble(
            ui.lerpDouble(a.eccentricity, eccentricity, t)!, 0.0, 1.0),
        gradient: Gradient.lerp(a.gradient, gradient, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CCircleBorder) {
      return CCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        eccentricity: ui.clampDouble(
            ui.lerpDouble(eccentricity, b.eccentricity, t)!, 0.0, 1.0),
        gradient: Gradient.lerp(gradient, b.gradient, t),
      );
    }
    return super.lerpTo(b, t);
  }

  // @override
  // Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
  //   return Path()..addOval(_adjustRect(rect).deflate(side.strokeInset));
  // }

  // @override
  // Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
  //   return Path()..addOval(_adjustRect(rect));
  // }

  // @override
  // void paintInterior(Canvas canvas, Rect rect, Paint paint,
  //     {TextDirection? textDirection}) {
  //   if (eccentricity == 0.0) {
  //     canvas.drawCircle(rect.center, rect.shortestSide / 2.0, paint);
  //   } else {
  //     canvas.drawOval(_adjustRect(rect), paint);
  //   }
  // }

  // @override
  // bool get preferPaintInterior => true;

  @override
  CCircleBorder copyWith({
    BorderSide? side,
    double? eccentricity,
    Gradient? gradient,
  }) {
    return CCircleBorder(
      side: side ?? this.side,
      eccentricity: eccentricity ?? this.eccentricity,
      gradient: gradient,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (gradient == null) {
      super.paint(canvas, rect, textDirection: textDirection);
    } else {
      switch (side.style) {
        case BorderStyle.none:
          break;
        case BorderStyle.solid:
          final paint = side.toPaint()..shader = gradient?.createShader(rect);
          if (eccentricity == 0.0) {
            canvas.drawCircle(
              rect.center,
              (rect.shortestSide + side.strokeOffset) / 2,
              paint,
            );
          } else {
            final Rect borderRect = _adjustRect(rect);
            canvas.drawOval(
              borderRect.inflate(side.strokeOffset / 2),
              paint,
            );
          }
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
    return other is CCircleBorder &&
        other.side == side &&
        other.eccentricity == eccentricity &&
        gradient == gradient;
  }

  @override
  int get hashCode => Object.hash(side, eccentricity, gradient);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return '${objectRuntimeType(this, 'CCircleBorder')}($side, eccentricity: $eccentricity)';
    }
    return '${objectRuntimeType(this, 'CCircleBorder')}($side)';
  }
}
