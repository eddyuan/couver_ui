import 'package:flutter/material.dart';

class CRadioIcon extends StatelessWidget {
  const CRadioIcon({
    super.key,
    required this.selected,
    this.enabled = true,
    this.size = 20,
  });

  final bool enabled;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: selected ? size / 3.5 : 1,
          color: selected && enabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).disabledColor.withOpacity(0.4),
        ),
      ),
    );
  }
}
