import 'package:flutter/material.dart';

class CSkeletonBox extends StatefulWidget {
  const CSkeletonBox({
    super.key,
    this.color,
    this.color2,
    this.borderRadius,
    this.width,
    this.height,
    this.child,
    this.loading = true,
  });

  final Color? color;
  final Color? color2;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final bool loading;

  @override
  State<CSkeletonBox> createState() => _CSkeletonBoxState();
}

class _CSkeletonBoxState extends State<CSkeletonBox>
    with SingleTickerProviderStateMixin {
  Color get color {
    if (widget.color != null) return widget.color!;
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return Colors.blueGrey.shade50.withAlpha(30);
    }
    return Colors.blueGrey.shade800.withAlpha(30);
  }

  // widget.color ?? Theme.of(context).colorScheme.surfaceVariant;
  Color get color2 => widget.color2 ?? color.withAlpha(10);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<Color?> _colorAnimation = ColorTween(
    begin: color,
    end: color2,
  ).animate(_controller);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.loading) {
      return widget.child ?? const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
