import 'package:couver_ui/couver_util.dart';
import "package:flutter/material.dart";

import 'theme.couver_theme.dart';
import '../enums/enum.platform_style.dart';
import 'widget.c_elevated_button.dart';
import 'widget.c_icon_button.dart';
import 'widget.c_outlined_button.dart';
import 'widget.c_text_button.dart';

class BtnSize {
  const BtnSize({
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    double? minWidth,
    this.minHeight = 38,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
  }) : minWidth = minWidth ?? minHeight;

  final EdgeInsets padding;
  final double minWidth;
  final double minHeight;
  final double fontSize;
  final FontWeight fontWeight;

  static const BtnSize xl = BtnSize(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    minHeight: 56,
    fontSize: 18,
  );
  static const BtnSize lg = BtnSize(
    minHeight: 48,
  );
  static const BtnSize md = BtnSize(
    minHeight: 44,
  );
  static const BtnSize df = BtnSize();
  static const BtnSize sm = BtnSize(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    minHeight: 32,
    fontSize: 14,
  );
  static const BtnSize xs = BtnSize(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    minHeight: 28,
    fontSize: 13,
  );
  static const BtnSize mini = BtnSize(
    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    minHeight: 20,
    fontSize: 13,
  );
  static const BtnSize input = BtnSize(
    minHeight: 60,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  static const BtnSize inputDense = BtnSize(
    minHeight: 54,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  static const BtnSize iconButton = BtnSize(
    minHeight: kMinInteractiveDimension,
  );
  static const BtnSize fitContent = BtnSize(
    minHeight: 0,
    padding: EdgeInsets.zero,
  );
  BtnSize copyWith({
    EdgeInsets? padding,
    double? minWidth,
    double? minHeight,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return BtnSize(
      padding: padding ?? this.padding,
      minWidth: minWidth ?? minHeight ?? this.minWidth,
      minHeight: minHeight ?? minWidth ?? this.minHeight,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}

enum _ButtonType {
  text,
  filled,
  outlined,
  icon,
  input,
}

class CButton extends StatelessWidget {
  const CButton({
    Key? key,
    this.child,
    // this.padding,
    this.margin,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.disabledColor,
    this.text,
    this.size = BtnSize.df,
    this.round = true,
    this.platformStyle = PlatformStyle.cupertino,
    this.onPressed,
    this.shrinkWhenLoading,
    this.tapTargetSize,
  })  : borderColor = null,
        splashRadius = null,
        _type = _ButtonType.text,
        borderwidth = 0,
        icon = null,
        super(key: key);

  const CButton.filled({
    Key? key,
    this.child,
    // this.padding,
    this.margin,
    // this.pressedOpacity,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.disabledColor,
    this.text,
    this.size = BtnSize.df,
    this.round = true,
    this.platformStyle = PlatformStyle.auto,
    this.onPressed,
    this.shrinkWhenLoading,
    this.tapTargetSize,
  })  : borderColor = null,
        splashRadius = null,
        _type = _ButtonType.filled,
        borderwidth = 0,
        icon = null,
        super(key: key);

  const CButton.outlined({
    Key? key,
    this.child,
    // this.padding,
    this.margin,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.disabledColor,
    this.text,
    this.size = BtnSize.df,
    this.round = true,
    this.platformStyle = PlatformStyle.auto,
    this.onPressed,
    this.borderwidth = 1,
    this.shrinkWhenLoading,
    this.tapTargetSize,
    this.borderColor,
  })  : splashRadius = null,
        _type = _ButtonType.outlined,
        icon = null,
        super(key: key);

  CButton.circle({
    Key? key,
    this.child,
    // this.padding,
    this.margin,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.disabledColor,
    this.text,
    double? size,
    this.platformStyle = PlatformStyle.auto,
    this.onPressed,
    this.splashRadius,
    this.icon,
    // this.tapTargetSize,
  })  : borderColor = null,
        _type = _ButtonType.icon,
        shrinkWhenLoading = false,
        round = true,
        borderwidth = 0,
        borderRadius = null,
        foregroundColor = null,
        backgroundColor = null,
        tapTargetSize = null,
        size = size != null ? BtnSize(minHeight: size) : BtnSize.iconButton,
        super(key: key);

  const CButton.input({
    Key? key,
    this.child,
    // this.padding,
    this.margin,
    // this.pressedOpacity,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.gradient,
    this.disabled = false,
    this.loading,
    this.color,
    this.foregroundColor,
    this.backgroundColor,
    this.disabledColor,
    this.text,
    // this.size,
    // this.minWidth,
    double? minHeight,
    this.round = true,
    this.platformStyle = PlatformStyle.auto,
    this.onPressed,
    this.borderwidth = 1,
    // this.fontSize,
    // this.fontWeight,
    // this.translucent,
    // this.circle = false,
    // this.filled = false,
    // this.circleSize,
    this.shrinkWhenLoading,
    this.tapTargetSize,
    this.borderColor,
    bool isDense = false,
  })  : splashRadius = null,
        size = isDense ? BtnSize.inputDense : BtnSize.input,
        _type = _ButtonType.input,
        icon = null,
        super(key: key);

  /// [child] will override [text]
  final Widget? child;

  // final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed;

  /// Define opacity when pressed for cupertino style
  // final double? pressedOpacity;

  /// Default = 200 when [round] is true, 8 when [round] = false
  final double? borderRadius;

  /// Alignment of the fitted text
  final AlignmentGeometry alignment;

  /// Background gradient for [filled], text and outline gradient for other
  final Gradient? gradient;
  final bool disabled;

  /// Will replace button content with a loading animation and disabled the button
  final bool? loading;

  final bool? shrinkWhenLoading;

  /// Background color for [filled], text and outline color for other
  final Color? color;

  /// Manually override foreground color (outltine and text color)
  final Color? foregroundColor;

  /// Manually override background color
  final Color? backgroundColor;

  /// This will be used for disabled color
  final Color? disabledColor;

  /// A simpler way to put text in a button
  final String? text;

  /// Defined the size and text size of the button
  final BtnSize size;

  /// A radius will be 200 if rounded, 8 if not
  final bool round;

  /// Define cupertino or material style
  final PlatformStyle platformStyle;

  /// Override the width of the outline
  final double borderwidth;

  /// For icon button only
  final double? splashRadius;

  final MaterialTapTargetSize? tapTargetSize;

  /// Gives border a different color
  final Color? borderColor;

  final IconData? icon;

  bool get enabled => (onPressed != null && !disabled && loading != true);

  final _ButtonType _type;

  @override
  Widget build(BuildContext context) {
    // final BtnSize targetBtnSize = size ;
    final double targetMinHeight = size.minHeight;
    final double targetMinWidth = size.minWidth;

    final double targetFontSize = size.fontSize;
    final FontWeight targetFontWeight = size.fontWeight;
    final TextStyle targetTextStyle = TextStyle(
      fontSize: targetFontSize,
      fontWeight: targetFontWeight,
    );

    final RoundedRectangleBorder? targetShape = borderRadius != null
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          )
        : !round
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            : null;

    final Widget targetChild = child ??
        ((text?.isNotEmpty ?? false)
            ? FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(text!),
              )
            : const SizedBox.shrink());

    final VoidCallback? targetOnPressed = disabled ? null : onPressed;

    final Size minimiumSize_ = Size(targetMinWidth, targetMinHeight);

    final EdgeInsetsGeometry targetPadding =
        (_type == _ButtonType.icon ? EdgeInsets.zero : size.padding);

    final MaterialTapTargetSize targetTapSize = tapTargetSize ??
        (targetMinHeight > 36
            ? MaterialTapTargetSize.padded
            : MaterialTapTargetSize.shrinkWrap);

    Color? targetBColor = backgroundColor;
    Color? targetFColor = foregroundColor;
    Color? targetDColor = disabledColor;

    if (_type == _ButtonType.filled) {
      targetBColor ??= color ?? gradient?.colors[0];
    } else {
      targetFColor ??= color ?? gradient?.colors[0];
    }

    if (targetBColor != null) {
      final int alpha = targetBColor.alpha;
      final bool isBDark = isDark(targetBColor);
      if (targetFColor == null) {
        if (isBDark) {
          if (alpha < 99) {
            targetFColor = targetBColor.withOpacity(1);
          }
        } else {
          if (alpha < 99) {
            targetFColor = targetBColor.withOpacity(1);
          } else {
            targetFColor = Theme.of(context).colorScheme.onSurface;
          }
        }
      }
      if (!isBDark && targetDColor == null) {
        targetDColor = Colors.white;
      }
    }

    if (targetFColor != null && targetDColor == null) {
      final bool isFDark = isDark(targetFColor);
      if (!isFDark) {
        targetDColor ??= Colors.white;
      }
    }

    final double? targetElevation =
        ((targetBColor?.alpha ?? 255) < 255) ? 0 : null;

    Widget buildIconButton(BuildContext context) {
      final double? minSize_ = size.minHeight;
      return CIconButton(
        loading: loading,
        icon: targetChild,
        onPressed: targetOnPressed,
        color: targetFColor,
        padding: targetPadding,
        constraints: minSize_ != null
            ? BoxConstraints(
                minWidth: targetMinWidth, minHeight: targetMinHeight)
            : null,
        platformStyle: platformStyle,
        splashRadius: splashRadius,
        disabledColor: targetDColor?.withOpacity(0.7),
      );
    }

    Widget buildElevatedButton(BuildContext context) {
      return CElevatedButton(
        loading: loading,
        onPressed: targetOnPressed,
        platformStyle: platformStyle,
        style: CElevatedButton.styleFrom(
          elevation: targetElevation,
          gradient: gradient,
          shape: targetShape,
          padding: targetPadding,
          minimumSize: minimiumSize_,
          textStyle: targetTextStyle,
          primary: targetBColor,
          onPrimary: targetFColor,
          onSurface: targetDColor,
          tapTargetSize: targetTapSize,
        ).copyWith(
          elevation: targetElevation != null
              ? MaterialStateProperty.all(targetElevation)
              : null,
        ),
        child: targetChild,
      );
    }

    Widget buildOutlinedButton(BuildContext context) {
      return COutlinedButton(
        loading: loading,
        onPressed: targetOnPressed,
        platformStyle: platformStyle,
        style: COutlinedButton.styleFrom(
          gradient: gradient,
          borderColor: borderColor,
          shape: targetShape,
          padding: targetPadding,
          minimumSize: minimiumSize_,
          textStyle: targetTextStyle,
          primary: targetFColor,
          onSurface: targetDColor,
          backgroundColor: targetBColor,
          side: BorderSide(
            width: borderwidth,
            color: foregroundColor ??
                color ??
                Theme.of(context).colorScheme.primary.withOpacity(0.9),
          ),
          tapTargetSize: targetTapSize,
        ),
        child: targetChild,
      );
    }

    Widget buildInputButton(BuildContext context) {
      return COutlinedButton(
        loading: loading,
        onPressed: targetOnPressed,
        platformStyle: platformStyle,
        style: COutlinedButton.styleFrom(
          gradient: gradient,
          borderColor: Theme.of(context).dividerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                CouverTheme.of(context).inputBorderRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CouverTheme.of(context).gutter * 3,
            vertical: CouverTheme.of(context).gutter * 2,
          ),
          minimumSize: Size(targetMinWidth, targetMinHeight),
          textStyle: Theme.of(context).textTheme.bodyText1!,
          primary: gradient?.colors[0] ?? foregroundColor ?? color,
          backgroundColor: backgroundColor,
          side: BorderSide(
            width: borderwidth,
            color: foregroundColor ??
                color ??
                Theme.of(context).colorScheme.primary.withOpacity(0.9),
          ),
          tapTargetSize: targetTapSize,
        ),
        child: targetChild,
      );
    }

    Widget buildTextButton(BuildContext context) {
      return CTextButton(
        loading: loading,
        onPressed: targetOnPressed,
        platformStyle: platformStyle,
        style: CTextButton.styleFrom(
          gradient: gradient,
          shape: targetShape,
          padding: targetPadding,
          minimumSize: minimiumSize_,
          textStyle: targetTextStyle,
          primary: color,
          backgroundColor: targetBColor,
          onSurface: targetDColor,
          tapTargetSize: targetTapSize,
        ),
        child: targetChild,
      );
    }

    Widget buildButton(BuildContext context) {
      switch (_type) {
        case _ButtonType.filled:
          return buildElevatedButton(context);
        case _ButtonType.icon:
          return buildIconButton(context);
        case _ButtonType.outlined:
          return buildOutlinedButton(context);
        case _ButtonType.input:
          return buildInputButton(context);
        default:
          return buildTextButton(context);
      }
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: buildButton(context),
    );
  }
}
