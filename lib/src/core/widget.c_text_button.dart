// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../enums/enum.platform_style.dart';
import 'theme.c_button_style.dart';
import 'widget.c_button_style_button.dart';

/// A Material Design "Text Button".
///
/// Use text buttons on toolbars, in dialogs, or inline with other
/// content but offset from that content with padding so that the
/// button's presence is obvious. Text buttons do not have visible
/// borders and must therefore rely on their position relative to
/// other content for context. In dialogs and cards, they should be
/// grouped together in one of the bottom corners. Avoid using text
/// buttons where they would blend in with other content, for example
/// in the middle of lists.
///
/// A text button is a label [child] displayed on a (zero elevation)
/// [Material] widget. The label's [Text] and [Icon] widgets are
/// displayed in the [style]'s [CButtonStyle.foregroundColor]. The
/// button reacts to touches by filling with the [style]'s
/// [CButtonStyle.backgroundColor].
///
/// The text button's default style is defined by [defaultStyleOf].
/// The style of this text button can be overridden with its [style]
/// parameter. The style of all text buttons in a subtree can be
/// overridden with the [TextButtonTheme] and the style of all of the
/// text buttons in an app can be overridden with the [Theme]'s
/// [ThemeData.textButtonTheme] property.
///
/// The static [styleFrom] method is a convenient way to create a
/// text button [CButtonStyle] from simple values.
///
/// If the [onPressed] and [onLongPress] callbacks are null, then this
/// button will be disabled, it will not react to touch.
///
/// {@tool dartpad}
/// This sample shows how to render a disabled CTextButton, an enabled CTextButton
/// and lastly a CTextButton with gradient background.
///
/// ** See code in examples/api/lib/material/text_button/text_button.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [OutlinedButton], a [CTextButton] with a border outline.
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * <https://material.io/design/components/buttons.html>
class CTextButton extends CButtonStyleButton {
  /// Create a CTextButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const CTextButton({
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
    bool? shrinkWhenLoading,
    // Gradient? backgroundGradient,
    // Gradient? foregroundGradient,
    // Gradient? borderGradient,
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
          shrinkWhenLoading: shrinkWhenLoading,
          // backgroundGradient: backgroundGradient,
          // foregroundGradient: foregroundGradient,
          // borderGradient: borderGradient,
        );

  /// Create a text button from a pair of widgets that serve as the button's
  /// [icon] and [label].
  ///
  /// The icon and label are arranged in a row and padded by 8 logical pixels
  /// at the ends, with an 8 pixel gap in between.
  ///
  /// The [icon] and [label] arguments must not be null.
  factory CTextButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    CButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
    PlatformStyle platformStyle,
    bool? loading,
    bool? shrinkWhenLoading,
    // Gradient? backgroundGradient,
    // Gradient? foregroundGradient,
    // Gradient? borderGradient,
  }) = _CTextButtonWithIcon;

  /// A static convenience method that constructs a text button
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
  /// All parameters default to null. By default this method returns
  /// a [CButtonStyle] that doesn't override anything.
  ///
  /// For example, to override the default text and icon colors for a
  /// [CTextButton], as well as its overlay color, with all of the
  /// standard opacity adjustments for the pressed, focused, and
  /// hovered states, one could write:
  ///
  /// ```dart
  /// CTextButton(
  ///   style: CTextButton.styleFrom(primary: Colors.green),
  /// )
  /// ```
  static CButtonStyle styleFrom({
    Gradient? gradient,
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
    final MaterialStateProperty<Gradient?>? foregroundGradient =
        gradient == null ? null : _CTextButtonDefaultGradient(gradient);

    final MaterialStateProperty<Color?>? foregroundColor =
        (onSurface == null && primary == null)
            ? null
            : _CTextButtonDefaultForeground(primary, onSurface);

    final MaterialStateProperty<Color?>? overlayColor =
        (primary == null) ? null : _CTextButtonDefaultOverlay(primary);

    final MaterialStateProperty<MouseCursor>? mouseCursor =
        (enabledMouseCursor == null && disabledMouseCursor == null)
            ? null
            : _CTextButtonDefaultMouseCursor(
                enabledMouseCursor!, disabledMouseCursor!);

    return CButtonStyle(
      textStyle: CButtonStyleButton.allOrNull<TextStyle>(textStyle),
      backgroundColor: CButtonStyleButton.allOrNull<Color>(backgroundColor),
      foregroundColor: foregroundColor,
      foregroundGradient: foregroundGradient,
      overlayColor: overlayColor,
      shadowColor: CButtonStyleButton.allOrNull<Color>(shadowColor),
      elevation: CButtonStyleButton.allOrNull<double>(elevation),
      padding: CButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: CButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: CButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: CButtonStyleButton.allOrNull<Size>(maximumSize),
      side: CButtonStyleButton.allOrNull<BorderSide>(side),
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
  /// The button [child]'s [Text] and [Icon] widgets are rendered with
  /// the [CButtonStyle]'s foreground color. The button's [InkWell] adds
  /// the style's overlay color when the button is focused, hovered
  /// or pressed. The button's background color becomes its [Material]
  /// color and is transparent by default.
  ///
  /// All of the CButtonStyle's defaults appear below.
  ///
  /// In this list "Theme.foo" is shorthand for
  /// `Theme.of(context).foo`. Color scheme values like
  /// "onSurface(0.38)" are shorthand for
  /// `onSurface.withOpacity(0.38)`. [MaterialStateProperty] valued
  /// properties that are not followed by a sublist have the same
  /// value for all states, otherwise the values are as specified for
  /// each state and "others" means all other states.
  ///
  /// The `textScaleFactor` is the value of
  /// `MediaQuery.of(context).textScaleFactor` and the names of the
  /// EdgeInsets constructors and `EdgeInsetsGeometry.lerp` have been
  /// abbreviated for readability.
  ///
  /// The color of the [CButtonStyle.textStyle] is not used, the
  /// [CButtonStyle.foregroundColor] color is used instead.
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
  ///   * `textScaleFactor <= 1` - all(8)
  ///   * `1 < textScaleFactor <= 2` - lerp(all(8), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  /// * `minimumSize` - Size(64, 36)
  /// * `fixedSize` - null
  /// * `maximumSize` - Size.infinite
  /// * `side` - null
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
  ///
  /// The default padding values for the [CTextButton.icon] factory are slightly different:
  ///
  /// * `padding`
  ///   * `textScaleFactor <= 1` - all(8)
  ///   * `1 < textScaleFactor <= 2 `- lerp(all(8), horizontal(4))
  ///   * `2 < textScaleFactor` - horizontal(4)
  ///
  /// The default value for `side`, which defines the appearance of the button's
  /// outline, is null. That means that the outline is defined by the button
  /// shape's [OutlinedBorder.side]. Typically the default value of an
  /// [OutlinedBorder]'s side is [BorderSide.none], so an outline is not drawn.
  @override
  CButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsetsGeometry scaledPadding = CButtonStyleButton.scaledPadding(
      const EdgeInsets.all(8),
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

  /// Returns the [TextButtonThemeData.style] of the closest
  /// [TextButtonTheme] ancestor.
  @override
  CButtonStyle? themeStyleOf(BuildContext context) {
    return TextButtonTheme.of(context).style?.cButtonStyle;
  }
}

@immutable
class _CTextButtonDefaultGradient extends MaterialStateProperty<Gradient?>
    with Diagnosticable {
  _CTextButtonDefaultGradient(this.gradient);

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
class _CTextButtonDefaultForeground extends MaterialStateProperty<Color?> {
  _CTextButtonDefaultForeground(this.primary, this.onSurface);

  final Color? primary;
  final Color? onSurface;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return onSurface?.withOpacity(0.38);
    }
    return primary;
  }

  @override
  String toString() {
    return '{disabled: ${onSurface?.withOpacity(0.38)}, otherwise: $primary}';
  }
}

@immutable
class _CTextButtonDefaultOverlay extends MaterialStateProperty<Color?> {
  _CTextButtonDefaultOverlay(this.primary);

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

  @override
  String toString() {
    return '{hovered: ${primary.withOpacity(0.04)}, focused,pressed: ${primary.withOpacity(0.12)}, otherwise: null}';
  }
}

@immutable
class _CTextButtonDefaultMouseCursor extends MaterialStateProperty<MouseCursor>
    with Diagnosticable {
  _CTextButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return disabledCursor;
    return enabledCursor;
  }
}

class _CTextButtonWithIcon extends CTextButton {
  _CTextButtonWithIcon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    CButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
    PlatformStyle platformStyle = PlatformStyle.auto,
    bool? loading,
    bool? shrinkWhenLoading,
    // Gradient? backgroundGradient,
    // Gradient? foregroundGradient,
    // Gradient? borderGradient,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: _CTextButtonWithIconChild(icon: icon, label: label),
          platformStyle: platformStyle,
          loading: loading,
          shrinkWhenLoading: shrinkWhenLoading,
          // backgroundGradient: backgroundGradient,
          // foregroundGradient: foregroundGradient,
          // borderGradient: borderGradient,
        );

  @override
  CButtonStyle defaultStyleOf(BuildContext context) {
    final EdgeInsetsGeometry scaledPadding = CButtonStyleButton.scaledPadding(
      const EdgeInsets.all(8),
      const EdgeInsets.symmetric(horizontal: 4),
      const EdgeInsets.symmetric(horizontal: 4),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );
    return super.defaultStyleOf(context).copyWith(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(scaledPadding),
        );
  }
}

class _CTextButtonWithIconChild extends StatelessWidget {
  const _CTextButtonWithIconChild({
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
