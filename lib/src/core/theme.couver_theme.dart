import 'package:flutter/material.dart';

class CouverTheme extends InheritedWidget {
  const CouverTheme({
    super.key,
    this.obscuringCharacter = "*",
    this.locale,
    this.gutter = 4,
    this.pagePadding = 24,
    this.inputBorderRadius = 8,
    this.animationSizeDuration = const Duration(milliseconds: 200),
    this.animationSizeCurve = Curves.easeInOut,
    this.splashFactory = InkSparkle.splashFactory,
    required super.child,
  });

  final String obscuringCharacter;
  final Locale? locale;
  final double gutter;
  final double pagePadding;
  final double inputBorderRadius;
  final Curve animationSizeCurve;
  final Duration animationSizeDuration;
  final InteractiveInkFeatureFactory splashFactory;

  static CouverTheme of(BuildContext context) {
    final CouverTheme? result =
        context.dependOnInheritedWidgetOfExactType<CouverTheme>();
    // assert(result != null, 'No FrogColor found in context');
    return result ?? const CouverTheme(child: SizedBox.shrink());
  }

  @override
  bool updateShouldNotify(CouverTheme oldWidget) =>
      obscuringCharacter != oldWidget.obscuringCharacter ||
      locale != oldWidget.locale ||
      gutter != oldWidget.gutter ||
      inputBorderRadius != oldWidget.inputBorderRadius;
}

// class CouverThemeData {
//   const CouverThemeData({
//     this.obscuringCharacter = "*",
//   });
//   final String obscuringCharacter;
// }
