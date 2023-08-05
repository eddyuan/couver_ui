import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool _isDark(Color color, {double threshold = 0.15}) {
  final double relativeLuminance = color.computeLuminance();
  return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) <= threshold);
}

class CButtonColor {
  static MaterialStateProperty<Color?>? buildForegroundState(
    Color? foregroundColor,
    Color? disabledForegroundColor,
    Gradient? foregroundGradient,
    Color? backgroundColor,
    Gradient? backgroundGradient,
  ) {
    if (foregroundColor == null &&
        backgroundColor == null &&
        disabledForegroundColor == null &&
        foregroundGradient == null &&
        backgroundGradient == null) {
      return null;
    }
    final Color targetForegroundColor;
    if (foregroundGradient != null && foregroundGradient.colors.isNotEmpty) {
      targetForegroundColor = foregroundGradient.colors[0];
    } else if (foregroundColor != null) {
      targetForegroundColor = foregroundColor;
    } else if (backgroundGradient != null &&
        backgroundGradient.colors.isNotEmpty) {
      targetForegroundColor =
          _isDark(backgroundGradient.colors[0]) ? Colors.white : Colors.black;
    } else if (backgroundColor != null) {
      if (backgroundColor.opacity > 0.45) {
        targetForegroundColor =
            _isDark(backgroundColor) ? Colors.white : Colors.black;
      } else {
        targetForegroundColor = backgroundColor.withOpacity(1);
      }
    } else {
      targetForegroundColor = Colors.black;
    }
    final bool isForegroundDark = _isDark(targetForegroundColor);
    final Color targetDisabledColor = disabledForegroundColor ??
        (isForegroundDark
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.5));
    return _CButtonDefaultColor(targetForegroundColor, targetDisabledColor);
  }

  static MaterialStateProperty<Color?>? buildBackgroundState(
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    Gradient? backgroundGradient,
  ) {
    if (backgroundColor == null &&
        disabledBackgroundColor == null &&
        backgroundGradient == null) {
      return null;
    }
    final Color? targetBackgroundColor;
    if (backgroundColor != null) {
      targetBackgroundColor = backgroundColor;
    } else if (backgroundGradient != null &&
        backgroundGradient.colors.isNotEmpty) {
      targetBackgroundColor = backgroundGradient.colors[0];
    } else {
      targetBackgroundColor = null;
    }
    final Color? targetDisabledBackgroundColor;
    if (disabledBackgroundColor != null) {
      targetDisabledBackgroundColor = disabledBackgroundColor;
    } else if (targetBackgroundColor != null) {
      final bool isBackgroundDark = _isDark(targetBackgroundColor);
      targetDisabledBackgroundColor = isBackgroundDark
          ? Colors.black.withOpacity(0.1)
          : Colors.white.withOpacity(0.3);
    } else {
      targetDisabledBackgroundColor = null;
    }

    if (targetBackgroundColor == null &&
        targetDisabledBackgroundColor == null) {
      return null;
    }

    return _CButtonDefaultColor(
        targetBackgroundColor, targetDisabledBackgroundColor);
  }

  static MaterialStateProperty<BorderSide?>? buildBorderState(
    BorderSide? side,
    BorderSide? disabledSide,
    Gradient? borderGradient,
  ) {
    if (side == null && disabledSide == null && borderGradient == null) {
      return null;
    }
    final Color? targetColor;
    if (side != null && side.width > 0) {
      targetColor = side.color;
    } else if (borderGradient != null && borderGradient.colors.isNotEmpty) {
      targetColor = borderGradient.colors[0];
    } else {
      targetColor = null;
    }
    final Color? targetDisabledColor;
    if (disabledSide != null) {
      targetDisabledColor = disabledSide.color;
    } else if (targetColor != null) {
      targetDisabledColor = _isDark(targetColor)
          ? Colors.black.withOpacity(0.1)
          : Colors.white.withOpacity(0.3);
    } else {
      targetDisabledColor = null;
    }
    return _CButtonDefaultSide(
      side,
      side?.copyWith(color: targetDisabledColor),
    );
  }

  static MaterialStateProperty<Color?>? buildOverlayState(
    Color? foregroundColor,
    Gradient? foregroundGradient,
    Color? backgroundColor,
    Gradient? backgroundGradient, {
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
  }) {
    if (foregroundColor == null &&
        backgroundColor == null &&
        foregroundGradient == null &&
        backgroundGradient == null &&
        focusColor == null &&
        hoverColor == null &&
        highlightColor == null) {
      return null;
    }

    final Color? targetBackgroundColor;
    if (backgroundGradient != null && backgroundGradient.colors.isNotEmpty) {
      targetBackgroundColor = backgroundGradient.colors[0];
    } else if (backgroundColor != null) {
      targetBackgroundColor = backgroundColor;
    } else {
      targetBackgroundColor = null;
    }
    if (targetBackgroundColor != null && targetBackgroundColor.opacity > 0) {
      if (targetBackgroundColor.opacity > 0.4) {
        final Color targetOverlayColor =
            _isDark(targetBackgroundColor) ? Colors.white : Colors.black;
        return _CButtonDefaultOverlay(
            targetOverlayColor, focusColor, hoverColor, highlightColor);
      } else {
        return _CButtonDefaultOverlay(targetBackgroundColor.withOpacity(1),
            focusColor, hoverColor, highlightColor);
      }
    }
    final Color? targetForegroundColor;
    if (foregroundGradient != null && foregroundGradient.colors.isNotEmpty) {
      targetForegroundColor = foregroundGradient.colors[0];
    } else if (foregroundColor != null) {
      targetForegroundColor = foregroundColor;
    } else {
      targetForegroundColor = null;
    }
    if (targetForegroundColor != null && targetForegroundColor.opacity > 0) {
      return _CButtonDefaultOverlay(
          targetForegroundColor, focusColor, hoverColor, highlightColor);
    }
    return null;
  }

  static MaterialStateProperty<MouseCursor?>? buildMouseCursorState(
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
  ) {
    if (enabledMouseCursor == null && disabledMouseCursor == null) {
      return null;
    }
    return _CButtonDefaultMouseCursor(enabledMouseCursor, disabledMouseCursor);
  }

  static MaterialStateProperty<Gradient?>? buildGradientState(
      Gradient? gradient) {
    if (gradient != null) {
      return _CButtonDefaultGradient(gradient);
    }
    return null;
  }
}

@immutable
class _CButtonDefaultColor extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _CButtonDefaultColor(this.color, this.disabled);

  final Color? color;
  final Color? disabled;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabled;
    }
    return color;
  }
}

@immutable
class _CButtonDefaultSide extends MaterialStateProperty<BorderSide?>
    with Diagnosticable {
  _CButtonDefaultSide(this.side, this.disabled);

  final BorderSide? side;
  final BorderSide? disabled;

  @override
  BorderSide? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabled ?? side?.copyWith(color: Colors.black.withOpacity(0.2));
    }
    return side;
  }
}

@immutable
class _CButtonDefaultOverlay extends MaterialStateProperty<Color?>
    with Diagnosticable {
  _CButtonDefaultOverlay(
    this.foregroundColor, [
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
  ]);

  // final Color foreground;
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
    // if (states.contains(MaterialState.hovered)) {
    //   return foreground.withOpacity(0.04);
    // }
    // if (states.contains(MaterialState.focused) ||
    //     states.contains(MaterialState.pressed)) {
    //   return foreground.withOpacity(0.12);
    // }
    // return null;
  }
}

@immutable
class _CButtonDefaultMouseCursor extends MaterialStateProperty<MouseCursor>
    with Diagnosticable {
  _CButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor? enabledCursor;
  final MouseCursor? disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabledCursor ?? SystemMouseCursors.forbidden;
    }
    return enabledCursor ?? SystemMouseCursors.click;
  }
}

@immutable
class _CButtonDefaultGradient extends MaterialStateProperty<Gradient?>
    with Diagnosticable {
  _CButtonDefaultGradient(this.gradient);

  final Gradient? gradient;

  @override
  Gradient? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return null;
    }
    return gradient;
  }
}
