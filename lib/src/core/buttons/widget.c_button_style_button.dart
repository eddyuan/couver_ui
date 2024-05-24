// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:math';

// import 'package:couver_app/utils/helpers.dart';
import 'package:couver_ui/couver_ui.dart';
import 'package:couver_ui/src/core/painter/ext.shape_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// The base [StatefulWidget] class for buttons whose style is defined by a [CButtonStyle] object.
///
/// Concrete subclasses must override [defaultStyleOf] and [themeStyleOf].
///
/// See also:
///
///  * [TextButton], a simple CButtonStyleButton without a shadow.
///  * [ElevatedButton], a filled CButtonStyleButton whose material elevates when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
///

abstract class CButtonStyleButton extends ButtonStyleButton {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const CButtonStyleButton({
    super.key,
    required super.onPressed,
    required super.onLongPress,
    required super.onHover,
    required super.onFocusChange,
    CButtonStyle? style,
    required super.focusNode,
    required super.autofocus,
    required super.clipBehavior,
    super.statesController,
    super.isSemanticButton = true,
    required super.child,
    this.canRequestFocus,
    this.loading,
  })  : _cStyle = style,
        super(style: style);

  final CButtonStyle? _cStyle;
  final bool? canRequestFocus;

  @override
  CButtonStyle? get style => _cStyle;

  /// Show a loading
  final bool? loading;

  PlatformStyle get platformStyle => style?.platformStyle ?? PlatformStyle.auto;
  bool get shrinkWhenLoading => style?.shrinkWhenLoading ?? false;

  @override
  @protected
  CButtonStyle defaultStyleOf(BuildContext context);

  @override
  @protected
  CButtonStyle? themeStyleOf(BuildContext context);

  bool get isLoading => loading ?? false;

  @override
  bool get enabled => !isLoading && (onPressed != null || onLongPress != null);

  @override
  State<CButtonStyleButton> createState() => _CButtonStyleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(
        DiagnosticsProperty<CButtonStyle>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
  }

  /// Returns null if [value] is null, otherwise `MaterialStateProperty.all<T>(value)`.
  ///
  /// A convenience method for subclasses.
  static MaterialStateProperty<T>? allOrNull<T>(T? value) =>
      value == null ? null : MaterialStatePropertyAll<T>(value);

  /// Returns an interpolated value based on the [textScaleFactor] parameter:
  ///
  ///  * 0 - 1 [geometry1x]
  ///  * 1 - 2 lerp([geometry1x], [geometry2x], [textScaleFactor] - 1)
  ///  * 2 - 3 lerp([geometry2x], [geometry3x], [textScaleFactor] - 2)
  ///  * otherwise [geometry3x]
  ///
  /// A convenience method for subclasses.
  static EdgeInsetsGeometry scaledPadding(
    EdgeInsetsGeometry geometry1x,
    EdgeInsetsGeometry geometry2x,
    EdgeInsetsGeometry geometry3x,
    double fontSizeMultiplier,
  ) {
    return switch (fontSizeMultiplier) {
      <= 1 => geometry1x,
      < 2 => EdgeInsetsGeometry.lerp(
          geometry1x, geometry2x, fontSizeMultiplier - 1)!,
      < 3 => EdgeInsetsGeometry.lerp(
          geometry2x, geometry3x, fontSizeMultiplier - 2)!,
      _ => geometry3x,
    };
  }
}

/// The base [State] class for buttons whose style is defined by a [CButtonStyle] object.
///
/// See also:
///
///  * [CButtonStyleButton], the [StatefulWidget] subclass for which this class is the [State].
///  * [TextButton], a simple button without a shadow.
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
class _CButtonStyleState extends State<CButtonStyleButton>
    with TickerProviderStateMixin {
  AnimationController? controller;
  double? elevation;
  Color? backgroundColor;
  MaterialStatesController? internalStatesController;

  void handleStatesControllerChange() {
    // Force a rebuild to resolve MaterialStateProperty properties
    setState(() {});
  }

  MaterialStatesController get statesController =>
      widget.statesController ?? internalStatesController!;

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = MaterialStatesController();
    }
    statesController.update(MaterialState.disabled, !widget.enabled);
    statesController.addListener(handleStatesControllerChange);
    if (widget.platformStyle.isIos) {
      _initCupertinoAnimation();
    }
  }

  // Cupertino animation =======================================================

  // static const Duration kFadeOutDuration = Duration.zero;
  final Duration _cupertinoFadeInDuration = const Duration(milliseconds: 600);
  final Tween<double> _cupertinoOpacityTween = Tween<double>(begin: 1.0);

  AnimationController? _cupertinoAnimationController;
  Animation<double>? _cupertinoOpacityAnimation;

  void _setTween() {
    _cupertinoOpacityTween.end = 0.4;
  }

  bool _cupertinoButtonHeldDown = false;

  void _doCupertinoAnimate(bool val) {
    _cupertinoButtonHeldDown = val;
    _cupertinoAnimate();
  }

  void _cupertinoAnimate() {
    if (_cupertinoAnimationController != null) {
      if (_cupertinoButtonHeldDown) {
        _cupertinoAnimationController!.value = 1.0;
      } else {
        _cupertinoAnimationController!.animateTo(0.0,
            duration: _cupertinoFadeInDuration, curve: Curves.decelerate);
      }
    }
  }

  void _initCupertinoAnimation() {
    _cupertinoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _cupertinoOpacityAnimation = _cupertinoAnimationController!
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_cupertinoOpacityTween);
    _setTween();
  }

  //=======================================================

  @override
  void initState() {
    super.initState();
    initStatesController();
  }

  @override
  void didUpdateWidget(CButtonStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      initStatesController();
    }
    if (widget.enabled != oldWidget.enabled) {
      statesController.update(MaterialState.disabled, !widget.enabled);
      if (!widget.enabled) {
        // The button may have been disabled while a press gesture is currently underway.
        statesController.update(MaterialState.pressed, false);
      }
    }
  }

  @override
  void dispose() {
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    controller?.dispose();
    _cupertinoAnimationController?.dispose();
    super.dispose();
  }

  Widget buildChildWithLoading(
    BuildContext context, {
    required Widget childWidget,
    required Widget loadingWidget,
  }) {
    if (widget.shrinkWhenLoading) {
      return AnimatedSize(
        clipBehavior: Clip.none,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
        child: widget.isLoading ? loadingWidget : childWidget,
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: widget.isLoading ? 0 : 1,
          child: childWidget,
        ),
        if (widget.isLoading) loadingWidget,
      ],
    );
  }

  Widget buildLoadingWidget(
    BuildContext context, {
    required Size size,
    Color? color,
  }) {
    return SizedBox(
      // width: size.width,
      height: size.height,
      child: CouverTheme.of(context)
              .buttonLoadingBuilder
              ?.call(context, size, color) ??
          SizedBox.fromSize(
            size: size,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: (size.height / 6).ceilToDouble(),
              valueColor: AlwaysStoppedAnimation(color),
              backgroundColor: color?.withOpacity(0.1),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CButtonStyle? widgetStyle = widget.style;
    final CButtonStyle? themeStyle = widget.themeStyleOf(context);
    final CButtonStyle defaultStyle = widget.defaultStyleOf(context);

    T? effectiveValue<T>(T? Function(CButtonStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    T? resolve<T>(
        MaterialStateProperty<T>? Function(CButtonStyle? style) getProperty) {
      return effectiveValue(
        (CButtonStyle? style) =>
            getProperty(style)?.resolve(statesController.value),
      );
    }

    final double? resolvedElevation =
        resolve<double?>((CButtonStyle? style) => style?.elevation);

    final TextStyle? resolvedTextStyle =
        resolve<TextStyle?>((CButtonStyle? style) => style?.textStyle);

    // Extras
    final Gradient? resolvedBackgroundGradient =
        resolve<Gradient?>((CButtonStyle? style) => style?.backgroundGradient);
    final Gradient? resolvedForegroundGradient =
        resolve<Gradient?>((CButtonStyle? style) => style?.foregroundGradient);
    final Gradient? resolvedBorderGradient =
        resolve<Gradient?>((CButtonStyle? style) => style?.borderGradient);
    // End extras

    Color? resolvedBackgroundColor = resolvedBackgroundGradient != null
        ? Colors.transparent
        : resolve<Color?>((CButtonStyle? style) => style?.backgroundColor);

    final Color? resolvedForegroundColor =
        resolve<Color?>((CButtonStyle? style) => style?.foregroundColor);

    final Color? resolvedShadowColor =
        resolve<Color?>((CButtonStyle? style) => style?.shadowColor);

    final Color? resolvedSurfaceTintColor =
        resolve<Color?>((ButtonStyle? style) => style?.surfaceTintColor);

    final EdgeInsetsGeometry? resolvedPadding =
        resolve<EdgeInsetsGeometry?>((CButtonStyle? style) => style?.padding);

    final Size? resolvedMinimumSize =
        resolve<Size?>((CButtonStyle? style) => style?.minimumSize);

    final Size? resolvedFixedSize =
        resolve<Size?>((CButtonStyle? style) => style?.fixedSize);

    final Size? resolvedMaximumSize =
        resolve<Size?>((CButtonStyle? style) => style?.maximumSize);

    // final double resolvedLoadingSize = min(
    //     18,
    //     ((resolvedMinimumSize?.height ?? resolvedFixedSize?.hashCode ?? 20) -
    //         10));

    final Color? resolvedIconColor =
        resolve<Color?>((ButtonStyle? style) => style?.iconColor);

    final double resolvedIconSize =
        resolve<double?>((ButtonStyle? style) => style?.iconSize) ??
            min(
                18,
                ((resolvedMinimumSize?.height ??
                        resolvedFixedSize?.hashCode ??
                        20) -
                    10));

    final BorderSide? resolvedSide =
        resolve<BorderSide?>((CButtonStyle? style) => style?.side);

    final OutlinedBorder? resolvedShape =
        resolve<OutlinedBorder?>((CButtonStyle? style) => style?.shape);

    final MaterialStateMouseCursor mouseCursor = _MouseCursor(
      (Set<MaterialState> states) => effectiveValue(
          (CButtonStyle? style) => style?.mouseCursor?.resolve(states)),
    );

    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) => effectiveValue(
          (CButtonStyle? style) => style?.overlayColor?.resolve(states)),
    );

    final VisualDensity? resolvedVisualDensity =
        effectiveValue((CButtonStyle? style) => style?.visualDensity);
    final MaterialTapTargetSize? resolvedTapTargetSize =
        effectiveValue((CButtonStyle? style) => style?.tapTargetSize);
    final Duration? resolvedAnimationDuration =
        effectiveValue((CButtonStyle? style) => style?.animationDuration);
    final bool? resolvedEnableFeedback =
        effectiveValue((CButtonStyle? style) => style?.enableFeedback);
    final AlignmentGeometry? resolvedAlignment =
        effectiveValue((CButtonStyle? style) => style?.alignment);
    final Offset densityAdjustment = resolvedVisualDensity!.baseSizeAdjustment;
    final InteractiveInkFeatureFactory? resolvedSplashFactory =
        effectiveValue((CButtonStyle? style) => style?.splashFactory);
    final ButtonLayerBuilder? resolvedBackgroundBuilder =
        effectiveValue((ButtonStyle? style) => style?.backgroundBuilder);
    final ButtonLayerBuilder? resolvedForegroundBuilder =
        effectiveValue((ButtonStyle? style) => style?.foregroundBuilder);
    final Clip effectiveClipBehavior = widget.clipBehavior ??
        ((resolvedBackgroundBuilder ?? resolvedForegroundBuilder) != null
            ? Clip.antiAlias
            : Clip.none);
    BoxConstraints effectiveConstraints =
        resolvedVisualDensity.effectiveConstraints(
      BoxConstraints(
        minWidth: resolvedMinimumSize!.width,
        minHeight: resolvedMinimumSize.height,
        maxWidth: resolvedMaximumSize!.width,
        maxHeight: resolvedMaximumSize.height,
      ),
    );
    if (resolvedFixedSize != null) {
      final Size size = effectiveConstraints.constrain(resolvedFixedSize);
      if (size.width.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(
          minWidth: size.width,
          maxWidth: size.width,
        );
      }
      if (size.height.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(
          minHeight: size.height,
          maxHeight: size.height,
        );
      }
    }

    // Per the Material Design team: don't allow the VisualDensity
    // adjustment to reduce the width of the left/right padding. If we
    // did, VisualDensity.compact, the default for desktop/web, would
    // reduce the horizontal padding to zero.
    final double dy = densityAdjustment.dy;
    final double dx = math.max(0, densityAdjustment.dx);
    final EdgeInsetsGeometry padding = resolvedPadding!
        .add(EdgeInsets.fromLTRB(dx, dy, dx, dy))
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    // If an opaque button's background is becoming translucent while its
    // elevation is changing, change the elevation first. Material implicitly
    // animates its elevation but not its color. SKIA renders non-zero
    // elevations as a shadow colored fill behind the Material's background.
    if (resolvedAnimationDuration! > Duration.zero &&
        elevation != null &&
        backgroundColor != null &&
        elevation != resolvedElevation &&
        backgroundColor!.value != resolvedBackgroundColor!.value &&
        backgroundColor!.opacity == 1 &&
        resolvedBackgroundColor.opacity < 1 &&
        resolvedElevation == 0) {
      if (controller?.duration != resolvedAnimationDuration) {
        controller?.dispose();
        controller = AnimationController(
          duration: resolvedAnimationDuration,
          vsync: this,
        )..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {}); // Rebuild with the final background color.
            }
          });
      }

      // Defer changing the background color.
      resolvedBackgroundColor = backgroundColor;
      controller!.value = 0;
      controller!.forward();
    }
    elevation = resolvedElevation;
    backgroundColor = resolvedBackgroundColor;

    // OutlinedBorder inkShape = resolvedShape!;

    final OutlinedBorder shapeWithBorder =
        resolvedShape!.copyWith(side: resolvedSide);

    final ShapeBorder shapeWithGradientBorder =
        shapeWithBorder.copyWithGradient(resolvedBorderGradient);

    BorderRadiusGeometry? borderRadius;
    if (resolvedShape is RoundedRectangleBorder) {
      borderRadius = resolvedShape.borderRadius;
    } else if (resolvedShape is StadiumBorder ||
        resolvedShape is CircleBorder) {
      borderRadius = const BorderRadius.all(Radius.circular(9999));
    }

    final Widget customChild = buildChildWithLoading(
      context,
      childWidget: resolvedForegroundGradient != null
          ? ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  resolvedForegroundGradient.createShader(
                Rect.fromLTWH(
                  0,
                  0,
                  bounds.width,
                  bounds.height,
                ),
              ),
              child: widget.child,
            )
          : (widget.child ?? const SizedBox.shrink()),
      loadingWidget: buildLoadingWidget(context,
          size: Size(resolvedIconSize, resolvedIconSize),
          color: resolvedForegroundColor),
    );

    Widget effectiveChild = Padding(
      padding: padding,
      child: Align(
        alignment: resolvedAlignment!,
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: resolvedForegroundBuilder != null
            ? resolvedForegroundBuilder(
                context, statesController.value, customChild)
            : customChild,
      ),
    );
    if (resolvedBackgroundBuilder != null) {
      effectiveChild = resolvedBackgroundBuilder(
          context, statesController.value, effectiveChild);
    }

    final Widget result = ConstrainedBox(
      constraints: effectiveConstraints,
      child: FadeTransition(
        opacity: _cupertinoOpacityAnimation ??
            const AlwaysStoppedAnimation<double>(1),
        child: Material(
          elevation: resolvedElevation!,
          textStyle:
              resolvedTextStyle?.copyWith(color: resolvedForegroundColor),
          shape: shapeWithGradientBorder,
          color: resolvedBackgroundColor,
          shadowColor: resolvedShadowColor,
          surfaceTintColor: resolvedSurfaceTintColor,
          type: resolvedBackgroundColor == null
              ? MaterialType.transparency
              : MaterialType.button,
          animationDuration: resolvedAnimationDuration,
          clipBehavior: effectiveClipBehavior,
          // clipBehavior:
          //     borderRadius == null ? Clip.antiAlias : widget.clipBehavior,
          child: Ink(
            decoration: resolvedBackgroundGradient != null
                ? BoxDecoration(
                    gradient: resolvedBackgroundGradient,
                    borderRadius: borderRadius,
                  )
                : null,
            child: InkWell(
              onTap: widget.enabled ? widget.onPressed : null,
              onLongPress: widget.enabled ? widget.onLongPress : null,
              onHighlightChanged:
                  widget.platformStyle.isIos ? _doCupertinoAnimate : null,
              onHover: widget.onHover,
              mouseCursor: mouseCursor,
              enableFeedback: resolvedEnableFeedback,
              focusNode: widget.focusNode,
              canRequestFocus: widget.canRequestFocus ?? widget.enabled,
              onFocusChange: widget.onFocusChange,
              autofocus: widget.autofocus,
              splashFactory: widget.platformStyle.isIos
                  ? NoSplash.splashFactory
                  : resolvedSplashFactory,
              overlayColor: widget.platformStyle.isIos
                  ? MaterialStateProperty.all(Colors.transparent)
                  : overlayColor,
              highlightColor: Colors.transparent,
              customBorder: shapeWithBorder,
              statesController: statesController,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: resolvedIconColor ?? resolvedForegroundColor,
                  size: resolvedIconSize,
                ),
                child: effectiveChild,
              ),
            ),
          ),
        ),
      ),
    );

    final Size minSize;
    switch (resolvedTapTargetSize!) {
      case MaterialTapTargetSize.padded:
        minSize = Size(
          kMinInteractiveDimension + densityAdjustment.dx,
          kMinInteractiveDimension + densityAdjustment.dy,
        );
        assert(minSize.width >= 0.0);
        assert(minSize.height >= 0.0);
      // break;
      case MaterialTapTargetSize.shrinkWrap:
        minSize = Size.zero;
      // break;
    }

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: _InputPadding(
        minSize: minSize,
        child: result,
      ),
    );
  }
}

class _MouseCursor extends MaterialStateMouseCursor {
  const _MouseCursor(this.resolveCallback);

  final MaterialPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<MaterialState> states) => resolveCallback(states)!;

  @override
  String get debugDescription => 'CButtonStyleButton_MouseCursor';
}

/// A widget to pad the area around a [MaterialButton]'s inner [Material].
///
/// Redirect taps that occur in the padded area around the child to the center
/// of the child. This increases the size of the button and the button's
/// "tap target", but not its material or its ink splashes.
class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({
    super.child,
    required this.minSize,
  });

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox? child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) return;
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  Size _computeSize({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double height = math.max(childSize.width, minSize.width);
      final double width = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(height, width));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset =
          Alignment.center.alongOffset(size - child!.size as Offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final Offset center = child!.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == center);
        return child!.hitTest(result, position: center);
      },
    );
  }
}
