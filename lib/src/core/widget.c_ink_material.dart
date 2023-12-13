import 'package:flutter/material.dart';

import 'theme.couver_theme.dart';

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
    super.key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.borderRadius,
    this.innerRadius,
    this.materialOption = const CInkMaterialOption(),
    this.clipBehavior = Clip.none,
    this.decoration,
    this.autoRemoveFocus = true,
  });
  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final BorderRadius? borderRadius;
  final BorderRadius? innerRadius;
  final CInkMaterialOption materialOption;
  final Clip clipBehavior;

  final BoxDecoration? decoration;

  /// Remove focus when tapped
  final bool autoRemoveFocus;

  bool get _enabled =>
      onTap != null ||
      onLongPress != null ||
      onDoubleTap != null ||
      onTapDown != null;

  void _handleTapDown(TapDownDetails details) {
    if (autoRemoveFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    onTapDown?.call(details);
  }

  @override
  Widget build(BuildContext context) {
    if (materialOption.inkOnTop) {
      return AnimatedContainer(
        clipBehavior: clipBehavior,
        decoration: decoration,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
        child: Stack(
          children: [
            child ?? const SizedBox.shrink(),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_enabled,
                child: Material(
                  type: MaterialType.transparency,
                  borderRadius: innerRadius,
                  child: InkWell(
                    borderRadius: innerRadius,
                    onTapDown: _enabled ? _handleTapDown : onTapDown,
                    onTapCancel: onTapCancel,
                    onTap: onTap,
                    onDoubleTap: onDoubleTap,
                    onLongPress: onLongPress,
                    highlightColor: materialOption.highlightColor ??
                        Theme.of(context).highlightColor,
                    splashColor: materialOption.splashColor ??
                        Theme.of(context).splashColor,
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
        ),
      );
    }
    return Container(
      clipBehavior: clipBehavior,
      decoration: decoration,
      child: Material(
        borderRadius: innerRadius,
        // color: color ?? Colors.transparent,
        type: MaterialType.transparency,
        // clipBehavior: clipBehavior,
        child: InkWell(
          borderRadius: innerRadius,
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
