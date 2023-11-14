import 'dart:ui' as ui show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'c_circle_border.dart';

extension GradientRoundedRectangleBorder on RoundedRectangleBorder {
  CRoundedRectangleBorder toGradient(Gradient? gradient) =>
      CRoundedRectangleBorder.fromBorder(border: this, gradient: gradient);
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
class CRoundedRectangleBorder extends RoundedRectangleBorder {
  /// Creates a rounded rectangle border.
  ///
  /// The arguments must not be null.
  const CRoundedRectangleBorder({
    super.side,
    super.borderRadius = BorderRadius.zero,
    this.gradient,
  });

  final Gradient? gradient;

  factory CRoundedRectangleBorder.fromBorder({
    required RoundedRectangleBorder border,
    Gradient? gradient,
  }) =>
      CRoundedRectangleBorder(
        side: border.side,
        borderRadius: border.borderRadius,
        gradient: gradient,
      );

  RoundedRectangleBorder dropGradient() =>
      RoundedRectangleBorder(borderRadius: borderRadius, side: side);

  /// The radii for each corner.
  // final BorderRadiusGeometry borderRadius;

  @override
  ShapeBorder scale(double t) {
    return CRoundedRectangleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      gradient: gradient,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is RoundedRectangleBorder) {
      return CRoundedRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        gradient: a is CRoundedRectangleBorder
            ? Gradient.lerp(a.gradient, gradient, t)
            : gradient,
      );
    }
    if (a is CircleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: borderRadius,
        circularity: 1.0 - t,
        eccentricity: a.eccentricity,
        gradient: a is CCircleBorder
            ? Gradient.lerp(a.gradient, gradient, t)
            : gradient,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is RoundedRectangleBorder) {
      return CRoundedRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        gradient: b is CRoundedRectangleBorder
            ? Gradient.lerp(gradient, b.gradient, t)
            : gradient,
      );
    }
    if (b is CircleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: borderRadius,
        circularity: t,
        eccentricity: b.eccentricity,
        gradient: b is CCircleBorder
            ? Gradient.lerp(gradient, b.gradient, t)
            : gradient,
      );
    }
    return super.lerpTo(b, t);
  }

  /// Returns a copy of this CRoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  CRoundedRectangleBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
    Gradient? gradient,
  }) {
    return CRoundedRectangleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      gradient: gradient ?? this.gradient,
    );
  }

  // @override
  // Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
  //   final RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);
  //   final RRect adjustedRect = borderRect.deflate(side.strokeInset);
  //   return Path()..addRRect(adjustedRect);
  // }

  // @override
  // Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
  //   return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  // }

  // @override
  // void paintInterior(
  //   Canvas canvas,
  //   Rect rect,
  //   Paint paint, {
  //   TextDirection? textDirection,
  // }) {
  //   final Paint gPaint = Paint()
  //     ..shader =
  //         LinearGradient(colors: [Colors.red, Colors.black]).createShader(rect);
  //   canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), gPaint);
  //   if (borderRadius == BorderRadius.zero) {
  //     canvas.drawRect(rect, paint);
  //   } else {
  //     canvas.drawRRect(
  //         borderRadius.resolve(textDirection).toRRect(rect), paint);
  //   }
  // }

  // @override
  // bool get preferPaintInterior => true;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (gradient == null) {
      super.paint(canvas, rect, textDirection: textDirection);
    } else {
      switch (side.style) {
        case BorderStyle.none:
          break;
        case BorderStyle.solid:
          if (side.width == 0.0) {
            canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect),
                side.toPaint());
          } else {
            final Paint paint = Paint()..shader = gradient?.createShader(rect);
            final RRect borderRect =
                borderRadius.resolve(textDirection).toRRect(rect);
            final RRect inner = borderRect.deflate(side.strokeInset);
            final RRect outer = borderRect.inflate(side.strokeOutset);
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
    return other is CRoundedRectangleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.gradient == gradient;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, gradient);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CRoundedRectangleBorder')}($side, $borderRadius)';
  }
}

class _CRoundedRectangleToCircleBorder extends OutlinedBorder {
  const _CRoundedRectangleToCircleBorder({
    super.side,
    this.borderRadius = BorderRadius.zero,
    required this.circularity,
    required this.eccentricity,
    this.gradient,
  });

  final Gradient? gradient;
  final BorderRadiusGeometry borderRadius;
  final double circularity;
  final double eccentricity;

  @override
  ShapeBorder scale(double t) {
    return _CRoundedRectangleToCircleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      circularity: t,
      eccentricity: eccentricity,
      gradient: gradient,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CRoundedRectangleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        circularity: circularity * t,
        eccentricity: eccentricity,
        gradient: gradient,
      );
    }
    if (a is CircleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: borderRadius,
        circularity: circularity + (1.0 - circularity) * (1.0 - t),
        eccentricity: a.eccentricity,
        gradient: gradient,
      );
    }
    if (a is _CRoundedRectangleToCircleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        circularity: ui.lerpDouble(a.circularity, circularity, t)!,
        eccentricity: eccentricity,
        gradient: gradient,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CRoundedRectangleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        circularity: circularity * (1.0 - t),
        eccentricity: eccentricity,
        gradient: gradient,
      );
    }
    if (b is CircleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: borderRadius,
        circularity: circularity + (1.0 - circularity) * t,
        eccentricity: b.eccentricity,
        gradient: gradient,
      );
    }
    if (b is _CRoundedRectangleToCircleBorder) {
      return _CRoundedRectangleToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        circularity: ui.lerpDouble(circularity, b.circularity, t)!,
        eccentricity: eccentricity,
        gradient: gradient,
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
  _CRoundedRectangleToCircleBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
    double? circularity,
    double? eccentricity,
    Gradient? gradient,
  }) {
    return _CRoundedRectangleToCircleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      circularity: circularity ?? this.circularity,
      eccentricity: eccentricity ?? this.eccentricity,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final BorderRadius adjustedBorderRadius =
            _adjustBorderRadius(rect, textDirection)!;
        final RRect borderRect =
            adjustedBorderRadius.toRRect(_adjustRect(rect));
        final Paint paint = side.toPaint();
        if (gradient != null) {
          paint.shader = gradient?.createShader(rect);
        }
        canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2), paint);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _CRoundedRectangleToCircleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.circularity == circularity &&
        other.gradient == gradient;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, circularity, gradient);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return 'CRoundedRectangleBorder($side, $borderRadius, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder that is ${(eccentricity * 100).toStringAsFixed(1)}% oval)';
    }
    return 'CRoundedRectangleBorder($side, $borderRadius, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder)';
  }
}
