import "dart:io";
import 'package:couver_ui/src/theme.couver_theme.dart';
import "package:flutter/material.dart";

import 'enums/enum.platform_style.dart';
import 'utils/converts.dart';
import 'utils/utils.dart';
import 'widget.c_ink.dart';

class CCard extends StatelessWidget {
  const CCard({
    Key? key,
    this.child,
    this.padding,
    this.color,
    this.gradient,
    this.leadingColor,
    this.leadingGradient,
    this.leadingWidth,
    this.borderRadius,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.splashFactory,
    this.elevation,
    this.shadowColor,
    this.height,
    this.width,
    this.inkOnTop = true,
    this.borderWidth = 0,
    this.borderColor,
    this.borderGradient,
    this.boxShadow,
    this.platformStyle = PlatformStyle.auto,
    this.decorationImage,
    this.clipBehavior = Clip.hardEdge,
    this.cupertinoOption,
    this.materialOption,
  }) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry? padding;

  /// The whole color of the card
  final Color? color;

  final Gradient? gradient;

  /// Color of the leadingBar at the left
  final Color? leadingColor;

  /// Width of the laeadingBar at the left
  final double? leadingWidth;

  /// Gradient of the leadingBar at the left
  final Gradient? leadingGradient;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  /// Only for material
  final InteractiveInkFeatureFactory? splashFactory;

  /// Default to 4 if [onTap] or [onDoubleTap] or [onLongPress] are specified.
  final int? elevation;
  final Color? shadowColor;
  final double? width;
  final double? height;
  final double borderWidth;
  final Color? borderColor;
  final Gradient? borderGradient;

  /// This will override the elevation value
  final List<BoxShadow>? boxShadow;

  /// This is for ink style
  final PlatformStyle platformStyle;

  /// this will put the splash on top and prevent touch on any other element within the card
  final bool inkOnTop;

  /// Background image
  final DecorationImage? decorationImage;

  final Clip clipBehavior;

  /// Option for Cupertino Styles. [Scale],[Shade],[Opaque] only available in cupertino
  final CInkCupertinoOption? cupertinoOption;

  /// Option for Material Styles. Material will show splash
  final CInkMaterialOption? materialOption;

  bool get hasAction =>
      onTap != null || onDoubleTap != null || onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final int targetElevation = elevation ?? (hasAction ? 4 : 0);
    final Color leadingColor =
        this.leadingColor ?? Theme.of(context).dividerColor;
    final InteractiveInkFeatureFactory splashFactory = this.splashFactory ??
        (Platform.isIOS
            ? NoSplash.splashFactory
            : CouverTheme.of(context).splashFactory);
    final Color cardColor = color ?? Theme.of(context).cardColor;
    final double leadingWidth = this.leadingWidth ?? 0;

    final Color contrastColor = contrastColorTrans(cardColor);
    final Color highlightColor = contrastColor;
    // splashFactory == NoSplash.splashFactory
    //     ? contrastColor
    //     : contrastColor; // Colors.transparent;

    final Color shadowColor =
        this.shadowColor ?? Theme.of(context).colorScheme.shadow;
    final List<BoxShadow>? targetBoxShadow = boxShadow ??
        (targetElevation > 0
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: targetElevation * 3,
                  offset: const Offset(0, 4),
                ),
              ]
            : null);

    Widget innerContent;

    // Widget _innerContent() {
    if (leadingWidth > 0) {
      innerContent = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: leadingWidth,
              decoration: BoxDecoration(
                color: leadingColor,
                gradient: leadingGradient,
              ),
            ),
            Expanded(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ),
          ],
        ),
      );
    } else {
      innerContent = Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: CInk(
        onTap: onTap,
        style: platformStyle,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        borderWidth: borderWidth,
        borderColor: borderColor,
        borderGradient: borderGradient,
        cupertinoOption: cupertinoOption,
        materialOption: materialOption ??
            CInkMaterialOption(
              highlightColor: highlightColor,
              splashColor: contrastColor,
              inkOnTop: inkOnTop,
              splashFactory: splashFactory,
            ),
        boxShadow: targetBoxShadow,
        color: cardColor,
        gradient: gradient,
        decorationImage: decorationImage,
        clipBehavior: clipBehavior,
        child: innerContent,
      ),
    );
  }
}
