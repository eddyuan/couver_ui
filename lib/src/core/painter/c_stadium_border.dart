import 'dart:ui' as ui show lerpDouble;

import 'package:couver_ui/couver_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension GradientStadiumBorder on StadiumBorder {
  CStadiumBorder toGradient(Gradient? gradient) =>
      CStadiumBorder.fromBorder(border: this, gradient: gradient);
}

/// A border that fits a stadium-shaped border (a box with semicircles on the ends)
/// within the rectangle of the widget it is applied to.
///
/// Typically used with [ShapeDecoration] to draw a stadium border.
///
/// If the rectangle is taller than it is wide, then the semicircles will be on the
/// top and bottom, and on the left and right otherwise.
///
/// See also:
///
///  * [BorderSide], which is used to describe the border of the stadium.
class CStadiumBorder extends StadiumBorder {
  /// Create a stadium border.
  ///
  /// The [side] argument must not be null.
  const CStadiumBorder({
    super.side,
    this.gradient,
  });

  final Gradient? gradient;

  factory CStadiumBorder.fromBorder({
    required StadiumBorder border,
    Gradient? gradient,
  }) =>
      CStadiumBorder(side: border.side, gradient: gradient);

  StadiumBorder dropGradient() => StadiumBorder(side: side);

  @override
  ShapeBorder scale(double t) =>
      CStadiumBorder(side: side.scale(t), gradient: gradient);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is StadiumBorder) {
      return CStadiumBorder(
        side: BorderSide.lerp(a.side, side, t),
        gradient: a is CStadiumBorder
            ? Gradient.lerp(a.gradient, gradient, t)
            : gradient,
      );
    }
    if (a is CircleBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        circularity: 1.0 - t,
        eccentricity: a.eccentricity,
      );
    }
    if (a is RoundedRectangleBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: a.borderRadius,
        rectilinearity: 1.0 - t,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CStadiumBorder) {
      return CStadiumBorder(side: BorderSide.lerp(side, b.side, t));
    }
    if (b is CircleBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        circularity: t,
        eccentricity: b.eccentricity,
      );
    }
    if (b is RoundedRectangleBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: b.borderRadius,
        rectilinearity: t,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  CStadiumBorder copyWith({
    BorderSide? side,
    Gradient? gradient,
  }) {
    return CStadiumBorder(
      side: side ?? this.side,
      gradient: gradient ?? this.gradient,
    );
  }

  // @override
  // Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
  //   final Radius radius = Radius.circular(rect.shortestSide / 2.0);
  //   final RRect borderRect = RRect.fromRectAndRadius(rect, radius);
  //   final RRect adjustedRect = borderRect.deflate(side.strokeInset);
  //   return Path()..addRRect(adjustedRect);
  // }

  // @override
  // Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
  //   final Radius radius = Radius.circular(rect.shortestSide / 2.0);
  //   return Path()..addRRect(RRect.fromRectAndRadius(rect, radius));
  // }

  // @override
  // void paintInterior(Canvas canvas, Rect rect, Paint paint,
  //     {TextDirection? textDirection}) {
  //   final Radius radius = Radius.circular(rect.shortestSide / 2.0);
  //   canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
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
          final Radius radius = Radius.circular(rect.shortestSide / 2);
          final RRect borderRect = RRect.fromRectAndRadius(rect, radius);
          final Paint paint = side.toPaint()
            ..shader = gradient?.createShader(rect);

          canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2), paint);
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CStadiumBorder &&
        other.side == side &&
        other.gradient == gradient;
  }

  @override
  int get hashCode => Object.hash(side, gradient);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CStadiumBorder')}($side)';
  }
}

// Class to help with transitioning to/from a CircleBorder.
class _CStadiumToCircleBorder extends OutlinedBorder {
  const _CStadiumToCircleBorder({
    super.side,
    this.circularity = 0.0,
    required this.eccentricity,
    this.gradient,
  });

  final Gradient? gradient;
  final double circularity;
  final double eccentricity;

  @override
  ShapeBorder scale(double t) {
    return _CStadiumToCircleBorder(
      side: side.scale(t),
      circularity: t,
      eccentricity: eccentricity,
      gradient: gradient,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is StadiumBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        circularity: circularity * t,
        eccentricity: eccentricity,
        gradient: a is CStadiumBorder
            ? Gradient.lerp(a.gradient, gradient, t)
            : gradient,
      );
    }
    if (a is CircleBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        circularity: circularity + (1.0 - circularity) * (1.0 - t),
        eccentricity: a.eccentricity,
        gradient: a is CCircleBorder
            ? Gradient.lerp(a.gradient, gradient, t)
            : gradient,
      );
    }
    if (a is _CStadiumToCircleBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        circularity: ui.lerpDouble(a.circularity, circularity, t)!,
        eccentricity: ui.lerpDouble(a.eccentricity, eccentricity, t)!,
        gradient: Gradient.lerp(a.gradient, gradient, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is StadiumBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        circularity: circularity * (1.0 - t),
        eccentricity: eccentricity,
        gradient: b is CStadiumBorder
            ? Gradient.lerp(gradient, b.gradient, t)
            : gradient,
      );
    }
    if (b is CircleBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        circularity: circularity + (1.0 - circularity) * t,
        eccentricity: b.eccentricity,
        gradient: b is CCircleBorder
            ? Gradient.lerp(gradient, b.gradient, t)
            : gradient,
      );
    }
    if (b is _CStadiumToCircleBorder) {
      return _CStadiumToCircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        circularity: ui.lerpDouble(circularity, b.circularity, t)!,
        eccentricity: ui.lerpDouble(eccentricity, b.eccentricity, t)!,
        gradient: Gradient.lerp(gradient, b.gradient, t),
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

  BorderRadius _adjustBorderRadius(Rect rect) {
    final BorderRadius circleRadius =
        BorderRadius.circular(rect.shortestSide / 2);
    if (eccentricity != 0.0) {
      if (rect.width < rect.height) {
        return BorderRadius.lerp(
          circleRadius,
          BorderRadius.all(Radius.elliptical(
              rect.width / 2, (0.5 + eccentricity / 2) * rect.height / 2)),
          circularity,
        )!;
      } else {
        return BorderRadius.lerp(
          circleRadius,
          BorderRadius.all(Radius.elliptical(
              (0.5 + eccentricity / 2) * rect.width / 2, rect.height / 2)),
          circularity,
        )!;
      }
    }
    return circleRadius;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(_adjustBorderRadius(rect)
          .toRRect(_adjustRect(rect))
          .deflate(side.strokeInset));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(_adjustBorderRadius(rect).toRRect(_adjustRect(rect)));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    canvas.drawRRect(
        _adjustBorderRadius(rect).toRRect(_adjustRect(rect)), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  _CStadiumToCircleBorder copyWith({
    BorderSide? side,
    double? circularity,
    double? eccentricity,
    Gradient? gradient,
  }) {
    return _CStadiumToCircleBorder(
      side: side ?? this.side,
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
        final RRect borderRect =
            _adjustBorderRadius(rect).toRRect(_adjustRect(rect));
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
    return other is _CStadiumToCircleBorder &&
        other.side == side &&
        other.circularity == circularity &&
        other.gradient == gradient;
  }

  @override
  int get hashCode => Object.hash(side, circularity, gradient);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return 'CStadiumBorder($side, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder that is ${(eccentricity * 100).toStringAsFixed(1)}% oval)';
    }
    return 'CStadiumBorder($side, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder)';
  }
}

// Class to help with transitioning to/from a RoundedRectBorder.
class _StadiumToRoundedRectangleBorder extends OutlinedBorder {
  const _StadiumToRoundedRectangleBorder({
    super.side,
    this.borderRadius = BorderRadius.zero,
    this.rectilinearity = 0.0,
    this.gradient,
  });

  final BorderRadiusGeometry borderRadius;
  final double rectilinearity;
  final Gradient? gradient;

  @override
  ShapeBorder scale(double t) {
    return _StadiumToRoundedRectangleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      rectilinearity: t,
      gradient: gradient,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is StadiumBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity * t,
        gradient: a is CStadiumBorder
            ? Gradient.lerp(a.gradient, gradient, t)
            : gradient,
      );
    }
    if (a is RoundedRectangleBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity + (1.0 - rectilinearity) * (1.0 - t),
        gradient: a is CRoundedRectangleBorder
            ? Gradient.lerp(a.gradient, gradient, t)
            : gradient,
      );
    }
    if (a is _StadiumToRoundedRectangleBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        rectilinearity: ui.lerpDouble(a.rectilinearity, rectilinearity, t)!,
        gradient: Gradient.lerp(a.gradient, gradient, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is StadiumBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity * (1.0 - t),
        gradient: b is CStadiumBorder
            ? Gradient.lerp(gradient, b.gradient, t)
            : gradient,
      );
    }
    if (b is RoundedRectangleBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity + (1.0 - rectilinearity) * t,
        gradient: b is CRoundedRectangleBorder
            ? Gradient.lerp(gradient, b.gradient, t)
            : gradient,
      );
    }
    if (b is _StadiumToRoundedRectangleBorder) {
      return _StadiumToRoundedRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        rectilinearity: ui.lerpDouble(rectilinearity, b.rectilinearity, t)!,
        gradient: Gradient.lerp(gradient, b.gradient, t),
      );
    }
    return super.lerpTo(b, t);
  }

  BorderRadiusGeometry _adjustBorderRadius(Rect rect) {
    return BorderRadiusGeometry.lerp(
      borderRadius,
      BorderRadius.all(Radius.circular(rect.shortestSide / 2.0)),
      1.0 - rectilinearity,
    )!;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect borderRect =
        _adjustBorderRadius(rect).resolve(textDirection).toRRect(rect);
    final RRect adjustedRect =
        borderRect.deflate(ui.lerpDouble(side.width, 0, side.strokeAlign)!);
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
          _adjustBorderRadius(rect).resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    final BorderRadiusGeometry adjustedBorderRadius = _adjustBorderRadius(rect);
    if (adjustedBorderRadius == BorderRadius.zero) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRRect(
          adjustedBorderRadius.resolve(textDirection).toRRect(rect), paint);
    }
  }

  @override
  bool get preferPaintInterior => true;

  @override
  _StadiumToRoundedRectangleBorder copyWith(
      {BorderSide? side,
      BorderRadiusGeometry? borderRadius,
      double? rectilinearity}) {
    return _StadiumToRoundedRectangleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      rectilinearity: rectilinearity ?? this.rectilinearity,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final BorderRadiusGeometry adjustedBorderRadius =
            _adjustBorderRadius(rect);
        final RRect borderRect =
            adjustedBorderRadius.resolve(textDirection).toRRect(rect);
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
    return other is _StadiumToRoundedRectangleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.rectilinearity == rectilinearity &&
        other.gradient == gradient;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, rectilinearity, gradient);

  @override
  String toString() {
    return 'CStadiumBorder($side, $borderRadius, '
        '${(rectilinearity * 100).toStringAsFixed(1)}% of the way to being a '
        'RoundedRectangleBorder)';
  }
}
