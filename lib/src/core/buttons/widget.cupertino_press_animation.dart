import 'package:flutter/material.dart';

// class CCupertinoPressAnimationController extends ValueNotifier<double> {
//   late AnimationController _animationController;

//   CCupertinoPressAnimationController() : super(1.0) {
//     _animationController = AnimationController(
//       vsync: ValueNotifier(this),
//       duration: Duration(seconds: 1),
//     );
//     _animationController.addListener(() {
//       value = _animationController.value;
//     });
//   }

//   void animate(bool toVisible) {
//     double fromOpacity = value;
//     double toOpacity = toVisible ? 0.5 : 1.0;
//     _animationController
//       ..duration = Duration(seconds: toVisible ? 1 : 2)
//       ..reset()
//       ..forward(from: fromOpacity, to: toOpacity);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

class CCupertinoPressAnimation extends StatefulWidget {
  const CCupertinoPressAnimation({
    super.key,
    this.animate = true,
    this.child,
  });

  @override
  State<CCupertinoPressAnimation> createState() =>
      _CCupertinoPressAnimationState();

  final bool animate;
  final Widget? child;
}

class _CCupertinoPressAnimationState extends State<CCupertinoPressAnimation> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
