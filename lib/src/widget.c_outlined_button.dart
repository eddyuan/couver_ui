// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:couver_ui/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'enums/enum.platform_style.dart';
import 'theme.c_button_style.dart';
import 'widget.c_button_style_button.dart';

/// A Material Design "Outlined Button"; essentially a [TextButton]
/// with an outlined border.
///
/// Outlined buttons are medium-emphasis buttons. They contain actions
/// that are important, but they aren’t the primary action in an app.
///
/// An outlined button is a label [child] displayed on a (zero
/// elevation) [Material] widget. The label's [Text] and [Icon]
/// widgets are displayed in the [style]'s
/// [CButtonStyle.foregroundColor] and the outline's weight and color
/// are defined by [CButtonStyle.side].  The button reacts to touches
/// by filling with the [style]'s [CButtonStyle.overlayColor].
///
/// The outlined button's default style is defined by [defaultStyleOf].
/// The style of this outline button can be overridden with its [style]
/// parameter. The style of all text buttons in a subtree can be
/// overridden with the [OutlinedButtonTheme] and the style of all of the
/// outlined buttons in an app can be overridden with the [Theme]'s
/// [ThemeData.outlinedButtonTheme] property.
///
/// Unlike [TextButton] or [ElevatedButton], outline buttons have a
/// default [CButtonStyle.side] which defines the appearance of the
/// outline.  Because the default `side` is non-null, it
/// unconditionally overrides the shape's [OutlinedBorder.side]. In
/// other words, to specify an outlined button's shape _and_ the
/// appearance of its outline, both the [CButtonStyle.shape] and
/// [CButtonStyle.side] properties must be specified.
///
/// {@tool dartpad}
/// Here is an example of a basic [COutlinedButton].
///
/// ** See code in examples/api/lib/material/outlined_button/outlined_button.0.dart **
/// {@end-tool}
///
/// The static [styleFrom] method is a convenient way to create a
/// outlined button [CButtonStyle] from simple values.
///
/// See also:
///
///  * [ElevatedButton], a filled material design button with a shadow.
///  * [TextButton], a material design button without a shadow.
///  * <https://material.io/design/components/buttons.html>
class COutlinedButton extends CButtonStyleButton {
  /// Create an COutlinedButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const COutlinedButton({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    CButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
    PlatformStyle platformStyle = PlatformStyle.auto,
    bool? loading,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child,
          platformStyle: platformStyle,
          loading: loading,
        );

  /// Create a text button from a pair of widgets that serve as the button's
  /// [icon] and [label].
  ///
  /// The icon and label are arranged in a row and padded by 12 logical pixels
  /// at the start, and 16 at the end, with an 8 pixel gap in between.
  ///
  /// The [icon] and [label] arguments must not be null.
  factory COutlinedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    CButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
    PlatformStyle platformStyle,
    bool? loading,
  }) = _COutlinedButtonWithIcon;

  /// A static convenience method that constructs an outlined button
  /// [CButtonStyle] given simple values.
  ///
  /// The [primary], and [onSurface] colors are used to create a
  /// [MaterialStateProperty] [CButtonStyle.foregroundColor] value in the same
  /// way that [defaultStyleOf] uses the [ColorScheme] colors with the same
  /// names. Specify a value for [primary] to specify the color of the button's
  /// text and icons as well as the overlay colors used to indicate the hover,
  /// focus, and pressed states. Use [onSurface] to specify the button's
  /// disabled text and icon color.
  ///
  /// Similarly, the [enabledMouseCursor] and [disabledMouseCursor]
  /// parameters are used to construct [CButtonStyle.mouseCursor].
  ///
  /// All of the other parameters are either used directly or used to
  /// create a [MaterialStateProperty] with a single value for all
  /// states.
  ///
  /// All parameters default to null, by default this method returns
  /// a [CButtonStyle] that doesn't override anything.
  ///
  /// For example, to override the default shape and outline for an
  /// [COutlinedButton], one could write:
  ///
  /// ```dart
  /// COutlinedButton(
  ///   style: COutlinedButton.styleFrom(
  ///      shape: StadiumBorder(),
  ///      side: BorderSide(width: 2, color: Colors.green),
  ///   ),
  /// )
  /// ```
  static CButtonStyle styleFrom({
    Gradient? gradient,
    Color? borderColor,
    Color? primary,
    Color? onSurface,
    Color? backgroundColor,
    Color? shadowColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    final Color? onSurface_ = onSurface ??
        ((primary != null && !CouverUtil.isDark(primary))
            ? Colors.white
            : null);

    final MaterialStateProperty<Color?>? foregroundColor =
        (onSurface_ == null && primary == null)
            ? null
            : _COutlinedButtonDefaultForeground(primary, onSurface_);

    final MaterialStateProperty<Gradient?>? foregroundAndBorderGradient =
        gradient == null ? null : _COutlinedButtonDefaultGradient(gradient);

    final MaterialStateProperty<Color?>? backgroundColor_ =
        backgroundColor == null
            ? null
            : _COutlinedButtonDefaultBackground(backgroundColor);

    final MaterialStateProperty<BorderSide?> side_ =
        _CElevatedButtonDefaultSide(side, borderColor ?? primary, onSurface_);

    final MaterialStateProperty<Color?>? overlayColor =
        (primary == null) ? null : _COutlinedButtonDefaultOverlay(primary);

    final MaterialStateProperty<MouseCursor>? mouseCursor =
        (enabledMouseCursor == null && disabledMouseCursor == null)
            ? null
            : _COutlinedButtonDefaultMouseCursor(
                enabledMouseCursor!, disabledMouseCursor!);

    return CButtonStyle(
      textStyle: CButtonStyleButton.allOrNull<TextStyle>(textStyle),
      foregroundColor: foregroundColor,
      foregroundGradient: foregroundAndBorderGradient,
      borderGradient: foregroundAndBorderGradient,
      backgroundColor: backgroundColor_,
      overlayColor: overlayColor,
      shadowColor: CButtonStyleButton.allOrNull<Color>(shadowColor),
      elevation: CButtonStyleButton.allOrNull<double>(elevation),
      padding: CButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: CButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: CButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: CButtonStyleButton.allOrNull<Size>(maximumSize),
      side: side_, //CButtonStyleButton.allOrNull<BorderSide>(side),
      shape: CButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: mouseCursor,
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
    );
  }

  /// Defines the button's default appearance.
  ///
  /// With the exception of [CButtonStyle.side], which defines the
  /// outline, and [CButtonStyle.padding], the returned style is the
  /// same as for [TextButton].
  ///
  /// The button [child]'s [Text] and [Icon] widgets are rendered with
  /// the [CButtonStyle]'s foreground color. The button's [InkWell] adds
  /// the style's overlay color when the button is focused, hovered
  /// or pressed. The button's background color becomes its [Material]
  /// color and is transparent by default.
  ///
  /// All of the CButtonStyle's defaults appear below. In this list
  /// "Theme.foo" is shorthand for `Theme.of(context).foo`. Color
  /// scheme values like "onSurface(0.38)" are shorthand for
  /// `onSurface.withOpacity(0.38)`. [MaterialStateProperty] valued
  /// properties that are not followed by a sublist have the same
  /// value for all states, otherwise the values are as specified for
  /// each state and "others" means all other states.
  ///
  /// The color of the [CButtonStyle.textStyle] is not used, the
  /// [CButtonStyle.foregroundColor] is used instead.
  ///
  /// * `textStyle` - Theme.textTheme.button
  /// * `backgroundColor` - transparent
  /// * `foregroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.38)
  ///   * others - Theme.colorScheme.primary
  /// * `overlayColor`
  ///   * hovered - Theme.colorScheme.primary(0.04)
  ///   * focused or pressed - Theme.colorScheme.primary(0.12)
  /// * `shadowColor` - Theme.shadowColor
  /// * `elevation` - 0
  /// * `padding`
  ///   * `textScaleFactor <= 1` - horizontal(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(horizontal(16), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  /// * `minimumSize` - Size(64, 36)
  /// * `fixedSize` - null
  /// * `maximumSize` - Size.infinite
  /// * `side` - BorderSide(width: 1, color: Theme.colorScheme.onSurface(0.12))
  /// * `shape` - RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
  /// * `mouseCursor`
  ///   * disabled - SystemMouseCursors.forbidden
  ///   * others - SystemMouseCursors.click
  /// * `visualDensity` - theme.visualDensity
  /// * `tapTargetSize` - theme.materialTapTargetSize
  /// * `animationDuration` - kThemeChangeDuration
  /// * `enableFeedback` - true
  /// * `alignment` - Alignment.center
  /// * `splashFactory` - InkRipple.splashFactory
  @override
  CButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsetsGeometry scaledPadding = CButtonStyleButton.scaledPadding(
      const EdgeInsets.symmetric(horizontal: 16),
      const EdgeInsets.symmetric(horizontal: 8),
      const EdgeInsets.symmetric(horizontal: 4),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );

    return styleFrom(
      primary: colorScheme.primary,
      onSurface: colorScheme.onSurface,
      backgroundColor: Colors.transparent,
      shadowColor: theme.shadowColor,
      elevation: 0,
      textStyle: theme.textTheme.button,
      padding: scaledPadding,
      minimumSize: const Size(64, 36),
      maximumSize: Size.infinite,
      side: BorderSide(
        color: colorScheme.primary.withOpacity(0.8),
        // color: theme.colorScheme.onSurface.withOpacity(0.12),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      enabledMouseCursor: SystemMouseCursors.click,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: Alignment.center,
      splashFactory: InkRipple.splashFactory,
    );
  }

  @override
  CButtonStyle? themeStyleOf(BuildContext context) {
    return OutlinedButtonTheme.of(context).style?.cButtonStyle;
  }
}

@immutable
class _CElevatedButtonDefaultSide extends MaterialStateProperty<BorderSide?>
    with Diagnosticable {
  _CElevatedButtonDefaultSide(this.side, this.primary, this.onSurface);

  final BorderSide? side;
  final Color? primary;
  final Color? onSurface;

  @override
  BorderSide? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      if (onSurface is Color) {
        if (side == null) {
          return BorderSide(
            color: onSurface!.withOpacity(0.2),
          );
        }
        return side?.copyWith(color: onSurface?.withOpacity(0.2));
      }
      return null;
    }
    if (primary is Color) {
      if (side == null) {
        return BorderSide(
          color: primary!,
        );
      }
      return side?.copyWith(color: primary!);
    }

    return side;
  }
}

@immutable
class _COutlinedButtonDefaultGradient extends MaterialStateProperty<Gradient?>
    with Diagnosticable {
  _COutlinedButtonDefaultGradient(this.gradient);

  final Gradient? gradient;

  @override
  Gradient? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return null;
    }
    return gradient;
  }
}

@immutable
class _COutlinedButtonDefaultForeground extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _COutlinedButtonDefaultForeground(this.primary, this.onSurface);

  final Color? primary;
  final Color? onSurface;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return onSurface?.withOpacity(0.38);
    }
    return primary;
  }
}

@immutable
class _COutlinedButtonDefaultBackground extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _COutlinedButtonDefaultBackground(this.backgroundColor);

  final Color? backgroundColor;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return null;
    }
    return backgroundColor;
  }
}

@immutable
class _COutlinedButtonDefaultOverlay extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _COutlinedButtonDefaultOverlay(this.primary);

  final Color primary;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return primary.withOpacity(0.04);
    }
    if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed)) {
      return primary.withOpacity(0.12);
    }
    return null;
  }
}

@immutable
class _COutlinedButtonDefaultMouseCursor
    extends MaterialStateProperty<MouseCursor> with Diagnosticable {
  _COutlinedButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return disabledCursor;
    return enabledCursor;
  }
}

class _COutlinedButtonWithIcon extends COutlinedButton {
  _COutlinedButtonWithIcon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    CButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
    PlatformStyle platformStyle = PlatformStyle.auto,
    bool? loading,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: _COutlinedButtonWithIconChild(icon: icon, label: label),
          platformStyle: platformStyle,
          loading: loading,
        );
}

class _COutlinedButtonWithIconChild extends StatelessWidget {
  const _COutlinedButtonWithIconChild({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final Widget label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
    final double gap =
        scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, SizedBox(width: gap), Flexible(child: label)],
    );
  }
}
