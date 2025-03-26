import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'widget.c_skeleton_box.dart';

class CSkeletonText extends StatelessWidget {
  const CSkeletonText({
    super.key,
    this.style,
    this.lines = 1,
    this.lastLineWidth = 0.6,
    this.color,
    this.color2,
    this.textAlign,
    this.borderRadius,
  });
  final TextStyle? style;
  final int lines;

  /// <=1: Fraction, >1 : Size
  final double lastLineWidth;

  /// 容器的颜色
  final Color? color;
  final Color? color2;

  final TextAlign? textAlign;

  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    final AlignmentGeometry boxAlign = _getAlignmentFromTextAlign(textAlign);
    final TextStyle ds = DefaultTextStyle.of(context)
        .style
        .merge(style?.copyWith(inherit: true));
    final double fs = ds.fontSize ?? 14;
    final double lh = ds.height ?? 1.4;
    final double py = math.max(0, fs * (lh - 1) / 2);
    final EdgeInsets pv = EdgeInsets.symmetric(vertical: py);
    return LayoutBuilder(
      builder: (ctx, cst) {
        final double lastRowWidth = lastLineWidth > 1
            ? lastLineWidth
            : (cst.maxWidth.isFinite
                    ? cst.maxWidth
                    : (MediaQuery.of(context).size.width - 24)) *
                lastLineWidth;

        final lastRowWidget = SizedBox(
          width: lastRowWidth,
          child: Align(
            alignment: boxAlign,
            child: Padding(
              padding: pv,
              child: CSkeletonBox(
                height: fs,
                width: lastRowWidth,
                borderRadius: BorderRadius.circular(4),
                color: color,
                color2: color2,
              ),
            ),
          ),
        );

        /// 只有一行不要渲染Column
        if (lines <= 1) {
          return lastRowWidget;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
              lines - 1,
              (index) => Padding(
                padding: pv,
                child: CSkeletonBox(
                  height: fs,
                  borderRadius: BorderRadius.circular(4),
                  color: color,
                  color2: color2,
                ),
              ),
            ),
            lastRowWidget,
          ],
        );
      },
    );
  }
}

AlignmentGeometry _getAlignmentFromTextAlign([TextAlign? textAlign]) {
  switch (textAlign) {
    case TextAlign.left:
      return Alignment.centerLeft;
    case TextAlign.right:
      return Alignment.centerRight;
    case TextAlign.center:
      return Alignment.center;
    case TextAlign.start:
      return AlignmentDirectional.centerStart;
    case TextAlign.end:
      return AlignmentDirectional.centerEnd;
    default:
      return AlignmentDirectional
          .centerStart; // Default to center if not specified
  }
}
