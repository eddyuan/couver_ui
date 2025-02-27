import 'package:couver_ui/src/core/_couver_internal.dart';
import "package:flutter/material.dart";

// import '../border/gradient_rounded_rectangle_border.dart';
import '../theme.couver_theme.dart';
import '../../enums/enum.platform_style.dart';
import 'widget.c_elevated_button.dart';
import 'widget.c_icon_button.dart';
import 'widget.c_outlined_button.dart';
import 'widget.c_text_button.dart';

Color? _getContrastThemeColor(
  Color color, {
  required ColorScheme scheme,
}) {
  if (color == scheme.primary) return scheme.onPrimary;
  if (color == scheme.primaryContainer) return scheme.onPrimaryContainer;
  // if (color == scheme.primaryFixed) return scheme.onPrimaryFixed;
  // if (color == scheme.primaryFixedDim) return scheme.onPrimaryFixedVariant;
  if (color == scheme.secondary) return scheme.onSecondary;
  if (color == scheme.secondaryContainer) return scheme.onSecondaryContainer;
  // if (color == scheme.secondaryFixed) return scheme.onSecondaryFixed;
  // if (color == scheme.secondaryFixedDim) return scheme.onSecondaryFixedVariant;
  if (color == scheme.tertiary) return scheme.onTertiary;
  if (color == scheme.tertiaryContainer) return scheme.onTertiaryContainer;
  // if (color == scheme.tertiaryFixed) return scheme.onTertiaryFixed;
  // if (color == scheme.tertiaryFixedDim) return scheme.onTertiaryFixedVariant;
  if (color == scheme.error) return scheme.onError;
  if (color == scheme.errorContainer) return scheme.onErrorContainer;
  if (color == scheme.surface) return scheme.onSurface;
  return null;
}

// enum CButtonType {
//   text,
//   filled,
//   outlined,
//   icon,
//   input,
//   tonal,
// }

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
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BtnSize &&
        other.padding == padding &&
        other.minWidth == minWidth &&
        other.minHeight == minHeight &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight;
  }

  @override
  int get hashCode =>
      Object.hash(padding, minWidth, minHeight, fontSize, fontWeight);
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
    super.key,
    this.child,
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
    this.iconLeft,
    this.iconRight,
    this.canRequestFocus,
  })  : borderColor = null,
        splashRadius = null,
        _type = _ButtonType.text,
        borderWidth = 0;

  const CButton.filled({
    super.key,
    this.child,
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
    this.shrinkWhenLoading,
    this.tapTargetSize,
    this.iconLeft,
    this.iconRight,
    this.canRequestFocus,
  })  : borderColor = null,
        splashRadius = null,
        _type = _ButtonType.filled,
        borderWidth = 0;

  const CButton.outlined({
    super.key,
    this.child,
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
    this.borderWidth = 1,
    this.shrinkWhenLoading,
    this.tapTargetSize,
    this.borderColor,
    this.iconLeft,
    this.iconRight,
    this.canRequestFocus,
  })  : splashRadius = null,
        _type = _ButtonType.outlined;

  CButton.circle({
    super.key,
    this.child,
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
    this.canRequestFocus,
    // this.icon,
  })  : borderColor = null,
        _type = _ButtonType.icon,
        shrinkWhenLoading = false,
        round = true,
        borderWidth = 0,
        borderRadius = null,
        foregroundColor = null,
        backgroundColor = null,
        tapTargetSize = null,
        size = size != null ? BtnSize(minHeight: size) : BtnSize.iconButton,
        iconLeft = null,
        iconRight = null;

  const CButton.input({
    super.key,
    this.child,
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
    double? minHeight,
    this.round = true,
    this.platformStyle = PlatformStyle.auto,
    this.onPressed,
    this.borderWidth = 1,
    this.shrinkWhenLoading,
    this.tapTargetSize,
    this.borderColor,
    bool isDense = false,
    this.canRequestFocus,
  })  : splashRadius = null,
        size = isDense ? BtnSize.inputDense : BtnSize.input,
        _type = _ButtonType.input,
        iconLeft = null,
        iconRight = null;

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

  /// Manually override foreground color (outline and text color)
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
  final double borderWidth;

  /// For icon button only
  final double? splashRadius;

  final MaterialTapTargetSize? tapTargetSize;

  /// Gives border a different color
  final Color? borderColor;

  final IconData? iconLeft;
  final IconData? iconRight;

  final bool? canRequestFocus;

  bool get enabled => (onPressed != null && !disabled && loading != true);

  final _ButtonType _type;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final BtnSize targetBtnSize = size ;
    final double targetMinHeight = size.minHeight;
    final double targetMinWidth = size.minWidth;
    final double targetFontSize = size.fontSize;
    final FontWeight targetFontWeight = size.fontWeight;

    TextStyle targetTextStyle = theme.textTheme.bodyMedium?.copyWith(
          fontSize: targetFontSize,
          fontWeight: targetFontWeight,
          height: 1.2,
        ) ??
        TextStyle(
          fontSize: targetFontSize,
          fontWeight: targetFontWeight,
          height: 1.2,
        );

    // switch (_type) {
    //   case _ButtonType.filled:

    //     break;
    //   default:
    // }

    final OutlinedBorder? targetShape = borderRadius != null
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (iconLeft != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          iconLeft,
                          size: targetFontSize + 2,
                        ),
                      ),
                    Text(text!),
                    if (iconRight != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(iconRight, size: targetFontSize + 2),
                      ),
                  ],
                ),
              )
            : const SizedBox.shrink());

    final VoidCallback? targetOnPressed = disabled ? null : onPressed;

    final Size targetMinSize = Size(targetMinWidth, targetMinHeight);

    final EdgeInsetsGeometry targetPadding =
        (_type == _ButtonType.icon ? EdgeInsets.zero : size.padding);

    final MaterialTapTargetSize targetTapSize = tapTargetSize ??
        (targetMinHeight > 36
            ? MaterialTapTargetSize.padded
            : MaterialTapTargetSize.shrinkWrap);

    Color? bColor = backgroundColor;
    Color? fColor = foregroundColor;
    Color? dColor = disabledColor;

    if (_type == _ButtonType.filled) {
      bColor ??=
          color ?? gradient?.colors.firstOrNull ?? theme.colorScheme.primary;
    } else {
      fColor ??= color ?? gradient?.colors.firstOrNull;
    }
    bool? isBDark;
    bool? isFDark;
    if (bColor != null) {
      final int alpha = bColor.alpha;
      isBDark = CouverInternal.isDark(bColor);
      fColor ??= _getContrastThemeColor(bColor, scheme: theme.colorScheme);
      if (fColor == null) {
        if (bColor == theme.colorScheme.primary) {
          fColor = theme.colorScheme.onPrimary;
        } else if (bColor == theme.colorScheme.primaryContainer) {
          fColor = theme.colorScheme.onPrimaryContainer;
        } else if (bColor == theme.colorScheme.error) {
          fColor = theme.colorScheme.onError;
        } else if (isBDark) {
          if (alpha < 99) {
            fColor = bColor.withOpacity(1);
          }
        } else {
          if (alpha < 99) {
            fColor = bColor.withOpacity(1);
          } else {
            fColor = Colors.black;
          }
        }
      }
    }

    if (fColor != null) {
      isFDark = CouverInternal.isDark(fColor);
    }

    if (color != null &&
        color != theme.colorScheme.primary &&
        isBDark == false &&
        isFDark == false &&
        dColor == null) {
      dColor = Colors.white;
    } else {
      dColor = Colors.black;
    }

    final double? targetElevation = ((bColor?.alpha ?? 255) < 255) ? 0 : null;

    Widget buildIconButton(BuildContext context) {
      return CIconButton(
        loading: loading,
        icon: targetChild,
        onPressed: targetOnPressed,
        color: fColor,
        padding: targetPadding,
        constraints: BoxConstraints(
          minWidth: targetMinWidth,
          minHeight: targetMinHeight,
        ),
        style: CIconButton.styleFrom(
          elevation: targetElevation,
          foregroundGradient: gradient,
          shape: targetShape,
          padding: targetPadding,
          minimumSize: targetMinSize,
          // textStyle: targetTextStyle,
          // backgroundColor: targetBColor,
          foregroundColor: fColor,
          backgroundColor: bColor,
          // disabledBackgroundColor: dColor,
          tapTargetSize: targetTapSize,
          platformStyle: platformStyle,
        ),
        splashRadius: splashRadius,
        disabledColor: dColor?.withOpacity(0.7),
        canRequestFocus: canRequestFocus,
      );
    }

    Widget buildElevatedButton(BuildContext context) {
      return CElevatedButton(
        loading: loading,
        onPressed: targetOnPressed,
        style: CElevatedButton.styleFrom(
          elevation: targetElevation,
          backgroundGradient: gradient,
          shape: targetShape,
          padding: targetPadding,
          minimumSize: targetMinSize,
          textStyle: targetTextStyle,
          backgroundColor: bColor,
          foregroundColor: fColor,
          disabledBackgroundColor: dColor?.withAlpha(20),
          disabledForegroundColor: dColor?.withAlpha(80),
          tapTargetSize: targetTapSize,
          platformStyle: platformStyle,
        ).copyWith(
          elevation: targetElevation != null
              ? MaterialStatePropertyAll(targetElevation)
              : null,
        ),
        canRequestFocus: canRequestFocus,
        child: targetChild,
      );
    }

    Widget buildOutlinedButton(BuildContext context) {
      return COutlinedButton(
        loading: loading,
        onPressed: targetOnPressed,
        style: COutlinedButton.styleFrom(
          borderGradient: gradient,
          foregroundGradient: gradient,
          // borderColor: borderColor,
          shape: targetShape,
          padding: targetPadding,
          minimumSize: targetMinSize,
          textStyle: targetTextStyle,
          foregroundColor: fColor,
          // disabledBackgroundColor: targetDColor,
          disabledForegroundColor: dColor?.withAlpha(80),
          backgroundColor: bColor,
          side: BorderSide(
            width: borderWidth,
            color: foregroundColor ??
                color ??
                Theme.of(context).colorScheme.primary.withOpacity(0.9),
          ),
          tapTargetSize: targetTapSize,
          platformStyle: platformStyle,
        ),
        canRequestFocus: canRequestFocus,
        child: targetChild,
      );
    }

    Widget buildInputButton(BuildContext context) {
      return COutlinedButton(
        loading: loading,
        onPressed: targetOnPressed,
        style: COutlinedButton.styleFrom(
          foregroundGradient: gradient,
          borderGradient: gradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              CouverTheme.of(context).inputBorderRadius,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CouverTheme.of(context).gutter * 3,
            vertical: CouverTheme.of(context).gutter * 2,
          ),
          minimumSize: Size(targetMinWidth, targetMinHeight),
          textStyle: Theme.of(context).textTheme.bodyLarge!,
          foregroundColor: gradient?.colors[0] ?? foregroundColor ?? color,
          backgroundColor: backgroundColor,
          side: BorderSide(
            width: borderWidth,
            color: Theme.of(context).dividerColor,
          ),
          tapTargetSize: targetTapSize,
          platformStyle: platformStyle,
        ),
        canRequestFocus: canRequestFocus,
        child: targetChild,
      );
    }

    Widget buildTextButton(BuildContext context) {
      return CTextButton(
        loading: loading,
        onPressed: targetOnPressed,
        style: CTextButton.styleFrom(
          foregroundGradient: gradient,
          shape: targetShape,
          padding: targetPadding,
          minimumSize: targetMinSize,
          textStyle: targetTextStyle,
          foregroundColor: fColor,
          backgroundColor: bColor,
          disabledForegroundColor: dColor?.withAlpha(80),
          // disabledForegroundColor: dColor?.withAlpha(20),
          tapTargetSize: targetTapSize,
          platformStyle: platformStyle,
        ),
        canRequestFocus: canRequestFocus,
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
