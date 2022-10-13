import "package:flutter/material.dart";

import 'theme.couver_theme.dart';
import '../enums/enum.c_button.dart';
import '../enums/enum.platform_style.dart';
import 'widget.c_elevated_button.dart';
import 'widget.c_icon_button.dart';
import 'widget.c_outlined_button.dart';
import 'widget.c_text_button.dart';

class CButton extends StatelessWidget {
  const CButton({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.pressedOpacity,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.text,
    this.size,
    this.minWidth,
    this.minHeight,
    this.round = true,
    this.style = PlatformStyle.cupertino,
    this.onPressed,
    this.fontSize,
    this.fontWeight,
    this.translucent,
    this.borderwidth = 0,
    this.circle = false,
    this.filled = false,
    this.circleSize,
    this.sizeAnimation,
    this.tapTargetSize,
  })  : borderColor = null,
        splashRadius = null,
        restrictWidth = true,
        useInputStyle = false,
        super(key: key);

  const CButton.filled({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.pressedOpacity,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.text,
    this.size,
    this.minWidth,
    this.minHeight,
    this.round = true,
    this.style = PlatformStyle.auto,
    this.onPressed,
    this.fontSize,
    this.fontWeight,
    this.translucent,
    this.borderwidth = 0,
    this.circle = false,
    this.filled = true,
    this.circleSize,
    this.sizeAnimation,
    this.tapTargetSize,
  })  : borderColor = null,
        splashRadius = null,
        restrictWidth = true,
        useInputStyle = false,
        super(key: key);

  const CButton.outlined({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.pressedOpacity,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.text,
    this.size,
    this.minWidth,
    this.minHeight,
    this.round = true,
    this.style = PlatformStyle.auto,
    this.onPressed,
    this.borderwidth = 1,
    this.fontSize,
    this.fontWeight,
    this.translucent,
    this.circle = false,
    this.filled = false,
    this.circleSize,
    this.sizeAnimation,
    this.tapTargetSize,
    this.borderColor,
  })  : splashRadius = null,
        restrictWidth = true,
        useInputStyle = false,
        super(key: key);

  const CButton.circle({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.pressedOpacity,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.text,
    this.size,
    this.minWidth,
    this.minHeight,
    this.round = true,
    this.style = PlatformStyle.auto,
    this.onPressed,
    this.borderwidth = 0,
    this.fontSize,
    this.fontWeight,
    this.translucent,
    this.circle = true,
    this.filled = false,
    this.circleSize,
    this.sizeAnimation,
    this.splashRadius,
    this.restrictWidth = true,
    this.tapTargetSize,
  })  : borderColor = null,
        useInputStyle = false,
        super(key: key);

  const CButton.input({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.pressedOpacity,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.text,
    this.size,
    this.minWidth,
    double? minHeight,
    this.round = true,
    this.style = PlatformStyle.auto,
    this.onPressed,
    this.borderwidth = 1,
    this.fontSize,
    this.fontWeight,
    this.translucent,
    this.circle = false,
    this.filled = false,
    this.circleSize,
    this.sizeAnimation,
    this.tapTargetSize,
    this.borderColor,
    bool isDense = false,
  })  : splashRadius = null,
        restrictWidth = true,
        useInputStyle = true,
        minHeight = minHeight ?? (isDense ? 54 : 60),
        super(key: key);

  /// [child] will override [text]
  final Widget? child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed;

  /// Define opacity when pressed for cupertino style
  final double? pressedOpacity;

  /// Default = 200 when [round] is true, 8 when [round] = false
  final double? borderRadius;
  final AlignmentGeometry alignment;

  /// Background gradient for [filled], text and outline gradient for other
  final Gradient? gradient;
  final bool disabled;

  /// Will replace button content with a loading animation and disabled the button
  final bool? loading;

  final bool? sizeAnimation;

  /// Background color for [filled], text and outline color for other
  final Color? color;

  /// Manually override foreground color (outltine and text color)
  final Color? foregroundColor;

  /// Manually override background color
  final Color? backgroundColor;

  /// A simpler way to put text in a button
  final String? text;

  /// Defined the size and text size of the button
  final BtnSize? size;

  /// Manually set [minWidth], override size
  final double? minWidth;

  /// Manually set [minHeight], override size
  final double? minHeight;

  /// A radius will be 200 if rounded, 8 if not
  final bool round;

  /// Define cupertino or material style
  final PlatformStyle style;

  /// Override the width of the outline
  final double borderwidth;

  /// Override the fontSize of the text and icon
  final double? fontSize;

  /// Override the fontWeight of the text
  final FontWeight? fontWeight;

  /// Gives a solid background like ElevatedButton
  final bool filled;

  /// Gives a translucent background
  final double? translucent;

  /// Make the button a circle and 8dp larger in size, similar with icon button
  final bool circle;

  /// Set a fixed size for the circle
  final double? circleSize;

  /// For icon button only
  final double? splashRadius;

  /// For icon button only
  final bool restrictWidth;

  final MaterialTapTargetSize? tapTargetSize;

  /// Gives border a different color
  final Color? borderColor;

  final bool useInputStyle;

  bool get enabled => (onPressed != null && !disabled && loading != true);

  @override
  Widget build(BuildContext context) {
    final BtnSize btnSize_ = size ?? BtnSize.df;
    final double minHeight_ = minHeight ?? btnSize_.value;
    final double minWidth_ = minWidth ?? minHeight_;
    final double fontSize_ = fontSize ?? btnSize_.textSize;
    final FontWeight fontWeight_ = fontWeight ?? btnSize_.fontWeight;

    final RoundedRectangleBorder? shape_ = borderRadius != null
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          )
        : !round
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            : null;

    final Widget child_ = child ??
        ((text?.isNotEmpty ?? false)
            ? FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(text!),
              )
            : const SizedBox.shrink());

    final VoidCallback? onPressed_ = disabled ? null : onPressed;

    final TextStyle textStyle_ = TextStyle(
      fontSize: fontSize_,
      fontWeight: fontWeight_,
    );

    final Size minimiumSize_ = Size(minWidth_, minHeight_);

    final EdgeInsetsGeometry padding_ =
        padding ?? (circle ? EdgeInsets.zero : btnSize_.padding);

    final MaterialTapTargetSize tapTargetSize_ = tapTargetSize ??
        (minHeight_ > 36
            ? MaterialTapTargetSize.padded
            : MaterialTapTargetSize.shrinkWrap);

    Widget inner_;

    if (circle) {
      double? minSize_ = minWidth ?? minHeight;
      inner_ = CIconButton(
        loading: loading,
        icon: child_,
        onPressed: onPressed_,
        color: color,
        padding: padding_,
        constraints: minSize_ != null
            ? BoxConstraints(minWidth: minSize_, minHeight: minSize_)
            : null,
        platformStyle: style,
        splashRadius: splashRadius,
      );
    } else if (filled) {
      Color? color_ = color;
      if (translucent != null) {
        color_ = color?.withOpacity(translucent!);
      }
      inner_ = CElevatedButton(
        loading: loading,
        onPressed: onPressed_,
        platformStyle: style,
        style: CElevatedButton.styleFrom(
          gradient: gradient,
          shape: shape_,
          padding: padding_,
          minimumSize: minimiumSize_,
          textStyle: textStyle_,
          primary: color_ ?? color,
          onPrimary: translucent != null ? color : null,
          tapTargetSize: tapTargetSize_,
        ),
        child: child_,
      );
    } else if (borderwidth > 0) {
      if (useInputStyle) {
        inner_ = COutlinedButton(
          loading: loading,
          onPressed: onPressed_,
          platformStyle: style,
          style: COutlinedButton.styleFrom(
            gradient: gradient,
            borderColor: Theme.of(context).dividerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  CouverTheme.of(context).inputBorderRadius),
            ),
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: CouverTheme.of(context).gutter * 3,
                  vertical: CouverTheme.of(context).gutter * 2,
                ),
            minimumSize: Size(minWidth ?? minHeight ?? 58, minHeight ?? 58),
            textStyle: Theme.of(context).textTheme.bodyText1!,
            primary: gradient?.colors[0] ?? foregroundColor ?? color,
            backgroundColor: backgroundColor,
            side: BorderSide(
              width: borderwidth,
              color: foregroundColor ??
                  color ??
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ),
            tapTargetSize: tapTargetSize_,
          ),
          child: child_,
        );
      } else {
        inner_ = COutlinedButton(
          loading: loading,
          onPressed: onPressed_,
          platformStyle: style,
          style: COutlinedButton.styleFrom(
            gradient: gradient,
            borderColor: borderColor,
            shape: shape_,
            padding: padding_,
            minimumSize: minimiumSize_,
            textStyle: textStyle_,
            primary: gradient?.colors[0] ?? foregroundColor ?? color,
            backgroundColor: backgroundColor,
            side: BorderSide(
              width: borderwidth,
              color: foregroundColor ??
                  color ??
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ),
            tapTargetSize: tapTargetSize_,
          ),
          child: child_,
        );
      }
    } else {
      inner_ = CTextButton(
        loading: loading,
        onPressed: onPressed_,
        platformStyle: style,
        style: CTextButton.styleFrom(
          gradient: gradient,
          shape: shape_,
          padding: padding_,
          minimumSize: minimiumSize_,
          textStyle: textStyle_,
          primary: color,
          tapTargetSize: tapTargetSize_,
        ),
        child: child_,
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: inner_,
    );
  }
}
