import 'package:flutter/material.dart';

import 'screens/buttons_screen.dart';
import 'screens/cards_screen.dart';
import 'screens/home_screen.dart';
import 'screens/progress_bar_screen.dart';

class RouteButtonConfig {
  final String routeName;
  final String displayName;
  const RouteButtonConfig(this.routeName, this.displayName);
  factory RouteButtonConfig.fromRouteName(String val) => RouteButtonConfig(
        val,
        val.replaceAll("/", ""),
      );
}

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/buttons': (context) => const ButtonsScreen(),
    '/cards': (context) => const CardsScreen(),
    '/progress_bars': (context) => const ProgressBarScreen(),
  };

  static List<RouteButtonConfig> get buttons =>
      routes.entries.map((e) => RouteButtonConfig.fromRouteName(e.key)).toList()
        ..removeWhere((x) => x.displayName.isEmpty);
}
