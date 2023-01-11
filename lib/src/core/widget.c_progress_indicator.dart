// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:couver_ui/src/constants/animation_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'color_scheme.dart';
// import 'material.dart';
// import 'progress_indicator_theme.dart';
// import 'theme.dart';

const double _kMinCCircularProgressIndicatorSize = 36.0;
const int _kIndeterminateLinearDuration = 1800;
const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

/// A base class for Material Design progress indicators.
///
/// This widget cannot be instantiated directly. For a linear progress
/// indicator, see [CLinearProgressIndicator]. For a circular progress indicator,
/// see [CCircularProgressIndicator].
///
/// See also:
///
///  * <https://material.io/components/progress-indicators>
abstract class CProgressIndicator extends StatefulWidget {
  /// Creates a progress indicator.
  ///
  /// {@template flutter.material.CProgressIndicator.CProgressIndicator}
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  ///
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be used
  /// for determinate progress indicators to indicate how much progress has been made.
  /// {@endtemplate}
  const CProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    // Extra features
    this.gradient,
    this.steps,
    this.gap,
  });

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// The progress indicator's background color.
  ///
  /// It is up to the subclass to implement this in whatever way makes sense
  /// for the given use case. See the subclass documentation for details.
  final Color? backgroundColor;

  /// {@template flutter.progress_indicator.CProgressIndicator.color}
  /// The progress indicator's color.
  ///
  /// This is only used if [CProgressIndicator.valueColor] is null.
  /// If [CProgressIndicator.color] is also null, then the ambient
  /// [CProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  /// {@endtemplate}
  final Color? color;

  /// The progress indicator's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [color]. If that is null,
  /// then it will use the ambient [CProgressIndicatorThemeData.color]. If that
  /// is also null then it defaults to the current theme's [ColorScheme.primary].
  final Animation<Color?>? valueColor;

  /// {@template flutter.progress_indicator.CProgressIndicator.semanticsLabel}
  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@template flutter.progress_indicator.CProgressIndicator.semanticsValue}
  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [CProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  /// {@endtemplate}
  final String? semanticsValue;

  /// This is the foreground gradient!
  final Gradient? gradient;

  /// Do we use seperator
  final int? steps;

  /// Gap size for seperator
  final double? gap;

  Color _getValueColor(BuildContext context) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        Theme.of(context).colorScheme.primary;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value,
        showName: false, ifNull: '<indeterminate>'));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class _CLinearProgressIndicatorPainter extends CustomPainter {
  const _CLinearProgressIndicatorPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.indeterminate,
    // this.value,
    required this.animationValue,
    required this.textDirection,
    this.steps,
    this.gap,
    this.valueGradient,
    required this.gradientFullWidth,
    this.borderRadius,
  });

  final Color backgroundColor;
  final Color valueColor;
  // final double? value;
  final bool indeterminate;
  final double animationValue;
  final TextDirection textDirection;
  final int? steps;
  final double? gap;
  final Gradient? valueGradient;
  final bool gradientFullWidth;
  final BorderRadius? borderRadius;

  // The indeterminate progress animation displays two lines whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect backgroundRect = Offset.zero & size;
    Path backgroundPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          backgroundRect,
          topLeft: borderRadius?.topLeft ?? Radius.zero,
          topRight: borderRadius?.topLeft ?? Radius.zero,
          bottomRight: borderRadius?.bottomRight ?? Radius.zero,
          bottomLeft: borderRadius?.bottomLeft ?? Radius.zero,
        ),
      );

    if (steps != null && steps! > 0) {
      final double targetGap = gap ?? size.height;
      final Path cutOutPath = Path();
      for (int i = 0; i < (steps! - 1); i++) {
        cutOutPath.addRect(
            Offset(size.width / steps! * (i + 1) - (targetGap / 2), 0) &
                Size(targetGap, size.height));
      }
      backgroundPath = Path.combine(
        PathOperation.difference,
        backgroundPath,
        cutOutPath,
      );
    }

    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(backgroundPath, paint);

    paint.color = valueColor;
    if (valueGradient != null && gradientFullWidth) {
      paint.shader = valueGradient!.createShader(Offset.zero & size);
    }

    void drawBar(double x, double width) {
      if (width <= 0.0) return;

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
          break;
        case TextDirection.ltr:
          left = x;
          break;
      }
      final Rect targetRect = Offset(left, 0.0) & Size(width, size.height);

      final Path targetPath = Path.combine(
        PathOperation.intersect,
        Path()..addRect(targetRect),
        backgroundPath,
      );

      if (!gradientFullWidth && valueGradient != null) {
        paint.shader = valueGradient!.createShader(targetRect);
      }
      canvas.drawPath(targetPath, paint);
    }

    if (!indeterminate) {
      drawBar(0.0, animationValue * size.width);
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 =
          size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 =
          size.width * line2Head.transform(animationValue) - x2;

      drawBar(x1, width1);
      drawBar(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_CLinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.indeterminate != indeterminate ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection ||
        oldPainter.gap != gap ||
        oldPainter.valueGradient != valueGradient ||
        oldPainter.steps != steps ||
        oldPainter.gradientFullWidth != gradientFullWidth ||
        oldPainter.borderRadius != borderRadius;
  }
}

enum IndicatorGapShape { square, circle, rounded, roundedInverted }

class CProgressIndicatorGapShape {
  final double? width;
  final double? borderRadius;
  final IndicatorGapShape shape;

  const CProgressIndicatorGapShape.square([this.width])
      : borderRadius = null,
        shape = IndicatorGapShape.square;

  const CProgressIndicatorGapShape.circle([double? diameter])
      : width = diameter,
        borderRadius = null,
        shape = IndicatorGapShape.square;

  const CProgressIndicatorGapShape.rounded({this.width, this.borderRadius})
      : shape = IndicatorGapShape.square;
}

/// A Material Design linear progress indicator, also known as a progress bar.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
///
/// A widget that shows progress along a line. There are two kinds of linear
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
///
/// The indicator line is displayed with [valueColor], an animated value. To
/// specify a constant color value use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// The minimum height of the indicator can be specified using [minHeight].
/// The indicator can be made taller by wrapping the widget with a [SizedBox].
///
/// {@tool dartpad}
/// This example shows a [CLinearProgressIndicator] with a changing value.
///
/// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CCircularProgressIndicator], which shows progress along a circular arc.
///  * [RefreshIndicator], which automatically displays a [CCircularProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
///  * <https://material.io/design/components/progress-indicators.html#linear-progress-indicators>
class CLinearProgressIndicator extends CProgressIndicator {
  /// Creates a linear progress indicator.
  ///
  /// {@macro flutter.material.CProgressIndicator.CProgressIndicator}
  const CLinearProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    super.gradient,
    this.gradientFullWidth = false,
    this.animationDuration = kAnimationProgressDuration,
    this.animationCurve = kAnimationProgressCurve,
    this.animateOnInit = true,
    this.animateOnChange = true,
    this.borderRadius,
  }) : assert(minHeight == null || minHeight > 0);

  const CLinearProgressIndicator.divided({
    super.key,
    double? step,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    super.gap = 4,
    super.gradient,
    required int steps,
    this.gradientFullWidth = false,
    this.animationDuration = kAnimationProgressDuration,
    this.animationCurve = kAnimationProgressCurve,
    this.animateOnInit = true,
    this.animateOnChange = true,
    this.borderRadius,
  })  : assert(minHeight == null || minHeight > 0),
        super(
          value: step != null ? step / steps : null,
          steps: steps,
        );

  /// {@template flutter.material.CLinearProgressIndicator.trackColor}
  /// Color of the track being filled by the linear indicator.
  ///
  /// If [CLinearProgressIndicator.backgroundColor] is null then the
  /// ambient [CProgressIndicatorThemeData.linearTrackColor] will be used.
  /// If that is null, then the ambient theme's [ColorScheme.background]
  /// will be used to draw the track.
  /// {@endtemplate}
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// {@template flutter.material.CLinearProgressIndicator.minHeight}
  /// The minimum height of the line used to draw the linear indicator.
  ///
  /// If [CLinearProgressIndicator.minHeight] is null then it will use the
  /// ambient [CProgressIndicatorThemeData.linearMinHeight]. If that is null
  /// it will use 4dp.
  /// {@endtemplate}
  final double? minHeight;

  final bool gradientFullWidth;

  /// Should you animate the value to the target?
  final Duration animationDuration;

  /// Curv for the animation
  final Curve animationCurve;

  final bool animateOnInit;
  final bool animateOnChange;

  final BorderRadius? borderRadius;

  @override
  State<CLinearProgressIndicator> createState() =>
      _CLinearProgressIndicatorState();
}

class _CLinearProgressIndicatorState extends State<CLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    } else {
      _animateToValue(widget.animateOnInit);
    }
  }

  @override
  void didUpdateWidget(CLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      if (_controller.isAnimating) {
        _controller.stop();
      }
      if (widget.value == null) {
        _controller.repeat();
      } else {
        _animateToValue(widget.animateOnChange);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToValue(bool animate) {
    final double? targetValue = widget.value?.clamp(0, 1);
    if (targetValue != null) {
      if (animate) {
        _controller.animateTo(
          targetValue,
          duration: widget.animationDuration,
          curve: widget.animationCurve,
        );
      } else {
        // setState(() {
        _controller.value = targetValue;
        // });
      }
    }
  }

  Widget _buildIndicator(BuildContext context, double animationValue,
      TextDirection textDirection) {
    final ProgressIndicatorThemeData indicatorTheme =
        ProgressIndicatorTheme.of(context);
    final Color trackColor = widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        Theme.of(context).colorScheme.background;
    final double minHeight =
        widget.minHeight ?? indicatorTheme.linearMinHeight ?? 4.0;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: double.infinity,
              minHeight: minHeight,
            ),
            child: CustomPaint(
              painter: _CLinearProgressIndicatorPainter(
                backgroundColor: trackColor,
                valueColor: widget._getValueColor(context),
                // may be null
                indeterminate: widget.value == null,
                // value: widget.value != null ? animationValue : null,
                // ignored if widget.value is not null
                animationValue: animationValue,
                textDirection: textDirection,
                gap: widget.gap,
                steps: widget.steps,
                valueGradient: widget.gradient,
                gradientFullWidth: widget.gradientFullWidth,
                borderRadius: widget.borderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    // if (widget.value != null) {
    //   return _buildIndicator(context, _controller.value, textDirection);
    // }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

class _CCircularProgressIndicatorPainter extends CustomPainter {
  _CCircularProgressIndicatorPainter({
    this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
    required this.strokeWidth,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 2.0 +
                offsetValue * 0.5 * math.pi,
        arcSweep = value != null
            ? clampDouble(value, 0.0, 1.0) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon);

  final Color? backgroundColor;
  final Color valueColor;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double strokeWidth;
  final double arcStart;
  final double arcSweep;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    if (backgroundColor != null) {
      final Paint backgroundPaint = Paint()
        ..color = backgroundColor!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawArc(Offset.zero & size, 0, _sweep, false, backgroundPaint);
    }

    if (value == null) {
      // Indeterminate
      paint.strokeCap = StrokeCap.square;
    }

    canvas.drawArc(Offset.zero & size, arcStart, arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_CCircularProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.offsetValue != offsetValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth;
  }
}

/// A Material Design circular progress indicator, which spins to indicate that
/// the application is busy.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
///
/// A widget that shows progress along a circle. There are two kinds of circular
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
///
/// The indicator arc is displayed with [valueColor], an animated value. To
/// specify a constant color use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// {@tool dartpad}
/// This example shows a [CCircularProgressIndicator] with a changing value.
///
/// ** See code in examples/api/lib/material/progress_indicator/circular_progress_indicator.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CLinearProgressIndicator], which displays progress along a line.
///  * [RefreshIndicator], which automatically displays a [CCircularProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
///  * <https://material.io/design/components/progress-indicators.html#circular-progress-indicators>
class CCircularProgressIndicator extends CProgressIndicator {
  /// Creates a circular progress indicator.
  ///
  /// {@macro flutter.material.CProgressIndicator.CProgressIndicator}
  const CCircularProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.strokeWidth = 4.0,
    super.semanticsLabel,
    super.semanticsValue,
  }) : _indicatorType = _ActivityIndicatorType.material;

  /// Creates an adaptive progress indicator that is a
  /// [CupertinoActivityIndicator] in iOS and [CCircularProgressIndicator] in
  /// material theme/non-iOS.
  ///
  /// The [value], [backgroundColor], [valueColor], [strokeWidth],
  /// [semanticsLabel], and [semanticsValue] will be ignored in iOS.
  ///
  /// {@macro flutter.material.CProgressIndicator.CProgressIndicator}
  const CCircularProgressIndicator.adaptive({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
    this.strokeWidth = 4.0,
    super.semanticsLabel,
    super.semanticsValue,
  }) : _indicatorType = _ActivityIndicatorType.adaptive;

  final _ActivityIndicatorType _indicatorType;

  /// {@template flutter.material.CCircularProgressIndicator.trackColor}
  /// Color of the circular track being filled by the circular indicator.
  ///
  /// If [CCircularProgressIndicator.backgroundColor] is null then the
  /// ambient [CProgressIndicatorThemeData.circularTrackColor] will be used.
  /// If that is null, then the track will not be painted.
  /// {@endtemplate}
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// The width of the line used to draw the circle.
  final double strokeWidth;

  @override
  State<CCircularProgressIndicator> createState() =>
      _CCircularProgressIndicatorState();
}

class _CCircularProgressIndicatorState extends State<CCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _offsetTween =
      CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween =
      CurveTween(curve: const SawTooth(_rotationCount));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCupertinoIndicator(BuildContext context) {
    final Color? tickColor = widget.backgroundColor;
    return CupertinoActivityIndicator(key: widget.key, color: tickColor);
  }

  Widget _buildMaterialIndicator(BuildContext context, double headValue,
      double tailValue, double offsetValue, double rotationValue) {
    final Color? trackColor = widget.backgroundColor ??
        ProgressIndicatorTheme.of(context).circularTrackColor;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: _kMinCCircularProgressIndicatorSize,
          minHeight: _kMinCCircularProgressIndicatorSize,
        ),
        child: CustomPaint(
          painter: _CCircularProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor: widget._getValueColor(context),
            value: widget.value, // may be null
            headValue:
                headValue, // remaining arguments are ignored if widget.value is not null
            tailValue: tailValue,
            offsetValue: offsetValue,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return _buildMaterialIndicator(
          context,
          _strokeHeadTween.evaluate(_controller),
          _strokeTailTween.evaluate(_controller),
          _offsetTween.evaluate(_controller),
          _rotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._indicatorType) {
      case _ActivityIndicatorType.material:
        if (widget.value != null) {
          return _buildMaterialIndicator(context, 0.0, 0.0, 0, 0.0);
        }
        return _buildAnimation();
      case _ActivityIndicatorType.adaptive:
        final ThemeData theme = Theme.of(context);
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return _buildCupertinoIndicator(context);
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            if (widget.value != null) {
              return _buildMaterialIndicator(context, 0.0, 0.0, 0, 0.0);
            }
            return _buildAnimation();
        }
    }
  }
}

class _RefreshCProgressIndicatorPainter
    extends _CCircularProgressIndicatorPainter {
  _RefreshCProgressIndicatorPainter({
    required super.valueColor,
    required super.value,
    required super.headValue,
    required super.tailValue,
    required super.offsetValue,
    required super.rotationValue,
    required super.strokeWidth,
    required this.arrowheadScale,
  });

  final double arrowheadScale;

  void paintArrowhead(Canvas canvas, Size size) {
    // ux, uy: a unit vector whose direction parallels the base of the arrowhead.
    // (So ux, -uy points in the direction the arrowhead points.)
    final double arcEnd = arcStart + arcSweep;
    final double ux = math.cos(arcEnd);
    final double uy = math.sin(arcEnd);

    assert(size.width == size.height);
    final double radius = size.width / 2.0;
    final double arrowheadPointX =
        radius + ux * radius + -uy * strokeWidth * 2.0 * arrowheadScale;
    final double arrowheadPointY =
        radius + uy * radius + ux * strokeWidth * 2.0 * arrowheadScale;
    final double arrowheadRadius = strokeWidth * 2.0 * arrowheadScale;
    final double innerRadius = radius - arrowheadRadius;
    final double outerRadius = radius + arrowheadRadius;

    final Path path = Path()
      ..moveTo(radius + ux * innerRadius, radius + uy * innerRadius)
      ..lineTo(radius + ux * outerRadius, radius + uy * outerRadius)
      ..lineTo(arrowheadPointX, arrowheadPointY)
      ..close();
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (arrowheadScale > 0.0) {
      paintArrowhead(canvas, size);
    }
  }
}

/// An indicator for the progress of refreshing the contents of a widget.
///
/// Typically used for swipe-to-refresh interactions. See [RefreshIndicator] for
/// a complete implementation of swipe-to-refresh driven by a [Scrollable]
/// widget.
///
/// The indicator arc is displayed with [valueColor], an animated value. To
/// specify a constant color use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// See also:
///
///  * [RefreshIndicator], which automatically displays a [CCircularProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
class CRefreshProgressIndicator extends CCircularProgressIndicator {
  /// Creates a refresh progress indicator.
  ///
  /// Rather than creating a refresh progress indicator directly, consider using
  /// a [RefreshIndicator] together with a [Scrollable] widget.
  ///
  /// {@macro flutter.material.CProgressIndicator.CProgressIndicator}
  const CRefreshProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    super.strokeWidth =
        defaultStrokeWidth, // Different default than CCircularProgressIndicator.
    super.semanticsLabel,
    super.semanticsValue,
  });

  /// Default stroke width.
  static const double defaultStrokeWidth = 2.5;

  /// {@template flutter.material.RefreshCProgressIndicator.backgroundColor}
  /// Background color of that fills the circle under the refresh indicator.
  ///
  /// If [RefreshIndicator.backgroundColor] is null then the
  /// ambient [CProgressIndicatorThemeData.refreshBackgroundColor] will be used.
  /// If that is null, then the ambient theme's [ThemeData.canvasColor]
  /// will be used.
  /// {@endtemplate}
  @override
  Color? get backgroundColor => super.backgroundColor;

  @override
  State<CCircularProgressIndicator> createState() =>
      _RefreshCProgressIndicatorState();
}

class _RefreshCProgressIndicatorState extends _CCircularProgressIndicatorState {
  static const double _indicatorSize = 41.0;

  /// Interval for arrow head to fully grow.
  static const double _strokeHeadInterval = 0.33;

  late final Animatable<double> _convertTween = CurveTween(
    curve: const Interval(0.1, _strokeHeadInterval),
  );

  late final Animatable<double> _additionalRotationTween =
      TweenSequence<double>(
    <TweenSequenceItem<double>>[
      // Makes arrow to expand a little bit earlier, to match the Android look.
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -0.1, end: -0.2),
        weight: _strokeHeadInterval,
      ),
      // Additional rotation after the arrow expanded
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -0.2, end: 1.35),
        weight: 1 - _strokeHeadInterval,
      ),
    ],
  );

  // Last value received from the widget before null.
  double? _lastValue;

  // Always show the indeterminate version of the circular progress indicator.
  //
  // When value is non-null the sweep of the progress indicator arrow's arc
  // varies from 0 to about 300 degrees.
  //
  // When value is null the arrow animation starting from wherever we left it.
  @override
  Widget build(BuildContext context) {
    final double? value = widget.value;
    if (value != null) {
      _lastValue = value;
      _controller.value = _convertTween.transform(value) *
          (1333 / 2 / _kIndeterminateCircularDuration);
    }
    return _buildAnimation();
  }

  @override
  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return _buildMaterialIndicator(
          context,
          // Lengthen the arc a little
          1.05 *
              _CCircularProgressIndicatorState._strokeHeadTween
                  .evaluate(_controller),
          _CCircularProgressIndicatorState._strokeTailTween
              .evaluate(_controller),
          _CCircularProgressIndicatorState._offsetTween.evaluate(_controller),
          _CCircularProgressIndicatorState._rotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget _buildMaterialIndicator(BuildContext context, double headValue,
      double tailValue, double offsetValue, double rotationValue) {
    final double? value = widget.value;
    final double arrowheadScale = value == null
        ? 0.0
        : const Interval(0.1, _strokeHeadInterval).transform(value);
    final double rotation;

    if (value == null && _lastValue == null) {
      rotation = 0.0;
    } else {
      rotation =
          math.pi * _additionalRotationTween.transform(value ?? _lastValue!);
    }

    Color valueColor = widget._getValueColor(context);
    final double opacity = valueColor.opacity;
    valueColor = valueColor.withOpacity(1.0);

    final Color backgroundColor = widget.backgroundColor ??
        ProgressIndicatorTheme.of(context).refreshBackgroundColor ??
        Theme.of(context).canvasColor;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        width: _indicatorSize,
        height: _indicatorSize,
        margin: const EdgeInsets.all(4.0), // accommodate the shadow
        child: Material(
          type: MaterialType.circle,
          color: backgroundColor,
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  painter: _RefreshCProgressIndicatorPainter(
                    valueColor: valueColor,
                    value: null, // Draw the indeterminate progress indicator.
                    headValue: headValue,
                    tailValue: tailValue,
                    offsetValue: offsetValue,
                    rotationValue: rotationValue,
                    strokeWidth: widget.strokeWidth,
                    arrowheadScale: arrowheadScale,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
