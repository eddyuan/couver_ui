// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../enums/enum.platform_style.dart';
import 'helper.c_button_color.dart';
import 'theme.c_button_style.dart';
import 'widget.c_button_style_button.dart';

/// A Material Design "elevated button".
///
/// Use elevated buttons to add dimension to otherwise mostly flat
/// layouts, e.g.  in long busy lists of content, or in wide
/// spaces. Avoid using elevated buttons on already-elevated content
/// such as dialogs or cards.
///
/// An elevated button is a label [child] displayed on a [Material]
/// widget whose [Material.elevation] increases when the button is
/// pressed. The label's [Text] and [Icon] widgets are displayed in
/// [style]'s [CButtonStyle.foregroundColor] and the button's filled
/// background is the [CButtonStyle.backgroundColor].
///
/// The elevated button's default style is defined by
/// [defaultStyleOf].  The style of this elevated button can be
/// overridden with its [style] parameter. The style of all elevated
/// buttons in a subtree can be overridden with the
/// [ElevatedButtonTheme], and the style of all of the elevated
/// buttons in an app can be overridden with the [Theme]'s
/// [ThemeData.elevatedButtonTheme] property.
///
/// The static [styleFrom] method is a convenient way to create a
/// elevated button [CButtonStyle] from simple values.
///
/// If [onPressed] and [onLongPress] callbacks are null, then the
/// button will be disabled.
///
/// {@tool dartpad}
/// This sample produces an enabled and a disabled CElevatedButton.
///
/// ** See code in examples/api/lib/material/elevated_button/elevated_button.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [TextButton], a simple flat button without a shadow.
///  * [OutlinedButton], a [TextButton] with a border outline.
///  * <https://material.io/design/components/buttons.html>
///
///

enum BIconAlignment { start, end }

class CElevatedButton extends CButtonStyleButton {
  /// Create an CElevatedButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const CElevatedButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    required super.child,
    this.iconAlignment = BIconAlignment.start,
    super.loading,
    super.canRequestFocus,
  });

  final BIconAlignment iconAlignment;

  /// Create an elevated button from a pair of widgets that serve as the button's
  /// [icon] and [label].
  ///
  /// The icon and label are arranged in a row and padded by 12 logical pixels
  /// at the start, and 16 at the end, with an 8 pixel gap in between.
  ///
  /// The [icon] and [label] arguments must not be null.
  factory CElevatedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    CButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    MaterialStatesController? statesController,
    Widget? icon,
    required Widget label,
    BIconAlignment iconAlignment = BIconAlignment.start,
    bool? loading,
    bool? canRequestFocus,
  }) {
    if (icon == null) {
      return CElevatedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        loading: loading,
        canRequestFocus: canRequestFocus,
        child: label,
      );
    }
    return _CElevatedButtonWithIcon(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus ?? false,
      clipBehavior: clipBehavior ?? Clip.none,
      statesController: statesController,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
      loading: loading,
      canRequestFocus: canRequestFocus,
    );
  }

  /// A static convenience method that constructs an elevated button
  /// [CButtonStyle] given simple values.
  ///
  /// The [onPrimary], and [onSurface] colors are used to create a
  /// [MaterialStateProperty] [CButtonStyle.foregroundColor] value in the same
  /// way that [defaultStyleOf] uses the [ColorScheme] colors with the same
  /// names. Specify a value for [onPrimary] to specify the color of the
  /// button's text and icons as well as the overlay colors used to indicate the
  /// hover, focus, and pressed states. Use [primary] for the button's background
  /// fill color and [onSurface] to specify the button's disabled text, icon,
  /// and fill color.
  ///
  /// The button's elevations are defined relative to the [elevation]
  /// parameter. The disabled elevation is the same as the parameter
  /// value, [elevation] + 2 is used when the button is hovered
  /// or focused, and elevation + 6 is used when the button is pressed.
  ///
  /// Similarly, the [enabledMouseCursor] and [disabledMouseCursor]
  /// parameters are used to construct [CButtonStyle].mouseCursor.
  ///
  /// All of the other parameters are either used directly or used to
  /// create a [MaterialStateProperty] with a single value for all
  /// states.
  ///
  /// All parameters default to null, by default this method returns
  /// a [CButtonStyle] that doesn't override anything.
  ///
  /// For example, to override the default text and icon colors for a
  /// [CElevatedButton], as well as its overlay color, with all of the
  /// standard opacity adjustments for the pressed, focused, and
  /// hovered states, one could write:
  ///
  /// ```dart
  /// CElevatedButton(
  ///   style: CElevatedButton.styleFrom(primary: Colors.green),
  /// )
  /// ```
  static CButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
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
    // Extra params
    Gradient? backgroundGradient,
    Gradient? foregroundGradient,
    Gradient? borderGradient,
    PlatformStyle? platformStyle,
    bool? shrinkWhenLoading,
    bool? animateElevation,
  }) {
    final MaterialStateProperty<Color?>? backgroundColorProp =
        CButtonColor.buildBackgroundState(
      backgroundColor,
      disabledBackgroundColor,
      backgroundGradient,
      foregroundGradient?.colors.firstOrNull ?? foregroundColor,
    );

    final MaterialStateProperty<Color?>? foregroundColorProp =
        CButtonColor.buildForegroundState(
      foregroundColor,
      disabledForegroundColor,
      foregroundGradient,
      backgroundGradient?.colors.firstOrNull ?? backgroundColor,
    );

    final MaterialStateProperty<Color?>? overlayColor =
        CButtonColor.buildOverlayState(foregroundColor, foregroundGradient,
            backgroundColor, backgroundGradient);

    final MaterialStateProperty<double>? elevationValue = (elevation == null)
        ? null
        : (animateElevation == null && elevation <= 0)
            ? const MaterialStatePropertyAll(0)
            : _CElevatedButtonDefaultElevation(elevation);

    final MaterialStateProperty<MouseCursor?>? mouseCursor =
        CButtonColor.buildMouseCursorState(
            enabledMouseCursor, disabledMouseCursor);

    final MaterialStateProperty<Gradient?>? backgroundGradientProp =
        CButtonColor.buildGradientState(backgroundGradient);

    final MaterialStateProperty<Gradient?>? foregroundGradientProp =
        CButtonColor.buildGradientState(foregroundGradient);

    final MaterialStateProperty<Gradient?>? borderGradientProp =
        CButtonColor.buildGradientState(borderGradient);

    return CButtonStyle(
      textStyle: MaterialStatePropertyAll<TextStyle?>(textStyle),
      backgroundColor: backgroundColorProp,
      foregroundColor: foregroundColorProp,
      overlayColor: overlayColor,
      shadowColor: CButtonStyleButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: CButtonStyleButton.allOrNull<Color>(surfaceTintColor),
      elevation: elevationValue,
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
      // Extra params
      backgroundGradient: backgroundGradientProp,
      foregroundGradient: foregroundGradientProp,
      borderGradient: borderGradientProp,
      platformStyle: platformStyle ?? PlatformStyle.auto,
      shrinkWhenLoading: shrinkWhenLoading ?? false,
    );
  }

  /// Defines the button's default appearance.
  ///
  /// The button [child]'s [Text] and [Icon] widgets are rendered with
  /// the [CButtonStyle]'s foreground color. The button's [InkWell] adds
  /// the style's overlay color when the button is focused, hovered
  /// or pressed. The button's background color becomes its [Material]
  /// color.
  ///
  /// All of the CButtonStyle's defaults appear below. In this list
  /// "Theme.foo" is shorthand for `Theme.of(context).foo`. Color
  /// scheme values like "onSurface(0.38)" are shorthand for
  /// `onSurface.withOpacity(0.38)`. [MaterialStateProperty] valued
  /// properties that are not followed by a sublist have the same
  /// value for all states, otherwise the values are as specified for
  /// each state, and "others" means all other states.
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
  /// * `backgroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.12)
  ///   * others - Theme.colorScheme.primary
  /// * `foregroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.38)
  ///   * others - Theme.colorScheme.onPrimary
  /// * `overlayColor`
  ///   * hovered - Theme.colorScheme.onPrimary(0.08)
  ///   * focused or pressed - Theme.colorScheme.onPrimary(0.24)
  /// * `shadowColor` - Theme.shadowColor
  /// * `elevation`
  ///   * disabled - 0
  ///   * default - 2
  ///   * hovered or focused - 4
  ///   * pressed - 8
  /// * `padding`
  ///   * textScaleFactor <= 1 - horizontal(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(horizontal(16), horizontal(8))
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
  /// The default padding values for the [CElevatedButton.icon] factory are slightly different:
  ///
  /// * `padding`
  ///   * `textScaleFactor <= 1` - start(12) end(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(start(12) end(16), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  ///
  /// The default value for `side`, which defines the appearance of the button's
  /// outline, is null. That means that the outline is defined by the button
  /// shape's [OutlinedBorder.side]. Typically the default value of an
  /// [OutlinedBorder]'s side is [BorderSide.none], so an outline is not drawn.
  @override
  CButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
    //   const EdgeInsets.symmetric(horizontal: 16),
    //   const EdgeInsets.symmetric(horizontal: 8),
    //   const EdgeInsets.symmetric(horizontal: 4),
    //   MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    // );

    return Theme.of(context).useMaterial3
        ? _CElevatedButtonDefaultsM3(context)
        : styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
            disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
            shadowColor: theme.shadowColor,
            elevation: 2,
            textStyle: theme.textTheme.labelLarge,
            padding: _scaledPadding(context),
            minimumSize: const Size(64, 36),
            maximumSize: Size.infinite,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            enabledMouseCursor: SystemMouseCursors.click,
            disabledMouseCursor: SystemMouseCursors.basic,
            visualDensity: theme.visualDensity,
            tapTargetSize: theme.materialTapTargetSize,
            animationDuration: kThemeChangeDuration,
            enableFeedback: true,
            alignment: Alignment.center,
            splashFactory: InkRipple.splashFactory,
          );
  }

  /// Returns the [ElevatedButtonThemeData.style] of the closest
  /// [ElevatedButtonTheme] ancestor.
  @override
  CButtonStyle? themeStyleOf(BuildContext context) {
    return ElevatedButtonTheme.of(context).style?.cButtonStyle;
  }
}

EdgeInsetsGeometry _scaledPadding(BuildContext context) {
  final bool useMaterial3 = Theme.of(context).useMaterial3;
  final double padding1x = useMaterial3 ? 24.0 : 16.0;
  return CButtonStyleButton.scaledPadding(
    EdgeInsets.symmetric(horizontal: padding1x),
    EdgeInsets.symmetric(horizontal: padding1x / 2),
    EdgeInsets.symmetric(horizontal: padding1x / 2 / 2),
    MediaQuery.textScaleFactorOf(context),
  );
}

// @immutable
// class _CElevatedButtonDefaultGradient extends MaterialStateProperty<Gradient?>
//     with Diagnosticable {
//   _CElevatedButtonDefaultGradient(this.gradient);

//   final Gradient? gradient;

//   @override
//   Gradient? resolve(Set<MaterialState> states) {
//     if (states.contains(MaterialState.disabled)) {
//       return null;
//     }
//     return gradient;
//   }
// }

// @immutable
// class _CElevatedButtonDefaultColor extends MaterialStateProperty<Color?>
//     with Diagnosticable {
//   _CElevatedButtonDefaultColor(this.color, this.disabled);

//   final Color? color;
//   final Color? disabled;

//   @override
//   Color? resolve(Set<MaterialState> states) {
//     if (states.contains(MaterialState.disabled)) {
//       return disabled;
//     }
//     return color;
//   }
// }

// @immutable
// class _CElevatedButtonDefaultOverlay extends MaterialStateProperty<Color?>
//     with Diagnosticable {
//   _CElevatedButtonDefaultOverlay(this.overlay);

//   final Color overlay;

//   @override
//   Color? resolve(Set<MaterialState> states) {
//     if (states.contains(MaterialState.hovered)) {
//       return overlay.withOpacity(0.08);
//     }
//     if (states.contains(MaterialState.focused) ||
//         states.contains(MaterialState.pressed)) {
//       return overlay.withOpacity(0.24);
//     }
//     return null;
//   }
// }

class _CElevatedButtonDefaultElevation extends MaterialStateProperty<double>
    with Diagnosticable {
  _CElevatedButtonDefaultElevation(this.elevation);

  final double elevation;

  @override
  double resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return 0;
    }
    if (states.contains(MaterialState.hovered)) {
      return elevation + 2;
    }
    if (states.contains(MaterialState.focused)) {
      return elevation + 2;
    }
    if (states.contains(MaterialState.pressed)) {
      return elevation + 6;
    }
    return elevation;
  }
}

class _CElevatedButtonDefaultMouseCursor
    extends MaterialStateProperty<MouseCursor?> with Diagnosticable {
  _CElevatedButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor? enabledCursor;
  final MouseCursor? disabledCursor;

  @override
  MouseCursor? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabledCursor;
    }
    return enabledCursor;
  }
}

class _CElevatedButtonWithIcon extends CElevatedButton {
  _CElevatedButtonWithIcon({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    super.statesController,
    required Widget icon,
    required Widget label,
    super.iconAlignment,
    super.loading,
    super.canRequestFocus,
  }) : super(
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: _CElevatedButtonWithIconChild(
            icon: icon,
            label: label,
            buttonStyle: style,
            iconAlignment: iconAlignment,
          ),
        );

  @override
  CButtonStyle defaultStyleOf(BuildContext context) {
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final EdgeInsetsGeometry scaledPadding = useMaterial3
        ? CButtonStyleButton.scaledPadding(
            const EdgeInsetsDirectional.fromSTEB(16, 0, 24, 0),
            const EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
            const EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
            MediaQuery.textScaleFactorOf(context),
          )
        : CButtonStyleButton.scaledPadding(
            const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
            const EdgeInsets.symmetric(horizontal: 8),
            const EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
            MediaQuery.textScaleFactorOf(context),
          );
    return super.defaultStyleOf(context).copyWith(
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(scaledPadding),
        );
  }
}

class _CElevatedButtonWithIconChild extends StatelessWidget {
  const _CElevatedButtonWithIconChild({
    required this.label,
    required this.icon,
    required this.buttonStyle,
    required this.iconAlignment,
  });

  final Widget label;
  final Widget icon;
  final CButtonStyle? buttonStyle;
  final BIconAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    final double defaultFontSize =
        buttonStyle?.textStyle?.resolve(const <MaterialState>{})?.fontSize ??
            14.0;
    final double scale = clampDouble(
            MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0,
            1.0,
            2.0) -
        1.0;
    final double gap = lerpDouble(8, 4, scale)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconAlignment == BIconAlignment.start
          ? <Widget>[icon, SizedBox(width: gap), Flexible(child: label)]
          : <Widget>[Flexible(child: label), SizedBox(width: gap), icon],
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - ElevatedButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _CElevatedButtonDefaultsM3 extends CButtonStyle {
  _CElevatedButtonDefaultsM3(this.context)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
        );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  MaterialStateProperty<TextStyle?> get textStyle =>
      MaterialStatePropertyAll<TextStyle?>(
          Theme.of(context).textTheme.labelLarge);

  @override
  MaterialStateProperty<Color?>? get backgroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        return _colors.surface;
      });

  @override
  MaterialStateProperty<Color?>? get foregroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        return _colors.primary;
      });

  @override
  MaterialStateProperty<Color?>? get overlayColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return _colors.primary.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary.withOpacity(0.12);
        }
        return null;
      });

  @override
  MaterialStateProperty<Color>? get shadowColor =>
      MaterialStatePropertyAll<Color>(_colors.shadow);

  @override
  MaterialStateProperty<Color>? get surfaceTintColor =>
      MaterialStatePropertyAll<Color>(_colors.surfaceTint);

  @override
  MaterialStateProperty<double>? get elevation =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return 0.0;
        }
        if (states.contains(MaterialState.hovered)) {
          return 3.0;
        }
        if (states.contains(MaterialState.focused)) {
          return 1.0;
        }
        if (states.contains(MaterialState.pressed)) {
          return 1.0;
        }
        return 1.0;
      });

  @override
  MaterialStateProperty<EdgeInsetsGeometry>? get padding =>
      MaterialStatePropertyAll<EdgeInsetsGeometry>(_scaledPadding(context));

  @override
  MaterialStateProperty<Size>? get minimumSize =>
      const MaterialStatePropertyAll<Size>(Size(64.0, 40.0));

  // No default fixedSize

  @override
  MaterialStateProperty<Size>? get maximumSize =>
      const MaterialStatePropertyAll<Size>(Size.infinite);

  // No default side

  @override
  MaterialStateProperty<OutlinedBorder>? get shape =>
      const MaterialStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  MaterialStateProperty<MouseCursor?>? get mouseCursor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.basic;
        }
        return SystemMouseCursors.click;
      });

  @override
  VisualDensity? get visualDensity => Theme.of(context).visualDensity;

  @override
  MaterialTapTargetSize? get tapTargetSize =>
      Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;
}

// END GENERATED TOKEN PROPERTIES - ElevatedButton
