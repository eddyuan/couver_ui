import 'package:flutter/material.dart';

class CAnimatedNumber extends StatelessWidget {
  const CAnimatedNumber({
    super.key,
    required this.value,
    this.animateOnChange = true,
    this.animateOnInit = true,
  });
  final int value;

  final bool animateOnChange;
  final bool animateOnInit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}
