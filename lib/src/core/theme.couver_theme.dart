import 'package:flutter/material.dart';

class CouverTheme extends InheritedWidget {
  const CouverTheme({
    super.key,
    required super.child,
    this.theme = const CouverThemeData(),
    this.darkTheme = const CouverThemeData.dark(),
  });

  final CouverThemeData theme;
  final CouverThemeData darkTheme;
  @override
  bool updateShouldNotify(CouverTheme oldWidget) => true;

  static CouverThemeData of(BuildContext context) {
    final CouverTheme? result =
        context.dependOnInheritedWidgetOfExactType<CouverTheme>();
    final bool isDark =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    return isDark
        ? (result?.darkTheme ?? const CouverThemeData.dark())
        : (result?.theme ?? const CouverThemeData());
  }
}

class CouverThemeData {
  const CouverThemeData({
    this.obscuringCharacter = "·",
    this.locale,
    this.gutter = 4,
    this.pagePadding = 24,
    this.inputBorderRadius = 8,
    this.animationSizeDuration = const Duration(milliseconds: 200),
    this.animationSizeCurve = Curves.easeInOut,
    this.splashFactory = InkSparkle.splashFactory,
    this.colors = const CouverThemeColors(),
  });

  const CouverThemeData.dark({
    this.obscuringCharacter = "·",
    this.locale,
    this.gutter = 4,
    this.pagePadding = 24,
    this.inputBorderRadius = 8,
    this.animationSizeDuration = const Duration(milliseconds: 200),
    this.animationSizeCurve = Curves.easeInOut,
    this.splashFactory = InkSparkle.splashFactory,
    this.colors = const CouverThemeColors.dark(),
  });

  final String obscuringCharacter;
  final Locale? locale;
  final double gutter;
  final double pagePadding;
  final double inputBorderRadius;
  final Curve animationSizeCurve;
  final Duration animationSizeDuration;
  final InteractiveInkFeatureFactory splashFactory;
  final CouverThemeColors colors;

  double get gutter2 => gutter * 2;
  double get gutter3 => gutter * 3;
  double get gutter4 => gutter * 4;
  double get gutter5 => gutter * 5;
  double get gutter6 => gutter * 6;
  double get gutter7 => gutter * 7;
  double get gutter8 => gutter * 8;
  double get gutter9 => gutter * 9;
  double get gutter10 => gutter * 10;
}

class CouverThemeColors {
  const CouverThemeColors({
    this.inputEnabledBorderColor = const Color.fromARGB(47, 0, 0, 0),
    this.inputDisableBorderColor = Colors.transparent,
    this.inputFocusBorderColor = Colors.lightGreen,
    this.inputFillColor,
    this.inputDisableFillColor = const Color.fromARGB(15, 0, 0, 0),
    this.inputFillDisabled = true,
  });
  const CouverThemeColors.dark({
    this.inputEnabledBorderColor = const Color.fromARGB(46, 255, 255, 255),
    this.inputDisableBorderColor = Colors.transparent,
    this.inputFocusBorderColor = Colors.lightGreen,
    this.inputFillColor,
    this.inputDisableFillColor = const Color.fromARGB(15, 255, 255, 255),
    this.inputFillDisabled = true,
  });
  final Color inputEnabledBorderColor;
  final Color inputDisableBorderColor;
  final MaterialColor inputFocusBorderColor;
  // final Color inputErrorBorderColor;
  final Color? inputFillColor;
  final Color inputDisableFillColor;

  /// use fill when disabled
  final bool inputFillDisabled;
}
