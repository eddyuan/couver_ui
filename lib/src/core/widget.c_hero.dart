import "package:flutter/material.dart";

class CHero extends StatelessWidget {
  const CHero({
    required this.child,
    this.tag,
    this.transitionOnUserGestures = true,
    super.key,
  });
  final Widget child;
  final String? tag;
  final bool transitionOnUserGestures;

  @override
  Widget build(BuildContext context) {
    if ((tag ?? "").isNotEmpty) {
      return Hero(
        tag: tag!,
        transitionOnUserGestures: transitionOnUserGestures,
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      );
    }
    return child;
  }
}
