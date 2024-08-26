import "package:flutter/widgets.dart";

class GradientBoxBorder extends BoxBorder {
  final Gradient? gradient;
  final double width;
  final Color? color;
  final double glowSize;

  const GradientBoxBorder({
    this.gradient,
    this.width = 1.0,
    this.color,
    this.glowSize = 0,
  });

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    switch (shape) {
      case BoxShape.circle:
        assert(borderRadius == null,
            "A borderRadius can only be given for rectangular boxes.");
        _paintCircle(canvas, rect);
        break;
      case BoxShape.rectangle:
        if (borderRadius != null) {
          _paintRRect(canvas, rect, borderRadius);
          return;
        }
        _paintRect(canvas, rect);
        break;
    }
  }

  void _paintRect(Canvas canvas, Rect rect) {
    canvas.drawRect(rect.deflate(width / 2), _getPaint(rect));
    if (glowSize > 0) {
      canvas.drawRect(rect.deflate(width / 2), _getGlow(rect));
    }
  }

  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final RRect rrect = borderRadius.toRRect(rect).deflate(width / 2);
    canvas.drawRRect(rrect, _getPaint(rect));
    if (glowSize > 0) {
      canvas.drawRRect(rrect, _getGlow(rect));
    }
  }

  void _paintCircle(Canvas canvas, Rect rect) {
    final Paint paint = _getPaint(rect);
    final double radius = (rect.shortestSide - width) / 2.0;
    canvas.drawCircle(rect.center, radius, paint);
    if (glowSize > 0) {
      canvas.drawCircle(rect.center, radius, _getGlow(rect));
    }
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }

  Paint _getPaint(Rect rect) {
    if (color != null) {
      return Paint()
        ..strokeWidth = width
        ..color = color!
        ..style = PaintingStyle.stroke;
    }
    if (gradient != null) {
      return Paint()
        ..strokeWidth = width
        ..shader = gradient!.createShader(rect)
        ..style = PaintingStyle.stroke;
    }
    return Paint();
  }

  Paint _getGlow(Rect rect) {
    if (color != null) {
      return Paint()
        ..strokeWidth = width
        ..color = color!
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSize);
    }
    if (gradient != null) {
      return Paint()
        ..strokeWidth = width
        ..shader = gradient!.createShader(rect)
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSize);
    }
    return Paint();
  }
}
