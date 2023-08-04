// import 'package:flutter/material.dart';

// @immutable
// class COutlinedBorder extends ShapeBorder {
//   final double width;
//   final Gradient? gradient;
//   final Color fallbackColor;
//   final double borderRadius;

//   const COutlinedBorder({
//     this.width = 2.0,
//     this.gradient,
//     required this.fallbackColor,
//     this.borderRadius = 0.0,
//   });

//   @override
//   ShapeBorder scale(double t) {
//     return this;
//   }

//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     return Path()
//       ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
//   }

//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     return Path()
//       ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
//   }

//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = width;

//     if (gradient != null) {
//       paint.shader = gradient!.createShader(rect);
//     } else {
//       paint.color = fallbackColor;
//     }

//     final path = Path()
//       ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
//     canvas.drawPath(path, paint);
//   }
// }

// class CBorderPainter extends StatelessWidget {
//   CBorderPainter({
//     Key? key,
//     this.child,
//     Gradient? gradient,
//     OutlinedBorder? shape,
//   })  : _painter = (shape != null)
//             ? _BorderPainter(
//                 gradient: gradient,
//                 shape: shape,
//               )
//             : null,
//         super(key: key);

//   final _BorderPainter? _painter;
//   final Widget? child;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _painter,
//       child: child,
//     );
//   }
// }

// class _BorderPainter extends CustomPainter {
//   _BorderPainter({
//     this.gradient,
//     this.shape,
//   });

//   final Gradient? gradient;
//   final OutlinedBorder? shape;

//   final Paint _paintOutter = Paint();

//   @override
//   void paint(Canvas canvas, Size size) {
//     Rect outerRect = Offset.zero & size;
//     if (shape != null && shape!.side.width > 0) {
//       // _paintOutter.color = shape!.side.color;
//       if (gradient != null) {
//         // _paintOutter.shader = gradient?.createShader(outerRect);
//         // Path path1 = shape!.getOuterPath(outerRect);
//         // Path path2 = shape!.getInnerPath(outerRect);
//         // Path path = Path.combine(PathOperation.difference, path1, path2);
//         // canvas.drawPath(path, _paintOutter);
//         final paintx = Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1
//           ..color = shape!.side.color;
//         paintx.shader = gradient?.createShader(outerRect);
//         final pathx = Path()
//           ..addRRect(RRect.fromRectAndRadius(outerRect, Radius.circular(16)));
//         canvas.drawPath(pathx, paintx);
//       } else {
//         shape!.paint(canvas, outerRect);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
// }
