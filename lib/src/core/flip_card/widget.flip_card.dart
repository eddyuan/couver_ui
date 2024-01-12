import "dart:math";
import "package:flutter/material.dart";

enum FlipDirection { vertical, horizontal }

enum Fill { none, fillFront, fillBack }

class AnimationCard extends StatelessWidget {
  const AnimationCard({
    super.key,
    this.child,
    this.animation,
    this.direction,
  });

  final Widget? child;
  final Animation<double>? animation;
  final FlipDirection? direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (BuildContext context, Widget? child) {
        Matrix4 transform = Matrix4.identity()..setEntry(3, 2, 0.001);
        if (direction == FlipDirection.vertical) {
          transform.rotateX(animation!.value);
        } else {
          transform.rotateY(animation!.value);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  /// The amount of milliseconds a turn animation will take.
  final int speed;
  final FlipDirection direction;
  final VoidCallback? onFlip;
  final ValueChanged<bool>? onFlipDone;
  final Fill fill;

  final bool flipOnTouch;

  final Alignment alignment;
  final bool flipped;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.speed = 500,
    this.onFlip,
    this.onFlipDone,
    this.direction = FlipDirection.horizontal,
    this.flipOnTouch = true,
    this.alignment = Alignment.center,
    this.fill = Fill.none,
    this.flipped = false,
  });

  @override
  State<StatefulWidget> createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  AnimationController? animationCtrl;
  Animation<double>? _frontRotation;
  Animation<double>? _backRotation;

  // late bool isFront = widget.side == CardSide.front;

  @override
  void initState() {
    super.initState();
    animationCtrl = AnimationController(
      value: widget.flipped ? 1 : 0,
      duration: Duration(milliseconds: widget.speed),
      vsync: this,
    );
    if (widget.flipped) {
      animationCtrl?.forward();
    }
    _frontRotation = TweenSequence(
      [
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(animationCtrl!);
    _backRotation = TweenSequence(
      [
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(animationCtrl!);
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flipped != widget.flipped) {
      doAnimated();
    }
  }

  void doAnimated() {
    final animation =
        widget.flipped ? animationCtrl!.forward() : animationCtrl!.reverse();
    animation.whenComplete(() {
      if (widget.onFlipDone != null) widget.onFlipDone!(widget.flipped);
    });
  }

  @override
  Widget build(BuildContext context) {
    final frontPositioning = widget.fill == Fill.fillFront ? _fill : _noop;
    final backPositioning = widget.fill == Fill.fillBack ? _fill : _noop;
    final child = Stack(
      alignment: widget.alignment,
      fit: StackFit.passthrough,
      children: <Widget>[
        frontPositioning(_buildContent(front: true)),
        backPositioning(_buildContent(front: false)),
      ],
    );

    return child;
  }

  Widget _buildContent({required bool front}) {
    return AnimationCard(
      animation: front ? _frontRotation : _backRotation,
      direction: widget.direction,
      child: front ? widget.front : widget.back,
    );
  }

  @override
  void dispose() {
    animationCtrl!.dispose();
    super.dispose();
  }
}

Widget _fill(Widget child) => Positioned.fill(child: child);
Widget _noop(Widget child) => child;
