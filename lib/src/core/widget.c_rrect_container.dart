// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;

import 'package:flutter/material.dart';

enum CRRectCornerType {
  invert,
  extrude,
  normal,
  ;

  bool get isExtrude => this == extrude;
  bool get isInvert => this == invert;
}

class CRRectRadius extends Radius {
  final CRRectCornerType type;

  const CRRectRadius.circular(super.radius)
      : type = CRRectCornerType.normal,
        super.circular();

  const CRRectRadius.none()
      : type = CRRectCornerType.normal,
        super.circular(0);

  const CRRectRadius.invert(super.radius)
      : type = CRRectCornerType.invert,
        super.circular();

  const CRRectRadius.extrude(super.radius)
      : type = CRRectCornerType.extrude,
        super.circular();

  const CRRectRadius.elliptical(super.x, super.y,
      {this.type = CRRectCornerType.normal})
      : super.elliptical();
}

class CRRectCorners {
  final CRRectRadius topLeft;
  final CRRectRadius topRight;
  final CRRectRadius bottomLeft;
  final CRRectRadius bottomRight;
  const CRRectCorners(
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  );
  const CRRectCorners.all(CRRectRadius cornerType)
      : topLeft = cornerType,
        topRight = cornerType,
        bottomLeft = cornerType,
        bottomRight = cornerType;

  const CRRectCorners.only({
    CRRectRadius? topLeft,
    CRRectRadius? topRight,
    CRRectRadius? bottomLeft,
    CRRectRadius? bottomRight,
  })  : topLeft = topLeft ?? const CRRectRadius.none(),
        topRight = topRight ?? const CRRectRadius.none(),
        bottomLeft = bottomLeft ?? const CRRectRadius.none(),
        bottomRight = bottomRight ?? const CRRectRadius.none();

  static const CRRectCorners none = CRRectCorners.only();
}

class CRRectContainer extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final EdgeInsets padding;

  /// The radius of the Tip
  // final BorderRadiusGeometry borderRadius;

  final Widget? child;
  // final bool vertical;
  final bool automaticAddPadding;
  final CRRectCorners corners;

  const CRRectContainer({
    super.key,
    this.color,
    this.gradient,
    this.padding = EdgeInsets.zero,
    // this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.child,
    this.corners = CRRectCorners.none,
    // this.vertical = false,
    this.automaticAddPadding = true,
  });

  EdgeInsets _extraPadding(BuildContext context) {
    // final radius = borderRadius.resolve(Directionality.of(context));
    // if (vertical) {
    //   double top = 0;
    //   if (corners.topLeft.type.isExtrude) {
    //     top = math.max(top, corners.topLeft.y);
    //   }
    //   if (corners.bottomRight.type.isExtrude) {
    //     top = math.max(top, corners.topRight.y);
    //   }
    //   double bottom = 0;
    //   if (corners.bottomLeft.type.isExtrude) {
    //     bottom = math.max(bottom, corners.bottomLeft.y);
    //   }
    //   if (corners.bottomRight.type.isExtrude) {
    //     bottom = math.max(bottom, corners.bottomRight.y);
    //   }
    //   return EdgeInsets.only(
    //     top: top,
    //     bottom: bottom,
    //   );
    // }
    double left = 0;
    if (corners.topLeft.type.isExtrude) {
      left = math.max(left, corners.topLeft.x);
    }
    if (corners.bottomLeft.type.isExtrude) {
      left = math.max(left, corners.bottomLeft.x);
    }
    double right = 0;
    if (corners.topRight.type.isExtrude) {
      right = math.max(left, corners.topRight.x);
    }
    if (corners.bottomRight.type.isExtrude) {
      right = math.max(left, corners.bottomRight.x);
    }
    return EdgeInsets.only(
      left: left,
      right: right,
    );
  }

  EdgeInsetsGeometry _padding(BuildContext context) {
    if (!automaticAddPadding) return padding;
    return padding.add(_extraPadding(context));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CRRectContainerPainter(
        color: color,
        gradient: gradient,
        // radius: borderRadius.resolve(Directionality.of(context)),
        corners: corners,
        // vertical: vertical,
      ),
      child: Padding(
        padding: _padding(context),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _CRRectContainerPainter extends CustomPainter {
  _CRRectContainerPainter({
    this.color,
    this.gradient,
    // required this.radius,
    required this.corners,
    // required this.vertical,
  });

  final Color? color;
  final Gradient? gradient;
  // final BorderRadius radius;
  final CRRectCorners corners;

  // final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final CRRectRadius topLeft = corners.topLeft;
    final CRRectRadius topRight = corners.topRight;
    final CRRectRadius bottomLeft = corners.bottomLeft;
    final CRRectRadius bottomRight = corners.bottomRight;

    double leftShift = 0;
    double rightShift = 0;

    if (corners.topLeft.type.isExtrude && corners.bottomLeft.type.isExtrude) {
      leftShift = math.max(topLeft.x, topLeft.y);
    } else if (corners.topLeft.type.isExtrude) {
      leftShift = topLeft.x;
    } else if (corners.bottomLeft.type.isExtrude) {
      leftShift = bottomLeft.x;
    }

    if (corners.topRight.type.isExtrude && corners.bottomRight.type.isExtrude) {
      rightShift = math.max(topRight.x, bottomRight.x);
    } else if (corners.topRight.type.isExtrude) {
      rightShift = topRight.x;
    } else if (corners.bottomRight.type.isExtrude) {
      rightShift = bottomRight.x;
    }

    final Paint paint = Paint();

    paint.color = color ?? Colors.transparent;

    if (gradient != null) {
      paint.shader = gradient?.createShader(Rect.fromLTRB(
        0,
        0,
        size.width,
        size.height,
      ));
    }

    paint.style = PaintingStyle.fill;

    final Path path = Path();
    Offset startPoint = const Offset(0, 0);
    if (corners.topLeft.type.isExtrude) {
      startPoint = Offset(leftShift - topLeft.x, 0);
      path.moveTo(leftShift - topLeft.x, 0);
      path.arcToPoint(
        Offset(leftShift, topLeft.y),
        radius: topLeft,
        clockwise: true,
      );
    } else {
      startPoint = Offset(leftShift + topLeft.x, 0);
      path.moveTo(leftShift + topLeft.x, 0);
      path.arcToPoint(
        Offset(leftShift, topLeft.y),
        radius: topLeft,
        clockwise: corners.topLeft.type.isInvert,
      );
    }
    path.lineTo(leftShift, size.height - bottomLeft.y);
    if (corners.bottomLeft.type.isExtrude) {
      path.arcToPoint(
        Offset(leftShift - bottomLeft.x, size.height),
        radius: bottomRight,
        clockwise: true,
      );
    } else {
      path.arcToPoint(
        Offset(leftShift + bottomLeft.x, size.height),
        radius: bottomRight,
        clockwise: corners.bottomLeft.type.isInvert,
      );
    }
    if (corners.bottomRight.type.isExtrude) {
      path.lineTo(size.width - (rightShift - bottomRight.x), size.height);
      path.arcToPoint(
        Offset(size.width - rightShift, size.height - bottomRight.y),
        radius: bottomRight,
        clockwise: true,
      );
    } else {
      path.lineTo(size.width - (rightShift + bottomRight.x), size.height);
      path.arcToPoint(
        Offset(size.width - rightShift, size.height - bottomRight.y),
        radius: bottomRight,
        clockwise: corners.bottomRight.type.isInvert,
      );
    }

    path.lineTo(size.width - rightShift, topRight.y);

    if (corners.topRight.type.isExtrude) {
      path.arcToPoint(
        Offset(size.width - (rightShift - topRight.x), 0),
        radius: topRight,
        clockwise: true,
      );
    } else {
      path.arcToPoint(
        Offset(size.width - (rightShift + topRight.x), 0),
        radius: topRight,
        clockwise: corners.topRight.type.isInvert,
      );
    }
    path.lineTo(startPoint.dx, startPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
