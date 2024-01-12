import 'package:couver_ui/couver_ui.dart';

import 'package:flutter/material.dart';


class CExpandableImageHeader extends StatelessWidget {
  const CExpandableImageHeader({
    this.image,
    required this.text,
    this.imageGap,
    super.key,
  });

  final Widget? image;
  final String text;
  final double? imageGap;

  @override
  Widget build(BuildContext context) {
    final double imageGap = this.imageGap ?? CouverTheme.of(context).gutter * 3;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: CouverTheme.of(context).pagePadding),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 68),
        child: Row(
          children: [
            if (image != null)
              Padding(
                padding: EdgeInsets.only(right: imageGap),
                child: image,
              ),
            Expanded(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ExpandPosition { top, bottom }

class CExpandable extends StatefulWidget {
  const CExpandable({
    this.platformStyle,
    this.header,
    // this.elevation,
    this.child,
    this.collapsedChild,
    this.showIcon = true,
    this.curve,
    this.duration,
    this.childAlignment = Alignment.topCenter,
    this.onExpandChanged,
    this.initialExpanded = false,
    this.icon,
    this.useButton = false,
    this.buttonExpandedText,
    this.buttonCollapsedText,
    this.buttonColor,
    this.buttonSize,
    this.buttonMinHeight = 44,
    this.expandPosition = ExpandPosition.bottom,
    this.showDivider = false,
    this.arrowPadding,
    this.arrowAlignment = CrossAxisAlignment.center,
    this.arrowSize = 20,
    this.extraTop,
    this.extraBottom,
    super.key,
  })  : assert(header != null || useButton);

  final PlatformStyle? platformStyle;

  /// The bar at the top for click
  final Widget Function(bool expanded)? header;

  /// Show when expanded
  final Widget? child;

  /// Show when not expanded
  final Widget? collapsedChild;
  // final double? elevation;
  final bool showIcon;
  final Curve? curve;
  final Duration? duration;

  /// For crossfading children to align [child] & [collapsedChild]
  final Alignment childAlignment;

  /// Triggered when expansion changed
  final ValueChanged<bool>? onExpandChanged;

  /// Is is initially expanded?
  final bool initialExpanded;

  /// Use a custom icon instead of the arrow, this icon will rotate 180 degree
  final Widget? icon;

  final bool useButton;
  final String? buttonExpandedText;
  final String? buttonCollapsedText;
  final Color? buttonColor;
  final BtnSize? buttonSize;
  final double buttonMinHeight;
  final ExpandPosition expandPosition;
  final bool showDivider;
  final EdgeInsetsGeometry? arrowPadding;
  final CrossAxisAlignment arrowAlignment;
  final double arrowSize;

  final Widget? extraTop;
  final Widget? extraBottom;

  // /// This will replace the header
  // final bool useButton;
  // final Color? buttonColor;

  @override
  State<CExpandable> createState() => _CExpandableState();
}

class _CExpandableState extends State<CExpandable> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void onToggle() {
    setState(() {
      expanded = !expanded;
    });
    widget.onExpandChanged?.call(expanded);
  }

  late bool expanded = widget.initialExpanded;
  late final Curve curve =
      widget.curve ?? CouverTheme.of(context).animationSizeCurve;
  late final Duration duration =
      widget.duration ?? CouverTheme.of(context).animationSizeDuration;
  late final EdgeInsetsGeometry arrowPadding =
      widget.arrowPadding ?? EdgeInsets.all(CouverTheme.of(context).gutter * 3);

  Widget _buildExpansion() {
    return AnimatedCrossFade(
      alignment: widget.childAlignment,
      firstChild: widget.collapsedChild ?? const SizedBox.shrink(),
      secondChild: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showDivider &&
              widget.expandPosition == ExpandPosition.bottom)
            const Divider(),
          widget.child ?? const SizedBox.shrink(),
          if (widget.showDivider && widget.expandPosition == ExpandPosition.top)
            const Divider(),
        ],
      ),
      firstCurve: curve,
      secondCurve: curve,
      sizeCurve: curve,
      crossFadeState:
          expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.expandPosition == ExpandPosition.top) _buildExpansion(),
        if (widget.extraTop != null) widget.extraTop!,
        widget.useButton
            ? CButton(
                platformStyle: widget.platformStyle ?? PlatformStyle.cupertino,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                borderRadius: 0,
                onPressed: onToggle,
                color: widget.buttonColor,
                size: (widget.buttonSize ?? BtnSize.sm).copyWith(
                  minHeight: widget.buttonMinHeight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      expanded
                          ? widget.buttonExpandedText ?? 'Hide'
                          : widget.buttonCollapsedText ?? 'Show',
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: CouverTheme.of(context).gutter),
                      child: AnimatedRotation(
                        turns: expanded ? -0.5 : 0,
                        duration: duration,
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: widget.arrowSize,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : CInk(
                style: widget.platformStyle ?? PlatformStyle.auto,
                onTap: onToggle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.arrowAlignment,
                  children: [
                    if (widget.header != null)
                      Expanded(
                        child: widget.header!(expanded),
                      ),
                    if (widget.showIcon)
                      Padding(
                        padding: arrowPadding,
                        child: AnimatedRotation(
                          turns: expanded ? -0.5 : 0,
                          duration: duration,
                          child: AnimatedOpacity(
                            duration: duration,
                            curve: curve,
                            opacity: expanded ? 1 : 0.6,
                            child: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: widget.arrowSize,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
        if (widget.extraBottom != null) widget.extraBottom!,
        if (widget.expandPosition == ExpandPosition.bottom) _buildExpansion(),
        // ],
      ],
    );
  }
}
