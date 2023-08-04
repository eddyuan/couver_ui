import "dart:math" as math;
import 'package:couver_ui/src/core/buttons/theme.c_button_style.dart';
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

import '../../enums/enum.platform_style.dart';
import 'widget.c_button_style_button.dart';

// Examples can assume:
// late BuildContext context;

// Minimum logical pixel size of the CIconButton.
// See: <https://material.io/design/usability/accessibility.html#layout-typography>.
const double _kMinButtonSize = kMinInteractiveDimension;

enum _CIconButtonVariant { standard, filled, filledTonal, outlined }

class CIconButton extends IconButton {
  const CIconButton({
    super.key,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    required super.onPressed,
    super.mouseCursor,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    CButtonStyle? style,
    super.isSelected,
    super.selectedIcon,
    required super.icon,
    this.loading,
  })  : assert(splashRadius == null || splashRadius > 0),
        _variant = _CIconButtonVariant.standard,
        cStyle = style,
        super(style: style);

  /// Create a filled variant of CIconButton.
  ///
  /// Filled icon buttons have higher visual impact and should be used for
  /// high emphasis actions, such as turning off a microphone or camera.
  const CIconButton.filled({
    super.key,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    required super.onPressed,
    super.mouseCursor,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    CButtonStyle? style,
    super.isSelected,
    super.selectedIcon,
    required super.icon,
    this.loading,
  })  : assert(splashRadius == null || splashRadius > 0),
        _variant = _CIconButtonVariant.filled,
        cStyle = style,
        super(style: style);

  /// Create a filled tonal variant of CIconButton.
  ///
  /// Filled tonal icon buttons are a middle ground between filled and outlined
  /// icon buttons. They’re useful in contexts where the button requires slightly
  /// more emphasis than an outline would give, such as a secondary action paired
  /// with a high emphasis action.
  const CIconButton.filledTonal({
    super.key,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    required super.onPressed,
    super.mouseCursor,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    CButtonStyle? style,
    super.isSelected,
    super.selectedIcon,
    required super.icon,
    this.loading,
  })  : assert(splashRadius == null || splashRadius > 0),
        _variant = _CIconButtonVariant.filledTonal,
        cStyle = style,
        super(style: style);

  /// Create a filled tonal variant of CIconButton.
  ///
  /// Outlined icon buttons are medium-emphasis buttons. They’re useful when an
  /// icon button needs more emphasis than a standard icon button but less than
  /// a filled or filled tonal icon button.
  const CIconButton.outlined({
    super.key,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    required super.onPressed,
    super.mouseCursor,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    CButtonStyle? style,
    super.isSelected,
    super.selectedIcon,
    required super.icon,
    this.loading,
  })  : assert(splashRadius == null || splashRadius > 0),
        _variant = _CIconButtonVariant.outlined,
        cStyle = style,
        super(style: style);

  final CButtonStyle? cStyle;

  final _CIconButtonVariant _variant;

  final bool? loading;

  static CButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    double? iconSize,
    BorderSide? side,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
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
    bool? animateElevation,
  }) {
    final MaterialStateProperty<Color?>? buttonBackgroundColor =
        (backgroundColor == null && disabledBackgroundColor == null)
            ? null
            : _CIconButtonDefaultBackground(
                backgroundColor, disabledBackgroundColor);
    final MaterialStateProperty<Color?>? buttonForegroundColor =
        (foregroundColor == null && disabledForegroundColor == null)
            ? null
            : _CIconButtonDefaultForeground(
                foregroundColor, disabledForegroundColor);
    final MaterialStateProperty<Color?>? overlayColor =
        (foregroundColor == null &&
                hoverColor == null &&
                focusColor == null &&
                highlightColor == null)
            ? null
            : _CIconButtonDefaultOverlay(
                foregroundColor, focusColor, hoverColor, highlightColor);
    final MaterialStateProperty<MouseCursor>? mouseCursor =
        (enabledMouseCursor == null && disabledMouseCursor == null)
            ? null
            : _CIconButtonDefaultMouseCursor(
                enabledMouseCursor!, disabledMouseCursor!);

    final MaterialStateProperty<Gradient?>? backgroundGradientProp =
        (backgroundGradient == null)
            ? null
            : _CIconButtonDefaultGradient(backgroundGradient);

    final MaterialStateProperty<Gradient?>? foregroundGradientProp =
        (foregroundGradient == null)
            ? null
            : _CIconButtonDefaultGradient(foregroundGradient);

    final MaterialStateProperty<Gradient?>? borderGradientProp =
        (borderGradient == null)
            ? null
            : _CIconButtonDefaultGradient(borderGradient);

    return CButtonStyle(
      backgroundColor: buttonBackgroundColor,
      foregroundColor: buttonForegroundColor,
      overlayColor: overlayColor,
      shadowColor: CButtonStyleButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: CButtonStyleButton.allOrNull<Color>(surfaceTintColor),
      elevation: CButtonStyleButton.allOrNull<double>(elevation),
      padding: CButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: CButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: CButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: CButtonStyleButton.allOrNull<Size>(maximumSize),
      iconSize: CButtonStyleButton.allOrNull<double>(iconSize),
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
      shrinkWhenLoading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (theme.useMaterial3) {
      final Size? minSize = constraints == null
          ? null
          : Size(constraints!.minWidth, constraints!.minHeight);
      final Size? maxSize = constraints == null
          ? null
          : Size(constraints!.maxWidth, constraints!.maxHeight);

      CButtonStyle adjustedStyle = styleFrom(
        visualDensity: visualDensity,
        foregroundColor: color,
        disabledForegroundColor: disabledColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        padding: padding,
        minimumSize: minSize,
        maximumSize: maxSize,
        iconSize: iconSize,
        alignment: alignment,
        enabledMouseCursor: mouseCursor,
        disabledMouseCursor: mouseCursor,
        enableFeedback: enableFeedback,
      );
      if (cStyle != null) {
        adjustedStyle = cStyle!.merge(adjustedStyle);
      }

      Widget effectiveIcon = icon;
      if ((isSelected ?? false) && selectedIcon != null) {
        effectiveIcon = selectedIcon!;
      }

      Widget iconButton = effectiveIcon;
      if (tooltip != null) {
        iconButton = Tooltip(
          message: tooltip,
          child: effectiveIcon,
        );
      }

      return _SelectableCIconButton(
        style: adjustedStyle,
        onPressed: onPressed,
        autofocus: autofocus,
        focusNode: focusNode,
        isSelected: isSelected,
        variant: _variant,
        loading: loading,
        child: iconButton,
      );
    }

    assert(debugCheckHasMaterial(context));

    Color? currentColor;
    if (onPressed != null) {
      currentColor = color;
    } else {
      currentColor = disabledColor ?? theme.disabledColor;
    }

    final VisualDensity effectiveVisualDensity =
        visualDensity ?? theme.visualDensity;

    final BoxConstraints unadjustedConstraints = constraints ??
        const BoxConstraints(
          minWidth: _kMinButtonSize,
          minHeight: _kMinButtonSize,
        );
    final BoxConstraints adjustedConstraints =
        effectiveVisualDensity.effectiveConstraints(unadjustedConstraints);
    final double effectiveIconSize =
        iconSize ?? IconTheme.of(context).size ?? 24.0;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.all(8.0);
    final AlignmentGeometry effectiveAlignment = alignment ?? Alignment.center;
    final bool effectiveEnableFeedback = enableFeedback ?? true;

    Widget result = ConstrainedBox(
      constraints: adjustedConstraints,
      child: Padding(
        padding: effectivePadding,
        child: SizedBox(
          height: effectiveIconSize,
          width: effectiveIconSize,
          child: Align(
            alignment: effectiveAlignment,
            child: IconTheme.merge(
              data: IconThemeData(
                size: effectiveIconSize,
                color: currentColor,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      result = Tooltip(
        message: tooltip,
        child: result,
      );
    }

    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: InkResponse(
        focusNode: focusNode,
        autofocus: autofocus,
        canRequestFocus: onPressed != null,
        onTap: onPressed,
        mouseCursor: mouseCursor ??
            (onPressed == null
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click),
        enableFeedback: effectiveEnableFeedback,
        focusColor: focusColor ?? theme.focusColor,
        hoverColor: hoverColor ?? theme.hoverColor,
        highlightColor: highlightColor ?? theme.highlightColor,
        splashColor: splashColor ?? theme.splashColor,
        radius: splashRadius ??
            math.max(
              Material.defaultSplashRadius,
              (effectiveIconSize +
                      math.min(effectivePadding.horizontal,
                          effectivePadding.vertical)) *
                  0.7,
              // x 0.5 for diameter -> radius and + 40% overflow derived from other Material apps.
            ),
        child: result,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('icon', icon, showName: false));
    properties.add(
        StringProperty('tooltip', tooltip, defaultValue: null, quoted: false));
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', onPressed,
        ifNull: 'disabled'));
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties
        .add(ColorProperty('disabledColor', disabledColor, defaultValue: null));
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties.add(
        ColorProperty('highlightColor', highlightColor, defaultValue: null));
    properties
        .add(ColorProperty('splashColor', splashColor, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
  }
}

class _SelectableCIconButton extends StatefulWidget {
  const _SelectableCIconButton({
    this.isSelected,
    this.style,
    this.focusNode,
    required this.variant,
    required this.autofocus,
    required this.onPressed,
    required this.child,
    this.loading,
  });

  final bool? isSelected;
  final CButtonStyle? style;
  final FocusNode? focusNode;
  final _CIconButtonVariant variant;
  final bool autofocus;
  final VoidCallback? onPressed;
  final Widget child;
  final bool? loading;

  @override
  State<_SelectableCIconButton> createState() => _SelectableCIconButtonState();
}

class _SelectableCIconButtonState extends State<_SelectableCIconButton> {
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    if (widget.isSelected == null) {
      statesController = MaterialStatesController();
    } else {
      statesController = MaterialStatesController(
          <MaterialState>{if (widget.isSelected!) MaterialState.selected});
    }
  }

  @override
  void didUpdateWidget(_SelectableCIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected == null) {
      if (statesController.value.contains(MaterialState.selected)) {
        statesController.update(MaterialState.selected, false);
      }
      return;
    }
    if (widget.isSelected != oldWidget.isSelected) {
      statesController.update(MaterialState.selected, widget.isSelected!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool toggleable = widget.isSelected != null;

    return _CIconButtonM3(
      statesController: statesController,
      style: widget.style,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onPressed: widget.onPressed,
      variant: widget.variant,
      toggleable: toggleable,
      loading: widget.loading,
      child: widget.child,
    );
  }
}

class _CIconButtonM3 extends CButtonStyleButton {
  const _CIconButtonM3({
    required super.onPressed,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.statesController,
    required this.variant,
    required this.toggleable,
    required Widget super.child,
    super.loading,
  }) : super(
            onLongPress: null,
            onHover: null,
            onFocusChange: null,
            clipBehavior: Clip.none);

  final _CIconButtonVariant variant;
  final bool toggleable;

  /// ## Material 3 defaults
  ///
  /// If [ThemeData.useMaterial3] is set to true the following defaults will
  /// be used:
  ///
  /// * `textStyle` - null
  /// * `backgroundColor` - transparent
  /// * `foregroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.38)
  ///   * selected - Theme.colorScheme.primary
  ///   * others - Theme.colorScheme.onSurfaceVariant
  /// * `overlayColor`
  ///   * selected
  ///      * hovered - Theme.colorScheme.primary(0.08)
  ///      * focused or pressed - Theme.colorScheme.primary(0.12)
  ///   * hovered or focused - Theme.colorScheme.onSurfaceVariant(0.08)
  ///   * pressed - Theme.colorScheme.onSurfaceVariant(0.12)
  ///   * others - null
  /// * `shadowColor` - null
  /// * `surfaceTintColor` - null
  /// * `elevation` - 0
  /// * `padding` - all(8)
  /// * `minimumSize` - Size(40, 40)
  /// * `fixedSize` - null
  /// * `maximumSize` - Size.infinite
  /// * `iconSize` - 24
  /// * `side` - null
  /// * `shape` - StadiumBorder()
  /// * `mouseCursor`
  ///   * disabled - SystemMouseCursors.basic
  ///   * others - SystemMouseCursors.click
  /// * `visualDensity` - VisualDensity.standard
  /// * `tapTargetSize` - theme.materialTapTargetSize
  /// * `animationDuration` - kThemeChangeDuration
  /// * `enableFeedback` - true
  /// * `alignment` - Alignment.center
  /// * `splashFactory` - Theme.splashFactory
  @override
  CButtonStyle defaultStyleOf(BuildContext context) {
    switch (variant) {
      case _CIconButtonVariant.filled:
        return _FilledCIconButtonDefaultsM3(context, toggleable);
      case _CIconButtonVariant.filledTonal:
        return _FilledTonalCIconButtonDefaultsM3(context, toggleable);
      case _CIconButtonVariant.outlined:
        return _OutlinedCIconButtonDefaultsM3(context, toggleable);
      case _CIconButtonVariant.standard:
        return _CIconButtonDefaultsM3(context, toggleable);
    }
  }

  /// Returns the [CIconButtonThemeData.style] of the closest [CIconButtonTheme] ancestor.
  /// The color and icon size can also be configured by the [IconTheme] if the same property
  /// has a null value in [CIconButtonTheme]. However, if any of the properties exist
  /// in both [CIconButtonTheme] and [IconTheme], [IconTheme] will be overridden.
  @override
  CButtonStyle? themeStyleOf(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    bool isIconThemeDefault(Color? color) {
      if (isDark) {
        return color == kDefaultIconLightColor;
      }
      return color == kDefaultIconDarkColor;
    }

    final bool isDefaultColor = isIconThemeDefault(iconTheme.color);
    final bool isDefaultSize =
        iconTheme.size == const IconThemeData.fallback().size;

    final ButtonStyle iconThemeStyle = CIconButton.styleFrom(
        foregroundColor: isDefaultColor ? null : iconTheme.color,
        iconSize: isDefaultSize ? null : iconTheme.size);

    return (IconButtonTheme.of(context).style?.merge(iconThemeStyle) ??
            iconThemeStyle)
        .cButtonStyle;
  }
}

@immutable
class _CIconButtonDefaultBackground extends MaterialStateProperty<Color?> {
  _CIconButtonDefaultBackground(this.background, this.disabledBackground);

  final Color? background;
  final Color? disabledBackground;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabledBackground;
    }
    return background;
  }

  @override
  String toString() {
    return '{disabled: $disabledBackground, otherwise: $background}';
  }
}

@immutable
class _CIconButtonDefaultForeground extends MaterialStateProperty<Color?> {
  _CIconButtonDefaultForeground(
      this.foregroundColor, this.disabledForegroundColor);

  final Color? foregroundColor;
  final Color? disabledForegroundColor;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabledForegroundColor;
    }
    return foregroundColor;
  }

  @override
  String toString() {
    return '{disabled: $disabledForegroundColor, otherwise: $foregroundColor}';
  }
}

@immutable
class _CIconButtonDefaultOverlay extends MaterialStateProperty<Color?> {
  _CIconButtonDefaultOverlay(this.foregroundColor, this.focusColor,
      this.hoverColor, this.highlightColor);

  final Color? foregroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      if (states.contains(MaterialState.pressed)) {
        return highlightColor ?? foregroundColor?.withOpacity(0.12);
      }
      if (states.contains(MaterialState.hovered)) {
        return hoverColor ?? foregroundColor?.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return focusColor ?? foregroundColor?.withOpacity(0.12);
      }
    }
    if (states.contains(MaterialState.pressed)) {
      return highlightColor ?? foregroundColor?.withOpacity(0.12);
    }
    if (states.contains(MaterialState.hovered)) {
      return hoverColor ?? foregroundColor?.withOpacity(0.08);
    }
    if (states.contains(MaterialState.focused)) {
      return focusColor ?? foregroundColor?.withOpacity(0.08);
    }
    return null;
  }

  @override
  String toString() {
    return '{hovered: $hoverColor, focused: $focusColor, pressed: $highlightColor, otherwise: null}';
  }
}

@immutable
class _CIconButtonDefaultMouseCursor extends MaterialStateProperty<MouseCursor>
    with Diagnosticable {
  _CIconButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabledCursor;
    }
    return enabledCursor;
  }
}

@immutable
class _CIconButtonDefaultGradient extends MaterialStateProperty<Gradient?>
    with Diagnosticable {
  _CIconButtonDefaultGradient(this.gradient);

  final Gradient? gradient;

  @override
  Gradient? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return null;
    }
    return gradient;
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - CIconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _CIconButtonDefaultsM3 extends CButtonStyle {
  _CIconButtonDefaultsM3(this.context, this.toggleable)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
        );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  MaterialStateProperty<Color?>? get backgroundColor =>
      const MaterialStatePropertyAll<Color?>(Colors.transparent);

  @override
  MaterialStateProperty<Color?>? get foregroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.primary;
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color?>? get overlayColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.primary.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.primary.withOpacity(0.12);
          }
          if (states.contains(MaterialState.pressed)) {
            return _colors.primary.withOpacity(0.12);
          }
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurfaceVariant.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onSurfaceVariant.withOpacity(0.12);
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.onSurfaceVariant.withOpacity(0.12);
        }
        return Colors.transparent;
      });

  @override
  MaterialStateProperty<double>? get elevation =>
      const MaterialStatePropertyAll<double>(0.0);

  @override
  MaterialStateProperty<Color>? get shadowColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<Color>? get surfaceTintColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<EdgeInsetsGeometry>? get padding =>
      const MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  MaterialStateProperty<Size>? get minimumSize =>
      const MaterialStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  MaterialStateProperty<Size>? get maximumSize =>
      const MaterialStatePropertyAll<Size>(Size.infinite);

  @override
  MaterialStateProperty<double>? get iconSize =>
      const MaterialStatePropertyAll<double>(24.0);

  @override
  MaterialStateProperty<BorderSide?>? get side => null;

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
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize =>
      Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;
}

// END GENERATED TOKEN PROPERTIES - CIconButton

// BEGIN GENERATED TOKEN PROPERTIES - FilledCIconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _FilledCIconButtonDefaultsM3 extends CButtonStyle {
  _FilledCIconButtonDefaultsM3(this.context, this.toggleable)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
        );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  MaterialStateProperty<Color?>? get backgroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.primary;
        }
        if (toggleable) {
          // toggleable but unselected case
          return _colors.surfaceVariant;
        }
        return _colors.primary;
      });

  @override
  MaterialStateProperty<Color?>? get foregroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onPrimary;
        }
        if (toggleable) {
          // toggleable but unselected case
          return _colors.primary;
        }
        return _colors.onPrimary;
      });

  @override
  MaterialStateProperty<Color?>? get overlayColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.onPrimary.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.onPrimary.withOpacity(0.12);
          }
          if (states.contains(MaterialState.pressed)) {
            return _colors.onPrimary.withOpacity(0.12);
          }
        }
        if (toggleable) {
          // toggleable but unselected case
          if (states.contains(MaterialState.hovered)) {
            return _colors.primary.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.primary.withOpacity(0.12);
          }
          if (states.contains(MaterialState.pressed)) {
            return _colors.primary.withOpacity(0.12);
          }
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onPrimary.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onPrimary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.onPrimary.withOpacity(0.12);
        }
        return Colors.transparent;
      });

  @override
  MaterialStateProperty<double>? get elevation =>
      const MaterialStatePropertyAll<double>(0.0);

  @override
  MaterialStateProperty<Color>? get shadowColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<Color>? get surfaceTintColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<EdgeInsetsGeometry>? get padding =>
      const MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  MaterialStateProperty<Size>? get minimumSize =>
      const MaterialStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  MaterialStateProperty<Size>? get maximumSize =>
      const MaterialStatePropertyAll<Size>(Size.infinite);

  @override
  MaterialStateProperty<double>? get iconSize =>
      const MaterialStatePropertyAll<double>(24.0);

  @override
  MaterialStateProperty<BorderSide?>? get side => null;

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
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize =>
      Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;
}

// END GENERATED TOKEN PROPERTIES - FilledCIconButton

// BEGIN GENERATED TOKEN PROPERTIES - FilledTonalCIconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _FilledTonalCIconButtonDefaultsM3 extends CButtonStyle {
  _FilledTonalCIconButtonDefaultsM3(this.context, this.toggleable)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
        );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  MaterialStateProperty<Color?>? get backgroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.secondaryContainer;
        }
        if (toggleable) {
          // toggleable but unselected case
          return _colors.surfaceVariant;
        }
        return _colors.secondaryContainer;
      });

  @override
  MaterialStateProperty<Color?>? get foregroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onSecondaryContainer;
        }
        if (toggleable) {
          // toggleable but unselected case
          return _colors.onSurfaceVariant;
        }
        return _colors.onSecondaryContainer;
      });

  @override
  MaterialStateProperty<Color?>? get overlayColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.onSecondaryContainer.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.onSecondaryContainer.withOpacity(0.12);
          }
          if (states.contains(MaterialState.pressed)) {
            return _colors.onSecondaryContainer.withOpacity(0.12);
          }
        }
        if (toggleable) {
          // toggleable but unselected case
          if (states.contains(MaterialState.hovered)) {
            return _colors.onSurfaceVariant.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.onSurfaceVariant.withOpacity(0.12);
          }
          if (states.contains(MaterialState.pressed)) {
            return _colors.onSurfaceVariant.withOpacity(0.12);
          }
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSecondaryContainer.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onSecondaryContainer.withOpacity(0.12);
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.onSecondaryContainer.withOpacity(0.12);
        }
        return Colors.transparent;
      });

  @override
  MaterialStateProperty<double>? get elevation =>
      const MaterialStatePropertyAll<double>(0.0);

  @override
  MaterialStateProperty<Color>? get shadowColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<Color>? get surfaceTintColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<EdgeInsetsGeometry>? get padding =>
      const MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  MaterialStateProperty<Size>? get minimumSize =>
      const MaterialStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  MaterialStateProperty<Size>? get maximumSize =>
      const MaterialStatePropertyAll<Size>(Size.infinite);

  @override
  MaterialStateProperty<double>? get iconSize =>
      const MaterialStatePropertyAll<double>(24.0);

  @override
  MaterialStateProperty<BorderSide?>? get side => null;

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
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize =>
      Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;
}

// END GENERATED TOKEN PROPERTIES - FilledTonalCIconButton

// BEGIN GENERATED TOKEN PROPERTIES - OutlinedCIconButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _OutlinedCIconButtonDefaultsM3 extends CButtonStyle {
  _OutlinedCIconButtonDefaultsM3(this.context, this.toggleable)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
        );

  final BuildContext context;
  final bool toggleable;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // No default text style

  @override
  MaterialStateProperty<Color?>? get backgroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          if (states.contains(MaterialState.selected)) {
            return _colors.onSurface.withOpacity(0.12);
          }
          return Colors.transparent;
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.inverseSurface;
        }
        return Colors.transparent;
      });

  @override
  MaterialStateProperty<Color?>? get foregroundColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        if (states.contains(MaterialState.selected)) {
          return _colors.onInverseSurface;
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color?>? get overlayColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.onInverseSurface.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return _colors.onInverseSurface.withOpacity(0.08);
          }
          if (states.contains(MaterialState.pressed)) {
            return _colors.onInverseSurface.withOpacity(0.12);
          }
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurfaceVariant.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onSurfaceVariant.withOpacity(0.08);
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        return Colors.transparent;
      });

  @override
  MaterialStateProperty<double>? get elevation =>
      const MaterialStatePropertyAll<double>(0.0);

  @override
  MaterialStateProperty<Color>? get shadowColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<Color>? get surfaceTintColor =>
      const MaterialStatePropertyAll<Color>(Colors.transparent);

  @override
  MaterialStateProperty<EdgeInsetsGeometry>? get padding =>
      const MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(8.0));

  @override
  MaterialStateProperty<Size>? get minimumSize =>
      const MaterialStatePropertyAll<Size>(Size(40.0, 40.0));

  // No default fixedSize

  @override
  MaterialStateProperty<Size>? get maximumSize =>
      const MaterialStatePropertyAll<Size>(Size.infinite);

  @override
  MaterialStateProperty<double>? get iconSize =>
      const MaterialStatePropertyAll<double>(24.0);

  @override
  MaterialStateProperty<BorderSide?>? get side =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return null;
        } else {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(color: _colors.onSurface.withOpacity(0.12));
          }
          return BorderSide(color: _colors.outline);
        }
      });

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
  VisualDensity? get visualDensity => VisualDensity.standard;

  @override
  MaterialTapTargetSize? get tapTargetSize =>
      Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;
}

// END GENERATED TOKEN PROPERTIES - OutlinedCIconButton