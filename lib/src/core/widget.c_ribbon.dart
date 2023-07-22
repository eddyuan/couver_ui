import 'dart:math';
import 'package:flutter/material.dart';

class CRibbon extends StatelessWidget {
  const CRibbon({
    super.key,
    this.rightSize = 4,
    this.angle = 60,
    this.backSideWidth = 4,
    this.backColor = const Color(0xFF4D8BC9),
    this.frontGradient = const LinearGradient(
      colors: [
        Color(0xff4d8bc9),
        Color(0xff8bc541),
      ],
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.tipRadius = 4,
    this.child,
  });
  final double rightSize;
  final double angle;
  final double backSideWidth;
  final Color backColor;
  final Gradient frontGradient;
  final EdgeInsets padding;

  /// The radius of the Tip
  final double tipRadius;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CRibbonPainter(
        rightSize: rightSize,
        angle: angle,
        backSideWidth: backSideWidth,
        backColor: backColor,
        frontGradient: frontGradient,
        tipRadius: tipRadius,
      ),
      child: Padding(
        padding: padding,
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _CRibbonPainter extends CustomPainter {
  _CRibbonPainter({
    this.rightSize = 4,
    this.angle = 60,
    this.backSideWidth = 4,
    required this.backColor,
    required this.frontGradient,
    // this.child,
    this.tipRadius = 4,
  });

  final double rightSize;
  final double angle;
  final double backSideWidth;
  final Color backColor;
  final Gradient frontGradient;
  // final Widget? child;
  final double tipRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.shader = frontGradient
        .createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    // paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;

    final double tipWidth = (1 / tan(angle * (pi / 180))) * size.height / 2;

    final Path path = Path();

    path.moveTo(size.width, -rightSize);
    path.arcToPoint(
      Offset(size.width - rightSize, 0),
      radius: Radius.circular(rightSize),
      clockwise: true,
    );

    path.lineTo(tipWidth, 0);
    path.lineTo(0, (size.height - tipRadius) / 2);
    path.arcToPoint(
      Offset(0, (size.height + tipRadius) / 2),
      radius: Radius.circular(tipRadius * 2),
      clockwise: false,
    );
    path.lineTo(tipWidth, size.height);
    path.lineTo(size.width - rightSize, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - rightSize),
      radius: Radius.circular(rightSize),
      clockwise: false,
    );
    final Paint paint2 = Paint();
    paint2.color = backColor;
    final Path path2 = Path();

    path2.moveTo(size.width - rightSize - backSideWidth, 0);
    path2.lineTo(size.width - rightSize - backSideWidth, -rightSize * 2);
    path2.lineTo(size.width - rightSize, -rightSize * 2);
    path2.arcToPoint(
      Offset(size.width - rightSize, 0),
      radius: Radius.circular(rightSize),
      clockwise: true,
    );
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
