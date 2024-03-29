import "dart:math";

import "package:flutter/material.dart";

const int _kMaxLoopMin = 100;
const int _kMaxLoopMax = 100000;

class CFlipBoard extends _CFlipBoard {
  CFlipBoard({
    super.key,
    required List<Widget> items,
    super.loopsOnInit,
    super.loopsOnChange,
    super.maxLoop = 100,
    super.targetIndex,
    super.durationPerAnimation,
    super.durationPerFlip,
    super.boardBuilder,
    super.containerDecoration,
    super.reflectionColor,
    super.shadeColor,
    super.dividerGap,
    super.perspective,
    super.curve,
    // super.singleDirection,
    super.animateOnInit,
    super.animateOnChange,
  }) : super(
          itemCount: items.length,
          itemBuilder: (index) => items[index],
        );

  const CFlipBoard.builder({
    super.key,
    required super.itemCount,
    required super.itemBuilder,
    super.loopsOnInit,
    super.loopsOnChange,
    super.maxLoop = 100,
    super.targetIndex,
    super.durationPerAnimation,
    super.durationPerFlip,
    super.boardBuilder,
    super.containerDecoration,
    super.reflectionColor,
    super.shadeColor,
    super.dividerGap,
    super.perspective,
    super.curve,
    // super.singleDirection,
    super.animateOnInit,
    super.animateOnChange,
  });
}

abstract class _CFlipBoard extends StatefulWidget {
  const _CFlipBoard({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.loopsOnInit,
    this.loopsOnChange,
    this.maxLoop = 100,
    this.targetIndex,
    this.durationPerAnimation,
    this.durationPerFlip,
    this.boardBuilder,
    this.containerDecoration = const BoxDecoration(),
    this.reflectionColor = const Color(0x40ffffff),
    this.shadeColor = const Color(0x14000000),
    this.dividerGap = 0,
    this.perspective = 0.006,
    this.curve = Curves.easeOutQuart,
    // this.singleDirection = false,
    this.animateOnInit = true,
    this.animateOnChange = true,
  })  : _maxLoop = maxLoop < _kMaxLoopMin
            ? _kMaxLoopMin
            : maxLoop > _kMaxLoopMax
                ? _kMaxLoopMax
                : maxLoop,
        _trueLength = (maxLoop < _kMaxLoopMin
                ? _kMaxLoopMin
                : maxLoop > _kMaxLoopMax
                    ? _kMaxLoopMax
                    : maxLoop) *
            itemCount *
            2,
        _halfLength = (maxLoop < _kMaxLoopMin
                ? _kMaxLoopMin
                : maxLoop > _kMaxLoopMax
                    ? _kMaxLoopMax
                    : maxLoop) *
            itemCount,
        _absoluteIndex = (targetIndex ?? 0) % itemCount;

  // final List<Widget> items;

  final Widget Function(int index) itemBuilder;

  final int itemCount;

  /// How many times should the animation loop when init,
  /// if null, it will follow the [targetIndex]'s value as close as possible
  /// if 0, it will use the closest possible card (flip backward)
  /// >0, it will flip forward x times for the next card (no flip backs)
  /// <0, it will flip forward x times for the next card
  final int? loopsOnInit;

  /// How many times should the animation loop when changed,
  /// if null, it will follow the [targetIndex]'s value as close as possible
  /// if 0, it will use the closest possible card (flip backward)
  /// >0, it will flip forward x times for the next card (no flip backs)
  /// <0, it will flip backware x times for the next card
  final int? loopsOnChange;

  /// To define the animation max value, it will between 10 to 100000
  final int maxLoop;

  final int _maxLoop;

  /// Which child should it animate to
  final int? targetIndex;

  /// Use if want a total duration for the animation
  final Duration? durationPerAnimation;

  /// Use if want the duration to depend on each flip
  final Duration? durationPerFlip;

  /// The container for the card, size is prefered
  final Widget Function(BuildContext context, Widget? child)? boardBuilder;

  /// For the whole container including the gap
  final Decoration containerDecoration;

  /// Add a highLight to the bottom portion
  final Color? reflectionColor;
  // final double reflectionOpacity;

  /// Add a shadow to the top portion
  final Color? shadeColor;
  // final double shadeOpacity;

  /// Space between top and bottom portion
  final double dividerGap;

  /// The perspectiv for the board
  final double perspective;

  /// Animation curve
  final Curve curve;

  // final bool singleDirection;

  final int _trueLength;
  final int _halfLength;

  final int _absoluteIndex;

  final bool animateOnInit;
  final bool animateOnChange;

  Widget defaultBoardBuilder(BuildContext context, Widget? child) {
    return Container(
      width: 40,
      height: 60,
      color: Theme.of(context).colorScheme.surface,
      child: Center(child: child),
    );
  }

  Widget Function(BuildContext context, Widget? child) get _boardBuilder =>
      boardBuilder ?? defaultBoardBuilder;

  @override
  State<_CFlipBoard> createState() => _CFlipBoardState();
}

// List<Widget> flipCards = List.generate(10, (index) => Text(index.toString()));

class _CFlipBoardState extends State<_CFlipBoard>
    with TickerProviderStateMixin {
  late final AnimationController animationCtrl;

  /// The current animation's index
  double get animatingIndex => animationCtrl.value * widget._trueLength;

  /// The current animation's index relative to middle
  double get animatingIndexMiddle =>
      animatingIndex % widget.itemCount + widget._halfLength;

  double get animatingIndexMax {
    final trimAnimatingIndex = animatingIndex % widget.itemCount;
    if (trimAnimatingIndex == 0) {
      return widget._trueLength.toDouble();
    } else {
      return widget._trueLength - widget.itemCount + trimAnimatingIndex;
    }
  }

  double get animatingIndexMin => animatingIndex % widget.itemCount;

  /// The result of the final index after animation
  /// this is within the length of target
  // double resultedIndex = 0;

  late int oldTargetIndex = widget.targetIndex ?? 0;
  late int oldAbsoluteIndex = widget._absoluteIndex;
  int? oldTargetAninmationValue;
  bool get isRunning => animationCtrl.value != oldTargetAninmationValue;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    animationCtrl = AnimationController(
      value: 0.5,
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    // setAnimationController();
    animateToTarget(
      restart: true,
      loops: widget.loopsOnInit,
      animate: widget.animateOnInit,
    );
  }

  @override
  void dispose() {
    animationCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _CFlipBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool shouldMoveToTarget = false;
    bool shouldAnimate = false;
    int? loops;
    if (oldWidget._trueLength != widget._trueLength) {
      shouldMoveToTarget = true;
      if (isRunning) {
        shouldAnimate = true;
      }
    }
    if (oldWidget.targetIndex != widget.targetIndex) {
      shouldAnimate = widget.animateOnChange;
      if (oldWidget.targetIndex == null) {
        loops = widget.loopsOnInit;
      } else {
        loops = widget.loopsOnChange;
      }
    }
    if (shouldAnimate || shouldMoveToTarget) {
      animateToTarget(
        animate: shouldAnimate,
        loops: loops,
      );
    }
  }

  Widget _buildTop(Widget child) {
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.5,
        child: Stack(
          children: [
            child,
            if ((widget.shadeColor?.opacity ?? 0) > 0 &&
                widget.targetIndex != null)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.topCenter,
                      colors: [
                        widget.shadeColor!,
                        widget.shadeColor!.withOpacity(0),
                        widget.shadeColor!.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(Widget child) {
    return ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.5,
        child: Stack(
          children: [
            child,
            if ((widget.reflectionColor?.opacity ?? 0) > 0 &&
                widget.targetIndex != null)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.reflectionColor!,
                        widget.reflectionColor!.withOpacity(0),
                        widget.reflectionColor!.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Duration getTotalDuration(double flipTimes) {
    if (widget.durationPerAnimation != null) {
      return widget.durationPerAnimation!;
    } else {
      final int milisecondsPerFlip =
          widget.durationPerFlip?.inMilliseconds ?? 100;
      return Duration(
          milliseconds:
              (milisecondsPerFlip * flipTimes.abs()).clamp(400, 8000).toInt());
    }
  }

  void animateToTarget({
    bool restart = false,
    int? loops,
    bool animate = true,
  }) {
    if (widget.itemCount > 0) {
      if (animate && widget.targetIndex != null) {
        int expectedLoop = 0;

        final double indexDifference =
            ((widget.targetIndex ?? 0) - (oldTargetIndex)).toDouble();
        if (loops != null) {
          expectedLoop = loops;
        } else {
          expectedLoop = (indexDifference / widget.itemCount).truncate();
        }

        if (indexDifference < 0) {
          expectedLoop--;
        }

        expectedLoop = expectedLoop
            .clamp(-widget._maxLoop + 1, widget._maxLoop - 1)
            .round();

        double targetAnimVal;
        final double currentAnimVal;
        if (expectedLoop < 0) {
          if (restart) {
            currentAnimVal = 1;
          } else {
            currentAnimVal = animatingIndexMax / widget._trueLength;
          }
          targetAnimVal = (widget._trueLength +
                  (widget.itemCount * expectedLoop) +
                  widget._absoluteIndex) /
              widget._trueLength;
          if (targetAnimVal > currentAnimVal) {
            targetAnimVal -= widget.itemCount / widget._trueLength;
          }
        } else {
          if (restart) {
            currentAnimVal = 0;
          } else {
            currentAnimVal = animatingIndexMin / widget._trueLength;
          }
          targetAnimVal =
              ((widget.itemCount * expectedLoop) + widget._absoluteIndex) /
                  widget._trueLength;
          if (targetAnimVal < currentAnimVal) {
            targetAnimVal += widget.itemCount / widget._trueLength;
          }
        }

        animationCtrl.value = currentAnimVal;

        final Duration totalDuration = getTotalDuration(
            (targetAnimVal - animationCtrl.value) * widget._trueLength);

        animationCtrl.animateTo(
          targetAnimVal,
          duration: totalDuration,
          curve: widget.curve,
        );
      } else {
        setState(() {
          animationCtrl.value =
              (widget._absoluteIndex % widget.itemCount) / widget._trueLength;
        });
      }
    }
    oldTargetIndex = widget.targetIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final double targetPerspective = widget.perspective.clamp(0, 0.2);
    final int currentIndex = (animatingIndex.truncate() % widget.itemCount);
    final int nextIndex = ((animatingIndex.truncate() + 1) % widget.itemCount);

    final Widget? currentChild =
        widget.targetIndex != null ? widget.itemBuilder(currentIndex) : null;

    final Widget? nextChild =
        widget.targetIndex != null ? widget.itemBuilder(nextIndex) : null;

    final Widget wrappedCurrentChild =
        widget._boardBuilder(context, currentChild);
    final Widget wrappedNextChild = widget._boardBuilder(context, nextChild);

    final Widget currentChildTop = _buildTop(wrappedCurrentChild);
    final Widget currentChildBottom = _buildBottom(wrappedCurrentChild);
    final Widget targetChildTop = _buildTop(wrappedNextChild);
    final Widget targetChildBottom = _buildBottom(wrappedNextChild);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: DecoratedBox(
            decoration: widget.containerDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    currentChildTop,
                    if ((animatingIndex % 1) >= 0.5 &&
                        widget.targetIndex != null)
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, targetPerspective)
                          ..rotateX(-((animatingIndex % 1) - 1) * pi),
                        alignment: Alignment.bottomCenter,
                        child: targetChildTop,
                      ),
                  ],
                ),
                SizedBox(height: widget.dividerGap),
                Stack(
                  children: [
                    targetChildBottom,
                    if ((animatingIndex % 1) < 0.5 &&
                        widget.targetIndex != null)
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, targetPerspective)
                          ..rotateX(-(animatingIndex % 1) * pi),
                        alignment: Alignment.topCenter,
                        child: currentChildBottom,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
