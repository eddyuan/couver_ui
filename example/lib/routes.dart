import 'package:example/screens/expandable_screen.dart';
import 'package:example/screens/flip_boards_screen.dart';
import 'package:example/screens/ink_sreen.dart';
import 'package:example/screens/input_screen.dart';
import 'package:example/screens/list_tiles_screen.dart';
import 'package:example/screens/page_view_screen.dart';
import 'package:flutter/material.dart';

import 'screens/buttons_screen.dart';
import 'screens/cards_screen.dart';
import 'screens/home_screen.dart';
import 'screens/progress_indicators_screen.dart';

extension StringExtension on String {
  String capitalize() {
    if (isNotEmpty) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
    return this;
  }

  String toRouteName() {
    if (isNotEmpty) {
      return replaceAll("/", "")
          .split("_")
          .map((e) => e.capitalize())
          .toList()
          .join(" ");
    }
    return this;
  }
}

class RouteButtonConfig {
  final String routeName;
  final String displayName;
  const RouteButtonConfig(this.routeName, this.displayName);
  factory RouteButtonConfig.fromRouteName(String val) => RouteButtonConfig(
        val,
        val.toRouteName(),
      );
}

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/buttons': (context) => const ButtonsScreen(),
    '/cards': (context) => const CardsScreen(),
    '/progress_indicators': (context) => const ProgressIndicatorsScreen(),
    '/flip_boards': (context) => const FlipBoardsScreen(),
    '/page_view': (context) => const PageViewScreen(),
    '/list_tile': (context) => const ListTileScreen(),
    '/input': (context) => const InputScreen(),
    '/expandable': (context) => const ExpandableScreen(),
    '/ink': (context) => const InkScreen(),
  };

  static List<RouteButtonConfig> get buttons =>
      routes.entries.map((e) => RouteButtonConfig.fromRouteName(e.key)).toList()
        ..removeWhere((x) => x.displayName.isEmpty);
}
