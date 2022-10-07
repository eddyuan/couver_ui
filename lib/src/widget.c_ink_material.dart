import 'package:couver_ui/src/theme.couver_theme.dart';
import 'package:flutter/material.dart';

class CInkMaterialOption {
  const CInkMaterialOption({
    this.highlightColor,
    this.splashColor,
    this.splashFactory,
    this.splashRadius,
    this.focusColor,
    this.inkOnTop = true,
  });

  /// The [highlightColor] for [Material] style
  final Color? highlightColor;

  /// The [splashColor] for [Material] style
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? splashRadius;
  final Color? focusColor;

  /// Put ink on top of content? the ink will block all actions
  final bool inkOnTop;
}

class CInkMaterial extends StatelessWidget {
  const CInkMaterial({
    Key? key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.borderRadius,
    this.materialOption = const CInkMaterialOption(),
    this.clipBehavior = Clip.none,
    this.decoration,
  }) : super(key: key);
  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final BorderRadius? borderRadius;
  final CInkMaterialOption materialOption;
  final Clip clipBehavior;

  final Decoration? decoration;

  bool get _enabled =>
      onTap != null ||
      onLongPress != null ||
      onDoubleTap != null ||
      onTapDown != null;

  @override
  Widget build(BuildContext context) {
    // if (child != null) {
    if (materialOption.inkOnTop) {
      return Stack(
        children: [
          Container(
            clipBehavior: clipBehavior,
            decoration: decoration,
            child: Center(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_enabled,
              child: Material(
                type: MaterialType.transparency,
                borderRadius: borderRadius,
                child: InkWell(
                  borderRadius: borderRadius,
                  onTapDown: onTapDown,
                  onTapCancel: onTapCancel,
                  onTap: onTap,
                  onDoubleTap: onDoubleTap,
                  onLongPress: onLongPress,
                  highlightColor: materialOption.highlightColor ??
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  splashColor: materialOption.splashColor ??
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  splashFactory: materialOption.splashFactory ??
                      CouverTheme.of(context).splashFactory,
                  focusColor: materialOption.focusColor,
                  radius: materialOption.splashRadius,
                  enableFeedback: true,
                  // child: child!,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      clipBehavior: clipBehavior,
      decoration: decoration,
      child: Material(
        borderRadius: borderRadius,
        // color: color ?? Colors.transparent,
        type: MaterialType.transparency,
        // clipBehavior: clipBehavior,
        child: InkWell(
          borderRadius: borderRadius,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          highlightColor: materialOption.highlightColor ??
              Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          splashColor: materialOption.splashColor ??
              Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          splashFactory: materialOption.splashFactory ??
              CouverTheme.of(context).splashFactory,
          focusColor: materialOption.focusColor,
          radius: materialOption.splashRadius,
          enableFeedback: true,
          child: child,
        ),
      ),
    );
    // }
    // return const SizedBox.shrink();
  }
}
