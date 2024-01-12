import "dart:async";
import "package:flutter/material.dart";

/// You can use whatever widget as a [child], when you don't need to provide any
/// [child], just provide an empty Container().
/// [delay] is using a [Timer] for delaying the animation, it's zero by default.
/// You can set [repeat] to true for making a paulsing effect.

class CRippleAnimation extends StatefulWidget {
  const CRippleAnimation({
    super.key,
    this.child,
    this.color,
    this.delay = const Duration(milliseconds: 0),
    this.repeat = false,
    this.minRadius = 60,
    this.ripplesCount = 5,
    this.duration = const Duration(milliseconds: 3000),
    this.interval = const Duration(milliseconds: 800),
  });

  final Widget? child;
  final Duration delay;
  final double minRadius;
  final Color? color;
  final int ripplesCount;
  final Duration duration;
  final bool repeat;
  final Duration interval;

  @override
  State<CRippleAnimation> createState() => _CRippleAnimationState();
}

class _CRippleAnimationState extends State<CRippleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  Timer? timer;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // repeating or just forwarding the animation once.
    timer = Timer(widget.delay, () {
      _controller.forward();
      if (widget.repeat) {
        _controller.addStatusListener((AnimationStatus status) {
          // <-- add listener
          if (status == AnimationStatus.completed) {
            timer?.cancel();
            timer = Timer(widget.interval, () {
              if (_controller.isCompleted) {
                _controller.forward(from: 0.0);
              }
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(
        _controller,
        color: widget.color ?? Theme.of(context).colorScheme.primary,
        minRadius: widget.minRadius,
        wavesCount: widget.ripplesCount,
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

// Creating a Circular painter for clipping the rects and creating circle shapes
class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    required this.minRadius,
    required this.wavesCount,
    required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final double minRadius;
  final int wavesCount;
  final Animation<double> _animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 0; wave <= wavesCount; wave++) {
      circle(
        canvas: canvas,
        rect: rect,
        minRadius: minRadius,
        wave: wave,
        animationValue: _animation.value,
        wavesCount: wavesCount,
      );
    }
  }

  void circle({
    required Canvas canvas,
    required Rect rect,
    required double minRadius,
    required int wave,
    required double animationValue,
    required int wavesCount,
  }) {
    if (wave != 0) {
      double opacity =
          (1 - ((wave - 1) / wavesCount) - animationValue).clamp(0.0, 1.0);
      Color translucentColor = color.withOpacity(opacity);

      double radius =
          minRadius * (1 + ((wave * animationValue))) * animationValue;
      final Paint paint = Paint()..color = translucentColor;
      canvas.drawCircle(rect.center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
