import 'package:couver_ui/src/enums/enum.platform_style.dart';
import 'package:flutter/material.dart';

import 'widget.c_button.dart';

enum ButtonType {
  text,
  filled,
  outlined,
  icon,
}

class CButton2 extends StatelessWidget {
  const CButton2({
    super.key,
    this.type = ButtonType.text,
    this.child,
    // this.margin,
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
    this.borderColor,
    this.borderWidth = 0,
    this.splashRadius,
  });

  /// [child] will override [text]
  final Widget? child;

  // final EdgeInsetsGeometry? padding;
  // final EdgeInsetsGeometry? margin;
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

  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
