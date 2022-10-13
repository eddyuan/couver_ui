import "package:flutter/material.dart";

import 'comp.gradient_box_border.dart';
import '../enums/enum.platform_style.dart';
import 'widget.c_ink_cupertino.dart';
import 'widget.c_ink_material.dart';

export "widget.c_ink_cupertino.dart";
export "widget.c_ink_material.dart";

class CInk extends StatelessWidget {
  const CInk({
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
    Key? key,
  }) : super(key: key);
  final Widget? child;

  /// Define with sctyl, [Cupertino] or [Material]
  final PlatformStyle style;
  // basic dunction
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

  BoxBorder? getTargetBorder(BuildContext context) {
    if (borderWidth > 0) {
      if (borderGradient != null) {
        return GradientBoxBorder(
          gradient: borderGradient,
          width: borderWidth,
        );
      }

      return Border.all(color: borderColor ?? Theme.of(context).dividerColor);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Decoration targetDecoration = BoxDecoration(
      gradient: gradient,
      color: color,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      image: decorationImage,
      border: getTargetBorder(context),
    );
    // final BoxBorder? targetBorder = borderWidth>0?
    // (borderGradient!=null? GradientBoxBorder(
    //       gradient: borderGradient,
    //       width: borderWidth,
    //     ) : borderColor!=null? Border.all(color: borderColor??Theme.of(context).dividerColor, width: borderWidth,):null)
    //  :null
    // final Widget child_ = Container(
    //   clipBehavior: clipBehavior,
    //   decoration: targetDecoration,
    //   child: child,
    // );

    if (style.isIos) {
      return CInkCupertino(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        onTapCancel: onTapCancel,
        borderRadius: borderRadius,
        cupertinoOption: cupertinoOption ?? const CInkCupertinoOption(),
        clipBehavior: clipBehavior,
        decoration: targetDecoration,
        child: child,
      );
    }
    return CInkMaterial(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      borderRadius: borderRadius,
      materialOption: materialOption ?? const CInkMaterialOption(),
      clipBehavior: clipBehavior,
      decoration: targetDecoration,
      child: child,
    );
  }
}
