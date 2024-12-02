import 'dart:ui' as ui show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'gradient_border_side.dart';

extension GradientStadiumBorderExt on StadiumBorder {
  GradientStadiumBorder toGradient(Gradient? gradient) =>
      GradientStadiumBorder.fromBorder(border: this, gradient: gradient);
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
class GradientStadiumBorder extends StadiumBorder {
  /// Create a stadium border.
  ///
  /// The [side] argument must not be null.
  const GradientStadiumBorder({
    GradientBorderSide side = GradientBorderSide.none,
  }) : super(side: side);

  factory GradientStadiumBorder.fromBorder({
    required StadiumBorder border,
    Gradient? gradient,
  }) =>
      GradientStadiumBorder(side: border.side.toGradient(gradient));

  StadiumBorder dropGradient() => StadiumBorder(side: side);

  @override
  ShapeBorder scale(double t) =>
      GradientStadiumBorder(side: side.toGradient().scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is StadiumBorder) {
      return GradientStadiumBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
      );
    }
    if (a is CircleBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        circularity: 1.0 - t,
        eccentricity: a.eccentricity,
      );
    }
    if (a is RoundedRectangleBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius: a.borderRadius,
        rectilinearity: 1.0 - t,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientStadiumBorder) {
      return GradientStadiumBorder(
          side: GradientBorderSide.lerp(
              side.toGradient(), b.side.toGradient(), t));
    }
    if (b is CircleBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        circularity: t,
        eccentricity: b.eccentricity,
      );
    }
    if (b is RoundedRectangleBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius: b.borderRadius,
        rectilinearity: t,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  GradientStadiumBorder copyWith({
    BorderSide? side,
    Gradient? gradient,
  }) {
    return GradientStadiumBorder(
      side: (side ?? this.side).toGradient(),
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
        final Radius radius = Radius.circular(rect.shortestSide / 2);
        final RRect borderRect = RRect.fromRectAndRadius(rect, radius);
        final Paint paint = side.toGradientPaint(rect);
        canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2), paint);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GradientStadiumBorder && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CStadiumBorder')}($side)';
  }
}

// Class to help with transitioning to/from a CircleBorder.
class _GradientStadiumToCircleBorder extends OutlinedBorder {
  const _GradientStadiumToCircleBorder({
    GradientBorderSide side = GradientBorderSide.none,
    this.circularity = 0.0,
    required this.eccentricity,
  }) : super(side: side);

  final double circularity;
  final double eccentricity;

  @override
  ShapeBorder scale(double t) {
    return _GradientStadiumToCircleBorder(
      side: side.toGradient().scale(t),
      circularity: t,
      eccentricity: eccentricity,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is StadiumBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        circularity: circularity * t,
        eccentricity: eccentricity,
      );
    }
    if (a is CircleBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        circularity: circularity + (1.0 - circularity) * (1.0 - t),
        eccentricity: a.eccentricity,
      );
    }
    if (a is _GradientStadiumToCircleBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        circularity: ui.lerpDouble(a.circularity, circularity, t)!,
        eccentricity: ui.lerpDouble(a.eccentricity, eccentricity, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is StadiumBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        circularity: circularity * (1.0 - t),
        eccentricity: eccentricity,
      );
    }
    if (b is CircleBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        circularity: circularity + (1.0 - circularity) * t,
        eccentricity: b.eccentricity,
      );
    }
    if (b is _GradientStadiumToCircleBorder) {
      return _GradientStadiumToCircleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        circularity: ui.lerpDouble(circularity, b.circularity, t)!,
        eccentricity: ui.lerpDouble(eccentricity, b.eccentricity, t)!,
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
  _GradientStadiumToCircleBorder copyWith({
    BorderSide? side,
    double? circularity,
    double? eccentricity,
  }) {
    return _GradientStadiumToCircleBorder(
      side: (side ?? this.side).toGradient(),
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
        final RRect borderRect =
            _adjustBorderRadius(rect).toRRect(_adjustRect(rect));
        canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2),
            side.toGradientPaint(rect));
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _GradientStadiumToCircleBorder &&
        other.side == side &&
        other.circularity == circularity;
  }

  @override
  int get hashCode => Object.hash(side, circularity);

  @override
  String toString() {
    if (eccentricity != 0.0) {
      return 'CStadiumBorder($side, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder that is ${(eccentricity * 100).toStringAsFixed(1)}% oval)';
    }
    return 'CStadiumBorder($side, ${(circularity * 100).toStringAsFixed(1)}% of the way to being a CircleBorder)';
  }
}

// Class to help with transitioning to/from a RoundedRectBorder.
class _GradientStadiumToRoundedRectangleBorder extends OutlinedBorder {
  const _GradientStadiumToRoundedRectangleBorder({
    GradientBorderSide side = GradientBorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.rectilinearity = 0.0,
  }) : super(side: side);

  final BorderRadiusGeometry borderRadius;
  final double rectilinearity;

  @override
  ShapeBorder scale(double t) {
    return _GradientStadiumToRoundedRectangleBorder(
      side: side.toGradient().scale(t),
      borderRadius: borderRadius * t,
      rectilinearity: t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is StadiumBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity * t,
      );
    }
    if (a is RoundedRectangleBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity + (1.0 - rectilinearity) * (1.0 - t),
      );
    }
    if (a is _GradientStadiumToRoundedRectangleBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(a.side.toGradient(), side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        rectilinearity: ui.lerpDouble(a.rectilinearity, rectilinearity, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is StadiumBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity * (1.0 - t),
      );
    }
    if (b is RoundedRectangleBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius: borderRadius,
        rectilinearity: rectilinearity + (1.0 - rectilinearity) * t,
      );
    }
    if (b is _GradientStadiumToRoundedRectangleBorder) {
      return _GradientStadiumToRoundedRectangleBorder(
        side:
            GradientBorderSide.lerp(side.toGradient(), b.side.toGradient(), t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        rectilinearity: ui.lerpDouble(rectilinearity, b.rectilinearity, t)!,
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
  _GradientStadiumToRoundedRectangleBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
    double? rectilinearity,
  }) {
    return _GradientStadiumToRoundedRectangleBorder(
      side: (side ?? this.side).toGradient(),
      borderRadius: borderRadius ?? this.borderRadius,
      rectilinearity: rectilinearity ?? this.rectilinearity,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final side = this.side.toGradient();
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final BorderRadiusGeometry adjustedBorderRadius =
            _adjustBorderRadius(rect);
        final RRect borderRect =
            adjustedBorderRadius.resolve(textDirection).toRRect(rect);
        canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2),
            side.toGradientPaint(rect));
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _GradientStadiumToRoundedRectangleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.rectilinearity == rectilinearity;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, rectilinearity);

  @override
  String toString() {
    return 'CStadiumBorder($side, $borderRadius, '
        '${(rectilinearity * 100).toStringAsFixed(1)}% of the way to being a '
        'RoundedRectangleBorder)';
  }
}
