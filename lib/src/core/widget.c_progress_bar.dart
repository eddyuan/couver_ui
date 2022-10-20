import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";

import '../constants/animation_constants.dart';
import 'animation.c_ripple.dart';

class CIndicatorLineOption {
  const CIndicatorLineOption({
    this.height = 6,
    this.width = 2,
    this.color,
    this.gradient,
  });
  final double height;
  final double width;
  final Color? color;
  final Gradient? gradient;
}

class CIndicatorDotOption {
  const CIndicatorDotOption({
    this.padding = 2,
    this.showRipple = true,
    this.color,
    this.rippleColor,
    // this.size = 2,
  });
  final double padding;
  final bool showRipple;
  final Color? color;
  final Color? rippleColor;
  // final double size;
}

class CProgressBar extends StatefulWidget {
  const CProgressBar({
    this.barHeight = 12,
    this.progress = 0,
    this.borderRadius = 1000,
    this.endLabel,
    this.startLabel,
    this.label,
    this.showIndicatorDot = true,
    this.showIndicatorLine,
    // this.indicatorLineWidth = 2,
    // this.indicatorLineHeight = 6,
    // this.indicaotrLineColor,
    // this.indicatorLineGradient,
    this.indicatorDotOption = const CIndicatorDotOption(),
    this.indicatorLineOption = const CIndicatorLineOption(),
    this.color,
    this.gradient,
    this.trackColor,
    this.showIndicatorAtZero = false,
    this.labelAtTop = false,
    this.steps,
    this.animationDuration,
    Key? key,
  }) : super(key: key);

  final double barHeight;
  final double progress;
  final Widget? startLabel;
  final Widget? endLabel;
  final Widget? label;
  final double borderRadius;
  final bool showIndicatorDot;
  final bool? showIndicatorLine;
  final Color? color;
  final Color? trackColor;
  final Gradient? gradient;
  // final double indicatorLineWidth;
  // final double indicatorLineHeight;
  // final Color? indicaotrLineColor;
  // final Gradient? indicatorLineGradient;

  final CIndicatorDotOption indicatorDotOption;
  final CIndicatorLineOption indicatorLineOption;
  final bool showIndicatorAtZero;

  /// Swap position of the current label and begin end label
  final bool labelAtTop;

  /// Make multiple indicator dots
  final int? steps;

  final Duration? animationDuration;

  /// Make label, startLabe, endLabel at the same row;
  // final bool singleRowLabel;

  @override
  State<CProgressBar> createState() => _CProgressBarState();
}

class _CProgressBarState extends State<CProgressBar>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey labelKey = GlobalKey();
  final GlobalKey layoutKey = GlobalKey();
  final GlobalKey startLabelKey = GlobalKey();
  final GlobalKey endLabelKey = GlobalKey();

  double labelLeft = 0;
  double lineLeft = 0;
  double dotLeft = 0;
  double progressLeft = 0;

  Duration get animationDuration =>
      widget.animationDuration ?? kAnimationProgressDuration;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    // print('inistate cprogressbar');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () => drawLabel());
    });
    super.initState();
    // print('inistate cprogressbar 2');
  }

  double calcLeft(double centerLine, double maxWidth, double itemWidth) {
    return (centerLine - (itemWidth / 2)).clamp(0, maxWidth - itemWidth);
  }

  void drawLabel() {
    Future.delayed(Duration.zero, () {
      final RenderBox? layoutRenderBox =
          layoutKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? labelRenderBox =
          labelKey.currentContext?.findRenderObject() as RenderBox?;
      if (layoutRenderBox != null) {
        final double centerShift = showIndicatorDot ? widget.barHeight / 2 : 0;
        final double maxWidth = layoutRenderBox.constraints.maxWidth;

        final double centerLine = ((maxWidth * progress) + centerShift)
            .clamp(centerShift, maxWidth - centerShift);

        double startLabelWidth = 0;
        double endLabelWidth = 0;
        if (widget.startLabel != null) {
          final RenderBox? startLabelRenderBox =
              startLabelKey.currentContext?.findRenderObject() as RenderBox?;
          startLabelWidth = startLabelRenderBox?.size.width ?? 0;
        }
        if (widget.endLabel != null) {
          final RenderBox? endLabelRenderBox =
              endLabelKey.currentContext?.findRenderObject() as RenderBox?;
          endLabelWidth = endLabelRenderBox?.size.width ?? 0;
        }

        setState(() {
          dotLeft = calcLeft(centerLine, maxWidth, widget.barHeight);
          progressLeft =
              calcLeft(centerLine, maxWidth, centerShift * 2) + centerShift * 2;
          lineLeft =
              calcLeft(centerLine, maxWidth, widget.indicatorLineOption.width);
          if (labelRenderBox != null) {
            labelLeft = calcLeft(
                centerLine - startLabelWidth,
                maxWidth - startLabelWidth - endLabelWidth - 2,
                labelRenderBox.size.width);
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CProgressBar oldWidget) {
    drawLabel();
    super.didUpdateWidget(oldWidget);
  }

  // Size _getLabelProgressSize(BoxConstraints constraints) {
  //   final targetWidth = constraints.maxWidth * widget.progress;
  //   return Size(targetWidth, labelSize.height);
  // }

  bool get showIndicatorDot =>
      widget.showIndicatorDot && (progress > 0 || widget.showIndicatorAtZero);

  double get indicatorSize =>
      widget.barHeight - (widget.indicatorDotOption.padding * 2);

  double get progress {
    final int steps = widget.steps ?? 0;
    if (steps == 0) {
      return widget.progress.clamp(0, 1);
    }
    double clampedProgress = widget.progress.clamp(0, steps.toDouble());
    if (clampedProgress > 1) {
      return clampedProgress.round() / steps;
    } else {
      return (clampedProgress * steps).round() / steps;
    }
  }

  bool get showIndicatorLine =>
      widget.showIndicatorLine == true ||
      (widget.showIndicatorLine != false && widget.label != null);

  Widget _buildIndicatorDot({
    CIndicatorDotOption option = const CIndicatorDotOption(),
  }) {
    final double indicatorDotSize = widget.barHeight - (option.padding * 2);
    final Widget indicatorDot = Container(
      decoration: BoxDecoration(
        color: option.color ?? Colors.white,
        borderRadius: BorderRadius.circular(
          widget.borderRadius - option.padding,
        ),
      ),
      width: indicatorDotSize,
      height: indicatorDotSize,
    );
    return AnimatedOpacity(
      curve: kAnimationProgressCurve,
      duration: animationDuration,
      opacity: showIndicatorDot ? 1 : 0,
      child: Row(
        children: [
          AnimatedContainer(
            alignment: Alignment.centerLeft,
            curve: kAnimationProgressCurve,
            duration: animationDuration,
            width: dotLeft,
          ),
          Padding(
            padding: EdgeInsets.all(option.padding),
            child: option.showRipple
                ? CRippleAnimation(
                    ripplesCount: 6,
                    repeat: true,
                    minRadius: indicatorDotSize + 2,
                    color: option.rippleColor ??
                        Theme.of(context).colorScheme.secondary,
                    child: indicatorDot,
                  )
                : indicatorDot,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorLine({
    CIndicatorLineOption option = const CIndicatorLineOption(),
    Gradient? fallbackGradient,
    Color? fallbackColor,
  }) {
    return Row(
      children: [
        AnimatedContainer(
          alignment: Alignment.centerLeft,
          curve: kAnimationProgressCurve,
          duration: animationDuration,
          width: lineLeft,
        ),
        Container(
          height: option.height,
          width: option.width,
          decoration: BoxDecoration(
            color: option.color ??
                fallbackColor ??
                Theme.of(context).colorScheme.secondary,
            gradient: option.gradient ?? fallbackGradient,
          ),
        ),
      ],
    );
  }

  Widget _buildFilledBar() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            alignment: Alignment.centerLeft,
            curve: kAnimationProgressCurve,
            duration: animationDuration,
            width: progressLeft,
            height: widget.barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.color ?? Theme.of(context).colorScheme.secondary,
              gradient: widget.gradient,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepDots() {
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.steps!,
          (index) => Container(
            padding: EdgeInsets.all(widget.indicatorDotOption.padding),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: widget.indicatorDotOption.color ?? Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.trackColor ?? Colors.grey.withOpacity(0.3),
          ),
          height: widget.barHeight,
        ),
        _buildFilledBar(),
        if (widget.steps != null) _buildStepDots(),
        _buildIndicatorDot(option: widget.indicatorDotOption),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        if (widget.startLabel != null)
          SizedBox(
            key: startLabelKey,
            child: widget.startLabel,
          ),
        Expanded(
          child: Row(
            children: [
              AnimatedContainer(
                curve: kAnimationProgressCurve,
                duration: animationDuration,
                width: labelLeft,
              ),
              SizedBox(
                key: labelKey,
                child: widget.label,
              ),
            ],
          ),
        ),
        if (widget.endLabel != null)
          SizedBox(
            key: endLabelKey,
            child: widget.endLabel,
          ),
      ],
    );
  }

  List<Widget> _buildLabelWithLine() {
    return [
      if (showIndicatorLine && !widget.labelAtTop)
        _buildIndicatorLine(
          option: widget.indicatorLineOption,
          fallbackColor: widget.gradient?.colors.last ?? widget.color,
          fallbackGradient: widget.gradient,
        ),
      if (widget.label != null) _buildLabel(),
      if (showIndicatorLine && widget.labelAtTop)
        _buildIndicatorLine(
          option: widget.indicatorLineOption,
          fallbackColor: widget.gradient?.colors.last ?? widget.color,
          fallbackGradient: widget.gradient,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // widget.label?;
    return LayoutBuilder(
      key: layoutKey,
      builder: (BuildContext ctx, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LinearProgressIndicator(
            //   value: progress,
            //   color: Colors.red,
            // ),
            // Container(
            //   child: AnimatedAlign(
            //     duration: animationDuration,
            //     curve: kAnimationProgressCurve,
            //     alignment: Alignment(progress * 2 - 1, 0),
            //     child: widget.label,
            //   ),
            // ),
            if (widget.labelAtTop) ..._buildLabelWithLine(),
            _buildProgressBar(),
            if (!widget.labelAtTop) ..._buildLabelWithLine(),
          ],
        );
      },
    );
  }
}
