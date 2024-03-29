// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'dart:math' as math;

// import 'dart:ui' show lerpDouble;
import "package:flutter/material.dart";

class COutlineInputBorder extends InputBorder {
  /// Creates a rounded rectangle outline border for an [InputDecorator].
  ///
  /// If the [borderSide] parameter is [BorderSide.none], it will not draw a
  /// border. However, it will still define a shape (which you can see if
  /// [InputDecoration.filled] is true).
  ///
  /// If an application does not specify a [borderSide] parameter of
  /// value [BorderSide.none], the input decorator substitutes its own, using
  /// [copyWith], based on the current theme and [InputDecorator.isFocused].
  ///
  /// The [borderRadius] parameter defaults to a value where all four
  /// corners have a circular radius of 4.0. The [borderRadius] parameter
  /// must not be null and the corner radii must be circular, i.e. their
  /// [Radius.x] and [Radius.y] values must be the same.
  ///
  /// See also:
  ///
  ///  * [InputDecoration.floatingLabelBehavior], which should be set to
  ///    [FloatingLabelBehavior.never] when the [borderSide] is
  ///    [BorderSide.none]. If let as [FloatingLabelBehavior.auto], the label
  ///    will extend beyond the container as if the border were still being
  ///    drawn.
  const COutlineInputBorder({
    super.borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.gapPadding = 4.0,
  })  : assert(gapPadding >= 0.0);

  // The label text's gap can extend into the corners (even both the top left
  // and the top right corner). To avoid the more complicated problem of finding
  // how far the gap penetrates into an elliptical corner, just require them
  // to be circular.
  //
  // This can't be checked by the constructor because const constructor.
  static bool _cornersAreCircular(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topLeft.y &&
        borderRadius.bottomLeft.x == borderRadius.bottomLeft.y &&
        borderRadius.topRight.x == borderRadius.topRight.y &&
        borderRadius.bottomRight.x == borderRadius.bottomRight.y;
  }

  /// Horizontal padding on either side of the border's
  /// [InputDecoration.labelText] width gap.
  ///
  /// This value is used by the [paint] method to compute the actual gap width.
  final double gapPadding;

  /// The radii of the border's rounded rectangle corners.
  ///
  /// The corner radii must be circular, i.e. their [Radius.x] and [Radius.y]
  /// values must be the same.
  final BorderRadius borderRadius;

  @override
  bool get isOutline => false;

  @override
  COutlineInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) {
    return COutlineInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  COutlineInputBorder scale(double t) {
    return COutlineInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
      gapPadding: gapPadding * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is COutlineInputBorder) {
      final COutlineInputBorder outline = a;
      return COutlineInputBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is COutlineInputBorder) {
      final COutlineInputBorder outline = b;
      return COutlineInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  // Path _gapBorderPath(
  //     Canvas canvas, RRect center, double start, double extent) {
  //   // When the corner radii on any side add up to be greater than the
  //   // given height, each radius has to be scaled to not exceed the
  //   // size of the width/height of the RRect.
  //   final RRect scaledRRect = center.scaleRadii();

  //   final Rect tlCorner = Rect.fromLTWH(
  //     scaledRRect.left,
  //     scaledRRect.top,
  //     scaledRRect.tlRadiusX * 2.0,
  //     scaledRRect.tlRadiusY * 2.0,
  //   );
  //   final Rect trCorner = Rect.fromLTWH(
  //     scaledRRect.right - scaledRRect.trRadiusX * 2.0,
  //     scaledRRect.top,
  //     scaledRRect.trRadiusX * 2.0,
  //     scaledRRect.trRadiusY * 2.0,
  //   );
  //   final Rect brCorner = Rect.fromLTWH(
  //     scaledRRect.right - scaledRRect.brRadiusX * 2.0,
  //     scaledRRect.bottom - scaledRRect.brRadiusY * 2.0,
  //     scaledRRect.brRadiusX * 2.0,
  //     scaledRRect.brRadiusY * 2.0,
  //   );
  //   final Rect blCorner = Rect.fromLTWH(
  //     scaledRRect.left,
  //     scaledRRect.bottom - scaledRRect.blRadiusY * 2.0,
  //     scaledRRect.blRadiusX * 2.0,
  //     scaledRRect.blRadiusX * 2.0,
  //   );

  //   // This assumes that the radius is circular (x and y radius are equal).
  //   // Currently, BorderRadius only supports circular radii.
  //   const double cornerArcSweep = math.pi / 2.0;
  //   final double tlCornerArcSweep = math.acos(
  //     (1 - start / scaledRRect.tlRadiusX).clamp(0.0, 1.0),
  //   );

  //   final Path path = Path()..addArc(tlCorner, math.pi, tlCornerArcSweep);

  //   if (start > scaledRRect.tlRadiusX)
  //     path.lineTo(scaledRRect.left + start, scaledRRect.top);

  //   const double trCornerArcStart = (3 * math.pi) / 2.0;
  //   const double trCornerArcSweep = cornerArcSweep;
  //   if (start + extent < scaledRRect.width - scaledRRect.trRadiusX) {
  //     path.moveTo(scaledRRect.left + start + extent, scaledRRect.top);
  //     path.lineTo(scaledRRect.right - scaledRRect.trRadiusX, scaledRRect.top);
  //     path.addArc(trCorner, trCornerArcStart, trCornerArcSweep);
  //   } else if (start + extent < scaledRRect.width) {
  //     final double dx = scaledRRect.width - (start + extent);
  //     final double sweep = math.asin(
  //       (1 - dx / scaledRRect.trRadiusX).clamp(0.0, 1.0),
  //     );
  //     path.addArc(trCorner, trCornerArcStart + sweep, trCornerArcSweep - sweep);
  //   }

  //   return path
  //     ..moveTo(scaledRRect.right, scaledRRect.top + scaledRRect.trRadiusY)
  //     ..lineTo(scaledRRect.right, scaledRRect.bottom - scaledRRect.brRadiusY)
  //     ..addArc(brCorner, 0.0, cornerArcSweep)
  //     ..lineTo(scaledRRect.left + scaledRRect.blRadiusX, scaledRRect.bottom)
  //     ..addArc(blCorner, math.pi / 2.0, cornerArcSweep)
  //     ..lineTo(scaledRRect.left, scaledRRect.top + scaledRRect.tlRadiusY);
  // }

  /// Draw a rounded rectangle around [rect] using [borderRadius].
  ///
  /// The [borderSide] defines the line's color and weight.
  ///
  /// The top side of the rounded rectangle may be interrupted by a single gap
  /// if [gapExtent] is non-null. In that case the gap begins at
  /// `gapStart - gapPadding` (assuming that the [textDirection] is [TextDirection.ltr]).
  /// The gap's width is `(gapPadding + gapExtent + gapPadding) * gapPercentage`.
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    // assert(gapExtent != null);
    // assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);
    assert(_cornersAreCircular(borderRadius));

    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);
    canvas.drawRRect(center, paint);
    // if (gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
    //   canvas.drawRRect(center, paint);
    // } else {
    //   final double extent =
    //       lerpDouble(0.0, gapExtent + gapPadding * 2.0, gapPercentage)!;
    //   switch (textDirection!) {
    //     case TextDirection.rtl:
    //       final Path path = _gapBorderPath(canvas, center,
    //           math.max(0.0, gapStart + gapPadding - extent), extent);
    //       canvas.drawPath(path, paint);
    //       break;

    //     case TextDirection.ltr:
    //       final Path path = _gapBorderPath(
    //           canvas, center, math.max(0.0, gapStart - gapPadding), extent);
    //       canvas.drawPath(path, paint);
    //       break;
    //   }
    // }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is COutlineInputBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius &&
        other.gapPadding == gapPadding;
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius, gapPadding);
}
