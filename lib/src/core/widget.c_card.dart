import "dart:io";
import 'theme.couver_theme.dart';
import "package:flutter/material.dart";

import '../enums/enum.platform_style.dart';
import '../utils/converts.dart';
import '../utils/utils.dart';
import 'widget.c_ink.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CCard extends StatelessWidget {
  const CCard({
    Key? key,
    this.child,
    this.padding,
    this.color,
    this.splashColor,
    this.highlightColor,
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
    this.childAlign = Alignment.center,
  }) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry? padding;

  /// The whole color of the card
  final Color? color;

  /// Color of the splash
  final Color? splashColor;

  /// Color of highlight
  final Color? highlightColor;

  final Gradient? gradient;

  /// Color of the leadingBar at the left
  final Color? leadingColor;

  /// Width of the leadingBar at the left
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

  final AlignmentGeometry childAlign;

  bool get hasAction =>
      onTap != null || onDoubleTap != null || onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);
    final CardTheme defaults = Theme.of(context).useMaterial3
        ? _CardDefaultsM3(context)
        : _CardDefaultsM2(context);

    final int targetElevation = elevation ?? (hasAction ? 4 : 0);
    final Color targetLeadingColor =
        leadingColor ?? Theme.of(context).dividerColor;
    final InteractiveInkFeatureFactory splashFactory = this.splashFactory ??
        (!kIsWeb && Platform.isIOS
            ? NoSplash.splashFactory
            : CouverTheme.of(context).splashFactory);
    final Color cardColor = color ?? Theme.of(context).cardColor;
    final Color targetSplashColor = splashColor ??
        (color == null
            ? Theme.of(context).splashColor
            : contrastColorTrans(cardColor));
    final Color targetHighlightColor = highlightColor ??
        (color == null
            ? Theme.of(context).highlightColor
            : contrastColorTrans(cardColor));
    final double targetLeadingWidth = leadingWidth ?? 0;

    final Color? targetShadowColor =
        shadowColor ?? cardTheme.shadowColor ?? defaults.shadowColor;

    final Color? finalShadowColor = targetShadowColor?.alpha == 0xFF
        ? targetShadowColor?.withOpacity(0.1)
        : targetShadowColor;

    final List<BoxShadow>? targetBoxShadow = boxShadow ??
        (targetElevation > 0 && finalShadowColor != null
            ? [
                BoxShadow(
                  color: finalShadowColor,
                  blurRadius: targetElevation * 3,
                  offset: Offset(0, targetElevation.toDouble()),
                ),
              ]
            : null);

    Widget innerContent;

    // Widget _innerContent() {
    if (targetLeadingWidth > 0) {
      innerContent = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: targetLeadingWidth,
              decoration: BoxDecoration(
                color: targetLeadingColor,
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

    BorderRadius? targetBorderRadius = borderRadius;
    if (targetBorderRadius == null) {
      if (cardTheme.shape is RoundedRectangleBorder) {
        final RoundedRectangleBorder borderShape =
            cardTheme.shape as RoundedRectangleBorder;
        targetBorderRadius =
            borderShape.borderRadius.resolve(Directionality.of(context));
      } else {
        targetBorderRadius = BorderRadius.circular(8);
      }
    }

    return SizedBox(
      width: width,
      height: height,
      child: CInk(
        onTap: onTap,
        style: platformStyle,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        borderRadius: targetBorderRadius,
        borderWidth: borderWidth,
        borderColor: borderColor,
        borderGradient: borderGradient,
        cupertinoOption: cupertinoOption,
        materialOption: materialOption ??
            CInkMaterialOption(
              highlightColor: targetHighlightColor,
              splashColor: targetSplashColor,
              inkOnTop: inkOnTop,
              splashFactory: splashFactory,
            ),
        boxShadow: targetBoxShadow,
        color: cardColor,
        gradient: gradient,
        decorationImage: decorationImage,
        clipBehavior: clipBehavior,
        child: Align(alignment: childAlign, child: innerContent),
      ),
    );
  }
}

class _CardDefaultsM3 extends CardTheme {
  const _CardDefaultsM3(this.context)
      : super(
          clipBehavior: Clip.none,
          elevation: 1.0,
          margin: const EdgeInsets.all(4.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0))),
        );

  final BuildContext context;

  @override
  Color? get color => Theme.of(context).colorScheme.surface;

  @override
  Color? get shadowColor => Theme.of(context).colorScheme.shadow;

  @override
  Color? get surfaceTintColor => Theme.of(context).colorScheme.surfaceTint;
}

class _CardDefaultsM2 extends CardTheme {
  const _CardDefaultsM2(this.context)
      : super(
            clipBehavior: Clip.none,
            elevation: 1.0,
            margin: const EdgeInsets.all(4.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ));

  final BuildContext context;

  @override
  Color? get color => Theme.of(context).cardColor;

  @override
  Color? get shadowColor => Theme.of(context).shadowColor;
}
