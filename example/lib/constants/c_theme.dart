import 'dart:math';

import 'package:flutter/material.dart';

class CTheme {
  static const double padding = 16;
  static rColor(int? index) {
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.brown,
      Colors.indigo,
      Colors.cyan,
      Colors.orange,
    ];
    final int i = (index ?? Random().nextInt(20)) % colors.length;
    return colors[i];
  }
}
