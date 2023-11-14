import "dart:async";

import "package:flutter/material.dart";

import 'widget.flip_card.dart';

class FlipCardItem {
  const FlipCardItem({
    required this.front,
    this.back,
  });
  final Widget front;
  final Widget? back;
}

class FlipCards extends StatefulWidget {
  const FlipCards({
    Key? key,
    required this.cardItems,
    this.flipped = false,
    this.interval = const Duration(milliseconds: 50),
  }) : super(key: key);

  final List<FlipCardItem> cardItems;
  final bool flipped;
  final Duration interval;

  @override
  State<FlipCards> createState() => _FlipCardsState();
}

class _FlipCardsState extends State<FlipCards> {
  List<bool> flippedList = [];
  Timer? flipTimer;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    flippedList =
        List.generate(widget.cardItems.length, (index) => widget.flipped);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlipCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cardItems.length != widget.cardItems.length) {
      if (widget.cardItems.isEmpty) {
        setState(() {
          flippedList = [];
        });
      } else if (oldWidget.cardItems.length < widget.cardItems.length) {
        if (flippedList.isNotEmpty) {
          setState(() {
            flippedList = [
              ...flippedList,
              ...List.generate(
                  widget.cardItems.length - oldWidget.cardItems.length,
                  (index) => flippedList.last)
            ];
          });
        } else {
          setState(() {
            flippedList = List.generate(
                widget.cardItems.length, (index) => widget.flipped);
          });
        }
      } else {
        flippedList.sublist(0, widget.cardItems.length);
        setState(() {});
      }
    }
    if (oldWidget.flipped != widget.flipped) {
      doAnimate();
    }
  }

  @override
  void dispose() {
    flipTimer?.cancel();
    super.dispose();
  }

  void doAnimate() {
    flipTimer?.cancel();
    flipTimer = Timer.periodic(widget.interval, (timer) {
      final foundIndex = flippedList.indexOf(!widget.flipped);
      if (foundIndex > -1) {
        flippedList[foundIndex] = widget.flipped;
        setState(() {});
      } else {
        flipTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.cardItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Padding(
          padding: EdgeInsets.zero,
          child: item.back != null
              ? FlipCard(
                  front: item.front,
                  back: item.back ?? const SizedBox(),
                  flipped:
                      index < flippedList.length ? flippedList[index] : false,
                )
              : item.front,
        );
      }).toList(),
    );
  }
}
