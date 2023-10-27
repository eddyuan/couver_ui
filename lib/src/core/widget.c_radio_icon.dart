import 'package:flutter/material.dart';

class CRadioIcon extends StatelessWidget {
  const CRadioIcon({
    super.key,
    required this.selected,
    this.enabled = true,
    this.size = 20,
    this.color,
    this.disabledColor,
  });

  final bool enabled;
  final bool selected;
  final double size;
  final Color? color;
  final Color? disabledColor;

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
              ? (color ?? Theme.of(context).colorScheme.primary)
              : (disabledColor ??
                  Theme.of(context).disabledColor.withOpacity(0.4)),
        ),
      ),
    );
  }
}
