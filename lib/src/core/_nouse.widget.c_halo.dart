// import "dart:math";

// import "package:flutter/material.dart";

// // import 'dart:ui' as ui;

// class _BorderPainter extends CustomPainter {
//   _BorderPainter({
//     required this.strokeWidth,
//     required this.radius,
//     this.gradient,
//     this.color,
//     required this.animation,
//   }) : super(repaint: animation);

//   final Paint _paint = Paint();
//   // final double radius;
//   final BorderRadius radius;
//   final double strokeWidth;
//   final Gradient? gradient;
//   final Color? color;
//   final Animation<double> animation;

//   List<Color> colors = [
//     const Color(0xFFF60C0C),
//     const Color(0xFFF3B913),
//     const Color(0xFFE7F716),
//     const Color(0xFF3DF30B),
//     const Color(0xFF0DF6EF),
//     const Color(0xFF0829FB),
//     const Color(0xFFB709F4),
//   ];

// // colors.addAll(colors.reversed.toList());

// // final List<double> pos = List.generate(colors.length, (index) => index / colors.length);

//   final Animatable<double> breatheTween = TweenSequence<double>(
//     <TweenSequenceItem<double>>[
//       TweenSequenceItem<double>(
//         tween: Tween<double>(begin: 0, end: 4),
//         weight: 1,
//       ),
//       TweenSequenceItem<double>(
//         tween: Tween<double>(begin: 4, end: 0),
//         weight: 1,
//       ),
//     ],
//   ).chain(CurveTween(curve: Curves.decelerate));

//   @override
//   void paint(Canvas canvas, Size size) {
//     // create outer rectangle equals size
//     Rect outerRect = Offset.zero & size;

//     final double topLeft = radius.topLeft.x;
//     final double topRight = radius.topRight.x;
//     final double bottomLeft = radius.bottomLeft.x;
//     final double bottomRight = radius.bottomRight.x;

//     var outerRRect = RRect.fromRectAndCorners(
//       outerRect,
//       topLeft: Radius.circular(topLeft),
//       topRight: Radius.circular(topRight),
//       bottomLeft: Radius.circular(bottomLeft),
//       bottomRight: Radius.circular(bottomRight),
//     );
//     // RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

//     // create inner rectangle smaller by strokeWidth
//     Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
//         size.width - strokeWidth * 2, size.height - strokeWidth * 2);
//     var innerRRect = RRect.fromRectAndCorners(
//       innerRect,
//       topLeft: Radius.circular(max(topLeft - strokeWidth, 0)),
//       topRight: Radius.circular(max(topRight - strokeWidth, 0)),
//       bottomLeft: Radius.circular(max(bottomLeft - strokeWidth, 0)),
//       bottomRight: Radius.circular(max(bottomRight - strokeWidth, 0)),
//     );

//     // apply gradient shader
//     List<Color> activeColors = [...colors];
//     // activeColors.addAll(colors.reversed.toList());

//     // final List<double> pos =
//     //     List.generate(colors.length, (index) => index / colors.length);

//     // print(animation);

//     _paint.shader = SweepGradient(
//       colors: activeColors,
//       // startAngle: 0,
//       // endAngle: (animation.value + 2) * pi,
//       transform: GradientRotation(animation.value * pi * 2),
//     ).createShader(outerRect);
//     // ui.Gradient.sweep(Offset.zero, colors, pos, TileMode.clamp, 0, 2 * pi);

//     // if (gradient != null) {
//     //   _paint.shader = gradient?.createShader(outerRect);
//     // } else if (color != null) {
//     //   _paint.color = color!;
//     // }

//     // create difference between outer and inner paths and draw it
//     Path path1 = Path()..addRRect(outerRRect);
//     Path path2 = Path()..addRRect(innerRRect);
//     final path = Path.combine(PathOperation.difference, path1, path2);
//     canvas.drawPath(path, _paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
// }

// class Halo extends StatefulWidget {
//   const Halo({Key? key}) : super(key: key);

//   @override
//   State<Halo> createState() => _HaloState();
// }

// class _HaloState extends State<Halo> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//     _ctrl.repeat();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: const Size(200, 200),
//       painter: _BorderPainter(
//         strokeWidth: 2,
//         radius: BorderRadius.circular(12),
//         animation: _ctrl,
//       ),
//     );
//   }
// }
