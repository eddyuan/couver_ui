import 'package:flutter/material.dart';

enum CupertinoInkStyle {
  opaque,
  shade,
  scale,
}

class CInkCupertinoOption {
  const CInkCupertinoOption({
    this.tapOpaque = 0.5,
    this.tapScale = 0.95,
    this.tapShadeColor,
    this.cupertinoInkStyle = CupertinoInkStyle.opaque,
  });
// Cupertino style
  final Color? tapShadeColor;

  /// Define which style to use [opaque] or [shade] or [scale]
  final CupertinoInkStyle cupertinoInkStyle;

  /// The opacity on click when cupertinoInkStyle is [CupertinoInkStyle.opaque]
  final double tapOpaque;

  /// The opacity on click when cupertinoInkStyle is [CupertinoInkStyle.scale]
  final double tapScale;
}

class CInkCupertino extends StatefulWidget {
  const CInkCupertino({
    Key? key,
    this.child,
    // basic function
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.borderRadius,
    this.cupertinoOption = const CInkCupertinoOption(),
    this.clipBehavior = Clip.none,
    this.decoration,
  }) : super(key: key);

  final Widget? child;
  // basic dunction
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final BorderRadius? borderRadius;
  final CInkCupertinoOption cupertinoOption;

  final Clip clipBehavior;
  final Decoration? decoration;
  @override
  State<CInkCupertino> createState() => _CInkCupertinoState();
}

class _CInkCupertinoState extends State<CInkCupertino>
    with SingleTickerProviderStateMixin {
  late final Duration kPressDuration;
  late final Duration kReleaseDuration;
  late final Tween<double> _opacityTween;

  late final double _initialTween;
  late final double _targetTween;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  Color _tapShadeColor(ThemeData theme) =>
      widget.cupertinoOption.tapShadeColor ??
      theme.colorScheme.onSurface.withOpacity(0.1);

  bool get _enabled =>
      widget.onTap != null ||
      widget.onLongPress != null ||
      widget.onDoubleTap != null ||
      widget.onTapDown != null;

  @override
  void initState() {
    super.initState();
    if (widget.cupertinoOption.cupertinoInkStyle == CupertinoInkStyle.opaque) {
      _initialTween = 1;
      _targetTween = widget.cupertinoOption.tapOpaque;
      kPressDuration = Duration.zero;
      kReleaseDuration = const Duration(milliseconds: 600);
    } else if (widget.cupertinoOption.cupertinoInkStyle ==
        CupertinoInkStyle.shade) {
      _initialTween = 0;
      _targetTween = 1;
      kPressDuration = Duration.zero;
      kReleaseDuration = const Duration(milliseconds: 600);
    } else {
      _initialTween = 1;
      _targetTween = widget.cupertinoOption.tapScale;
      kPressDuration = const Duration(milliseconds: 100);
      kReleaseDuration = const Duration(milliseconds: 300);
    }
    _opacityTween = Tween<double>(begin: _initialTween);

    _animationController = AnimationController(
      duration: Duration.zero,
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(CInkCupertino old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = _targetTween;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails details) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    print("animated");
    // _animationController.reset();
    if (_buttonHeldDown) {
      // if (kPressDuration == Duration.zero) {
      //   _animationController.value = 1.0;
      // } else {
      //   _animationController.stop();
      //   _animationController.animateTo(1.0,
      //       duration: kPressDuration, curve: Curves.decelerate);
      // }
      _animationController.value = 1.0;
    } else {
      // _animationController.stop();
      _animationController.animateTo(0.0,
          duration: kReleaseDuration, curve: Curves.decelerate);
    }
    // if (_animationController.isAnimating) return;
    // final bool wasHeldDown = _buttonHeldDown;
    // final TickerFuture ticker = _buttonHeldDown
    //     ? _animationController.animateTo(1.0,
    //         duration: kPressDuration, curve: Curves.easeInOutCubicEmphasized)
    //     : _animationController.animateTo(0.0,
    //         duration: kReleaseDuration, curve: Curves.easeOutCubic);
    // ticker.then<void>((void value) {
    //   if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child is Widget) {
      final Widget child_ = Container(
        clipBehavior:
            widget.decoration == null ? Clip.none : widget.clipBehavior,
        decoration: widget.decoration,
        child: widget.child,
      );

      late Widget animationWrapper;
      switch (widget.cupertinoOption.cupertinoInkStyle) {
        case CupertinoInkStyle.opaque:
          animationWrapper = FadeTransition(
            opacity: _opacityAnimation,
            child: child_,
          );
          break;
        case CupertinoInkStyle.scale:
          animationWrapper = ScaleTransition(
            scale: _opacityAnimation,
            child: child_,
          );
          break;
        default:
          animationWrapper = LayoutBuilder(
            builder: (context, constraint) {
              return Stack(
                children: [
                  SizedBox(
                    width: constraint.maxWidth,
                    child: child_,
                  ),
                  // Center(child: child_),
                  // if (_enabled)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: widget.borderRadius,
                            color: _tapShadeColor(Theme.of(context)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
      }
      return InkWell(
        // behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? _handleTapDown : null,
        onTapUp: _enabled ? _handleTapUp : null,
        onTapCancel: _enabled ? _handleTapCancel : null,
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onLongPress: widget.onLongPress,
        excludeFromSemantics: true,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        child: animationWrapper,
      );
      // }
      // return widget.child!;
    }
    return const SizedBox.shrink();
  }
}
