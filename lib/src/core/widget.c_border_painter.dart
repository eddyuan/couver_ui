import 'package:flutter/material.dart';

class CBorderPainter extends StatelessWidget {
  CBorderPainter({
    Key? key,
    this.child,
    Gradient? gradient,
    OutlinedBorder? shape,
  })  : _painter = (shape != null)
            ? _BorderPainter(
                gradient: gradient,
                shape: shape,
              )
            : null,
        super(key: key);

  final _BorderPainter? _painter;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: child,
    );
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter({
    this.gradient,
    this.shape,
  });

  final Gradient? gradient;
  final OutlinedBorder? shape;

  final Paint _paintOutter = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    Rect outerRect = Offset.zero & size;
    if (shape != null && shape!.side.width > 0) {
      // _paintOutter.color = shape!.side.color;
      if (gradient != null) {
        _paintOutter.shader = gradient?.createShader(outerRect);
        Path path1 = shape!.getOuterPath(outerRect);
        Path path2 = shape!.getInnerPath(outerRect);
        Path path = Path.combine(PathOperation.difference, path1, path2);
        canvas.drawPath(path, _paintOutter);
      } else {
        shape!.paint(canvas, outerRect);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
