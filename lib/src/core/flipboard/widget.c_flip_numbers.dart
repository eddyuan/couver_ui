import "package:flutter/material.dart";

import "widget.c_flip_board.dart";

class CFlipNumbers extends StatelessWidget {
  const CFlipNumbers({
    super.key,
    // Specific to numbers -------------------------------------------------------
    this.digits = 1,
    this.value,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.numberBuilder,
    this.boardBuilder,
    this.durationPerFlip = const Duration(milliseconds: 100),
    this.reflectionColor = const Color(0x40ffffff),
    this.shadeColor = const Color(0x14000000),
    this.containerDecoration = const BoxDecoration(),
    this.dividerGap = 0,
    this.perspective = 0.006,
    this.showZeroAtBegining = true,
    this.maxItemHeight = 60,
    this.maxItemWidth = 50,
    this.maxItemGap = 8,
    this.keepAspectRatio = true,
  });

  // Specific to numbers -------------------------------------------------------
  final int digits;
  final int? value;

  /// The alighment for the row
  final MainAxisAlignment mainAxisAlignment;

  final MainAxisSize mainAxisSize;

  /// You can provide you own number widget
  final Widget Function(BuildContext context, String number)? numberBuilder;

  // Pass to FlipBoard -------------------------------------------------------
  /// Use if want the duration to depend on each flip
  final Duration? durationPerFlip;

  /// Do not use boxshadow in the [borderBuilder]
  final Widget Function(
    BuildContext context,
    Widget child,
    BoxConstraints itemConstrains,
  )? boardBuilder;

  /// For the container of each digit
  final Decoration containerDecoration;

  /// Add a highLight to the bottom portion
  final Color? reflectionColor;

  /// Add a shadow to the top portion
  final Color? shadeColor;

  /// Space between top and bottom portion
  final double dividerGap;

  /// The perspectiv for the board
  final double perspective;

  /// Show 0s at front of the numbers?
  final bool showZeroAtBegining;

  /// This is the desired height of a number, it will shrink according to available space and aspectratio
  final double maxItemHeight;

  /// This is the desired width of a number, it will shrink according to available space
  final double maxItemWidth;

  /// This is the desired gap of a number, it will shrink according to available space
  final double maxItemGap;

  final bool keepAspectRatio;

  Widget _defaultBoardBuilder(
    BuildContext context,
    Widget child,
    BoxConstraints constraints,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Center(child: child),
    );
  }

  Widget _boardBuilder(
    BuildContext context,
    Widget child,
    BoxConstraints constraints,
  ) {
    return boardBuilder?.call(context, child, constraints) ??
        _defaultBoardBuilder(context, child, constraints);
  }

  Widget _defaultNumberBuilder(
    BuildContext context,
    String number,
  ) {
    return Text(
      number,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }

  Widget _numberBuilder(
    BuildContext context,
    String number,
  ) {
    return numberBuilder?.call(context, number) ??
        _defaultNumberBuilder(context, number);
  }

  @override
  Widget build(BuildContext context) {
    final indexes = List.generate(digits, (i) {
      if (value == null) return null;
      final String valStr = value.toString();
      final int takenInt = valStr.length - digits + i;
      if (takenInt >= 0) {
        return int.parse(valStr[takenInt]);
      } else {
        return showZeroAtBegining ? 0 : null;
      }
    });

    final List<Widget> numberWidgets = List.generate(
      10,
      (index) => FittedBox(
        fit: BoxFit.scaleDown,
        child: _numberBuilder(
          context,
          index.toString(),
        ),
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final double factor = (constraints.maxWidth /
                ((maxItemGap * (indexes.length - 1)) +
                    (maxItemWidth * indexes.length)))
            .clamp(0, double.infinity);
        final double targetWidth =
            (maxItemWidth * factor).clamp(1, maxItemWidth);
        final double targetGap = (maxItemGap * factor).clamp(0, maxItemGap);

        final double targetHeight = keepAspectRatio
            ? targetWidth / maxItemWidth * maxItemHeight
            : maxItemHeight;

        final BoxConstraints itemConstrains = BoxConstraints(
          maxHeight: targetHeight,
          maxWidth: targetWidth,
          minWidth: 1,
          minHeight: 1,
        );

        return Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            indexes.length,
            (i) => Padding(
              padding:
                  i > 0 ? EdgeInsets.only(left: targetGap) : EdgeInsets.zero,
              child: CFlipBoard(
                reflectionColor: reflectionColor,
                shadeColor: shadeColor,
                targetIndex: indexes[i],
                durationPerFlip: durationPerFlip,
                maxLoop: indexes.length - i + 6,
                loopsOnInit: indexes.length - i - 1,
                boardBuilder: (context, child) => ConstrainedBox(
                  constraints: itemConstrains,
                  child: _boardBuilder(context, child, itemConstrains),
                ),
                items: numberWidgets,
              ),
            ),
          ),
        );
      },
    );
  }
}
