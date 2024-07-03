import 'package:couver_ui/src/core/_couver_internal.dart';
import "package:flutter/material.dart";

import 'comp.gradient_box_border.dart';
import '../enums/enum.platform_style.dart';
import 'widget.c_ink_cupertino.dart';
import 'widget.c_ink_material.dart';

export "widget.c_ink_cupertino.dart";
export "widget.c_ink_material.dart";

class CInk extends StatelessWidget {
  const CInk({
    super.key,
    this.child,
    this.style = PlatformStyle.auto,
    // basic function
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.cupertinoOption,
    this.materialOption,
    this.borderRadius,
    this.color,
    this.gradient,
    this.boxShadow,
    this.clipBehavior = Clip.none,
    this.borderColor,
    this.borderWidth = 0,
    this.borderGradient,
    this.decorationImage,
    this.autoRemoveFocus = true,
  });
  final Widget? child;

  /// Define with style, [Cupertino] or [Material]
  final PlatformStyle style;
  // basic duration
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;

  /// Option for Cupertino Styles. [Scale],[Shade],[Opaque] only available in cupertino
  final CInkCupertinoOption? cupertinoOption;

  /// Option for Material Styles. Material will show splash
  final CInkMaterialOption? materialOption;

  /// Defined the border radius for the container of splash and overlay
  final BorderRadius? borderRadius;

  /// Default is transparent
  final Color? color;

  final Gradient? gradient;

  /// Default is none
  final List<BoxShadow>? boxShadow;

  final Clip clipBehavior;

  /// Add a border to the thing
  final double borderWidth;

  /// Define border color
  final Color? borderColor;

  final Gradient? borderGradient;

  /// Background image
  final DecorationImage? decorationImage;

  /// Remove focus when tapped
  final bool autoRemoveFocus;

  BoxBorder? getTargetBorder(BuildContext context) {
    if (borderWidth > 0) {
      if (borderGradient != null) {
        return GradientBoxBorder(
          gradient: borderGradient,
          width: borderWidth,
        );
      }

      return Border.all(
        color: borderColor ?? Theme.of(context).dividerColor,
        width: borderWidth,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration targetDecoration = BoxDecoration(
      gradient: gradient,
      color: color,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      image: decorationImage,
      border: getTargetBorder(context),
    );

    late final Widget inkWidget;

    final BorderRadius? innerRadius = borderRadius != null
        ? CouverInternal.borderRadiusModifyBy(borderRadius!, -borderWidth)
        : null;

    if (style.isIos) {
      inkWidget = CInkCupertino(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        onTapCancel: onTapCancel,
        borderRadius: borderRadius,
        cupertinoOption: cupertinoOption ?? const CInkCupertinoOption(),
        clipBehavior: clipBehavior,
        decoration: targetDecoration,
        autoRemoveFocus: autoRemoveFocus,
        child: child,
      );
    } else {
      inkWidget = CInkMaterial(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        onTapCancel: onTapCancel,
        borderRadius: borderRadius,
        innerRadius: innerRadius,
        materialOption: materialOption ?? const CInkMaterialOption(),
        clipBehavior: clipBehavior,
        decoration: targetDecoration,
        autoRemoveFocus: autoRemoveFocus,
        child: child,
      );
    }
    return inkWidget;
  }
}
