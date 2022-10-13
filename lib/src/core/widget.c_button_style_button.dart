// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

// import 'package:couver_app/utils/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../enums/enum.platform_style.dart';
import 'theme.c_button_style.dart';
import 'widget.c_border_painter.dart';

/// The base [StatefulWidget] class for buttons whose style is defined by a [CButtonStyle] object.
///
/// Concrete subclasses must override [defaultStyleOf] and [themeStyleOf].
///
/// See also:
///
///  * [TextButton], a simple CButtonStyleButton without a shadow.
///  * [ElevatedButton], a filled CButtonStyleButton whose material elevates when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
abstract class CButtonStyleButton extends StatefulWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const CButtonStyleButton({
    Key? key,
    required this.onPressed,
    required this.onLongPress,
    required this.onHover,
    required this.onFocusChange,
    required this.style,
    required this.focusNode,
    required this.autofocus,
    required this.clipBehavior,
    required this.child,
    this.platformStyle = PlatformStyle.auto,
    this.loading,
  }) : super(key: key);

  /// Define specific platform
  final PlatformStyle platformStyle;

  /// Show a loading
  final bool? loading;

  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onLongPress;

  /// Called when a pointer enters or exits the button response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  final ValueChanged<bool>? onHover;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// Customizes this button's appearance.
  ///
  /// Non-null properties of this style override the corresponding
  /// properties in [themeStyleOf] and [defaultStyleOf]. [MaterialStateProperty]s
  /// that resolve to non-null values will similarly override the corresponding
  /// [MaterialStateProperty]s in [themeStyleOf] and [defaultStyleOf].
  ///
  /// Null by default.
  final CButtonStyle? style;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Typically the button's label.
  final Widget? child;

  /// Returns a non-null [CButtonStyle] that's based primarily on the [Theme]'s
  /// [ThemeData.textTheme] and [ThemeData.colorScheme].
  ///
  /// The returned style can be overridden by the [style] parameter and
  /// by the style returned by [themeStyleOf]. For example the default
  /// style of the [TextButton] subclass can be overridden with its
  /// [TextButton.style] constructor parameter, or with a
  /// [TextButtonTheme].
  ///
  /// Concrete button subclasses should return a CButtonStyle that
  /// has no null properties, and where all of the [MaterialStateProperty]
  /// properties resolve to non-null values.
  ///
  /// See also:
  ///
  ///  * [themeStyleOf], Returns the CButtonStyle of this button's component theme.
  @protected
  CButtonStyle defaultStyleOf(BuildContext context);

  /// Returns the CButtonStyle that belongs to the button's component theme.
  ///
  /// The returned style can be overridden by the [style] parameter.
  ///
  /// Concrete button subclasses should return the CButtonStyle for the
  /// nearest subclass-specific inherited theme, and if no such theme
  /// exists, then the same value from the overall [Theme].
  ///
  /// See also:
  ///
  ///  * [defaultStyleOf], Returns the default [CButtonStyle] for this button.
  @protected
  CButtonStyle? themeStyleOf(BuildContext context);

  bool get isLoading => loading ?? false;

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => !isLoading && (onPressed != null || onLongPress != null);

  @override
  State<CButtonStyleButton> createState() => _ButtonStyleState();

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
      value == null ? null : MaterialStateProperty.all<T>(value);

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
    double textScaleFactor,
  ) {
    if (textScaleFactor <= 1) {
      return geometry1x;
    } else if (textScaleFactor >= 3) {
      return geometry3x;
    } else if (textScaleFactor <= 2) {
      return EdgeInsetsGeometry.lerp(
          geometry1x, geometry2x, textScaleFactor - 1)!;
    }
    return EdgeInsetsGeometry.lerp(
        geometry2x, geometry3x, textScaleFactor - 2)!;
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
class _ButtonStyleState extends State<CButtonStyleButton>
    with MaterialStateMixin, TickerProviderStateMixin {
  AnimationController? _controller;
  double? _elevation;
  Color? _backgroundColor;

  // static const Duration kSizeDuration = Duration(milliseconds: 200);
  // static const Duration kOpacityDuration = Duration(milliseconds: 2000);

  // Cupertino animation =======================================================

  // static const Duration kFadeOutDuration = Duration.zero;
  static const Duration kFadeInDuration = Duration(milliseconds: 600);
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
            duration: kFadeInDuration, curve: Curves.decelerate);
      }
      // if (_cupertinoAnimationController!.isAnimating) return;
      // final bool wasHeldDown = _cupertinoButtonHeldDown;
      // final TickerFuture ticker = _cupertinoButtonHeldDown
      //     ? _cupertinoAnimationController!.animateTo(1.0,
      //         duration: kFadeOutDuration, curve: Curves.decelerate)
      //     : _cupertinoAnimationController!
      //         .animateTo(0.0, duration: kFadeInDuration, curve: Curves.decelerate);
      // ticker.then<void>((void value) {
      //   if (mounted && wasHeldDown != _cupertinoButtonHeldDown) {
      //     _cupertinoAnimate();
      //   }
      // });
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
    setMaterialState(MaterialState.disabled, !widget.enabled);
    if (widget.platformStyle.isIos) {
      _initCupertinoAnimation();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _cupertinoAnimationController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CButtonStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    setMaterialState(MaterialState.disabled, !widget.enabled);
    // If the button is disabled while a press gesture is currently ongoing,
    // InkWell makes a call to handleHighlightChanged. This causes an exception
    // because it calls setState in the middle of a build. To preempt this, we
    // manually update pressed to false when this situation occurs.
    if (isDisabled && isPressed) {
      removeMaterialState(MaterialState.pressed);
    }
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
        (CButtonStyle? style) => getProperty(style)?.resolve(materialStates),
      );
    }

    // T? resolveActive<T>(
    //     MaterialStateProperty<T>? Function(CButtonStyle? style) getProperty) {
    //   return effectiveValue(
    //     (CButtonStyle? style) => getProperty(style)?.resolve(<MaterialState>{}),
    //   );
    // }

    final double? resolvedElevation =
        resolve<double?>((CButtonStyle? style) => style?.elevation);

    final TextStyle? resolvedTextStyle =
        resolve<TextStyle?>((CButtonStyle? style) => style?.textStyle);

    Color? resolvedBackgroundColor =
        resolve<Color?>((CButtonStyle? style) => style?.backgroundColor);

    final Gradient? resolvedBackgroundGradient = resolve<Gradient?>(
      (CButtonStyle? style) => style?.backgroundGradient,
    );

    final Gradient? resolvedForegroundGradient = resolve<Gradient?>(
      (CButtonStyle? style) => style?.foregroundGradient,
    );

    final Gradient? resolvedBorderGradient = resolve<Gradient?>(
      (CButtonStyle? style) => style?.borderGradient,
    );

    final Color? resolvedForegroundColor =
        resolve<Color?>((CButtonStyle? style) => style?.foregroundColor);

    final Color? resolvedShadowColor =
        resolve<Color?>((CButtonStyle? style) => style?.shadowColor);

    final EdgeInsetsGeometry? resolvedPadding =
        resolve<EdgeInsetsGeometry?>((CButtonStyle? style) => style?.padding);

    final Size? resolvedMinimumSize =
        resolve<Size?>((CButtonStyle? style) => style?.minimumSize);

    final Size? resolvedFixedSize =
        resolve<Size?>((CButtonStyle? style) => style?.fixedSize);

    final Size? resolvedMaximumSize =
        resolve<Size?>((CButtonStyle? style) => style?.maximumSize);

    // final Color? resolvedSideColor = resolve<Color?>(
    //   (CButtonStyle? style) => MaterialStateProperty.resolveWith(
    //     (states) {
    //       if (states.contains(MaterialState.disabled)) {
    //         return resolvedForegroundColor?.withOpacity(0.1);
    //       }
    //       return resolvedForegroundColor?.withOpacity(0.8);
    //     },
    //   ),
    // );

    // final BorderSide? resolvedSide =
    //     resolve<BorderSide?>((CButtonStyle? style) => style?.side)
    //         ?.copyWith(color: resolvedSideColor);
    final BorderSide? resolvedSide =
        resolve<BorderSide?>((CButtonStyle? style) => style?.side);

    final OutlinedBorder? resolvedShape =
        resolve<OutlinedBorder?>((CButtonStyle? style) => style?.shape);

    final MaterialStateMouseCursor resolvedMouseCursor = _MouseCursor(
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
        _elevation != null &&
        _backgroundColor != null &&
        _elevation != resolvedElevation &&
        _backgroundColor!.value != resolvedBackgroundColor!.value &&
        _backgroundColor!.opacity == 1 &&
        resolvedBackgroundColor.opacity < 1 &&
        resolvedElevation == 0) {
      if (_controller?.duration != resolvedAnimationDuration) {
        _controller?.dispose();
        _controller = AnimationController(
          duration: resolvedAnimationDuration,
          vsync: this,
        )..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {}); // Rebuild with the final background color.
            }
          });
      }

      // Defer changing the background color.
      resolvedBackgroundColor = _backgroundColor;
      _controller!.value = 0;
      _controller!.forward();
    }
    _elevation = resolvedElevation;
    _backgroundColor = resolvedBackgroundColor;

    TextStyle? textStyle =
        resolvedTextStyle?.copyWith(color: resolvedForegroundColor);

    OutlinedBorder inkShape = resolvedShape!;

    OutlinedBorder shape = inkShape.copyWith(side: resolvedSide);

    BorderRadiusGeometry? borderRadius;
    if (inkShape is RoundedRectangleBorder) {
      borderRadius = inkShape.borderRadius;
    }

    // Widget _animatedSize({required Widget child}) {
    //   if (widget.loading != null) {
    //     return AnimatedSize(
    //         duration: kSizeDuration, curve: Curves.ease, child: child);
    //   }
    //   return child;
    // }

    // Widget _gradientShader({Widget? child}) {
    //   if (child != null) {
    //     return resolvedForegroundGradient != null
    //         ? ShaderMask(
    //             blendMode: BlendMode.srcIn,
    //             shaderCallback: (bounds) =>
    //                 resolvedForegroundGradient.createShader(
    //               Rect.fromLTWH(0, 0, bounds.width, bounds.height),
    //             ),
    //             child: child,
    //           )
    //         : child;
    //   }
    //   return const SizedBox.shrink();
    // }

    final Widget result = ConstrainedBox(
      constraints: effectiveConstraints,
      child: FadeTransition(
        opacity: _cupertinoOpacityAnimation ??
            const AlwaysStoppedAnimation<double>(1),
        child: Material(
          elevation: resolvedElevation!,
          textStyle: textStyle,
          shape: inkShape.copyWith(side: BorderSide.none),
          color: resolvedBackgroundColor,
          shadowColor: resolvedShadowColor,
          // surfaceTintColor: Colors.red,
          type: resolvedBackgroundColor == null
              ? MaterialType.transparency
              : MaterialType.button,
          animationDuration: resolvedAnimationDuration,
          clipBehavior: Clip.hardEdge, // widget.clipBehavior,
          child: CBorderPainter(
            shape: shape,
            gradient: resolvedBorderGradient ?? resolvedForegroundGradient,
            child: Ink(
              decoration: BoxDecoration(
                gradient: resolvedBackgroundGradient,
                borderRadius: borderRadius,
              ),
              child: InkWell(
                onTap: widget.enabled ? widget.onPressed : null,
                onLongPress: widget.enabled ? widget.onLongPress : null,
                onHighlightChanged: updateMaterialState(
                  MaterialState.pressed,
                  onChanged:
                      widget.platformStyle.isIos ? _doCupertinoAnimate : null,
                ),
                onHover: widget.enabled
                    ? updateMaterialState(
                        MaterialState.hovered,
                        onChanged: widget.onHover,
                      )
                    : null,
                mouseCursor: resolvedMouseCursor,
                enableFeedback: resolvedEnableFeedback,
                focusNode: widget.focusNode,
                // canRequestFocus: widget.enabled,
                canRequestFocus: false, // widget.enabled,
                onFocusChange: updateMaterialState(
                  MaterialState.focused,
                  onChanged: widget.onFocusChange,
                ),
                autofocus: widget.autofocus,
                splashFactory: widget.platformStyle.isIos
                    ? NoSplash.splashFactory
                    : resolvedSplashFactory,
                overlayColor: widget.platformStyle.isIos
                    ? MaterialStateProperty.all(Colors.transparent)
                    : overlayColor,
                // highlightColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                customBorder: inkShape,
                child: IconTheme.merge(
                  data: IconThemeData(color: resolvedForegroundColor),
                  child: Padding(
                    padding: padding,
                    child: Align(
                      alignment: resolvedAlignment!,
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: widget.isLoading ? 0 : 1,
                            child: resolvedForegroundGradient != null
                                ? ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) =>
                                        resolvedForegroundGradient.createShader(
                                      Rect.fromLTWH(
                                          0, 0, bounds.width, bounds.height),
                                    ),
                                    child: widget.child,
                                  )
                                : widget.child,
                          ),
                          if (widget.isLoading)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(
                                    resolvedForegroundColor),
                                backgroundColor:
                                    resolvedForegroundColor?.withOpacity(0.1),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
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
        break;
      case MaterialTapTargetSize.shrinkWrap:
        minSize = Size.zero;
        break;
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
    Key? key,
    Widget? child,
    required this.minSize,
  }) : super(key: key, child: child);

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

  Size _computeSize(
      {required BoxConstraints constraints,
      required ChildLayouter layoutChild}) {
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
