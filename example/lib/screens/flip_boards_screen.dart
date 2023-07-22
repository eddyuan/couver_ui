import 'package:couver_ui/couver_ui.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class FlipBoardsScreen extends StatefulWidget {
  const FlipBoardsScreen({super.key});

  @override
  State<FlipBoardsScreen> createState() => _FlipBoardsScreenState();
}

class _FlipBoardsScreenState extends State<FlipBoardsScreen> {
  int flipBoardIndex = 1;
  int flipNumbersValue = 12322;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      10,
      (index) => FittedBox(
        child: Text(
          "Item $index",
          style: const TextStyle(
            height: 1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
    return Screen(
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text("Single FlipBoard"),
          const SizedBox(height: 16),
          Text("Index: $flipBoardIndex"),
          const SizedBox(height: 16),
          Slider(
            value: flipBoardIndex.toDouble(),
            min: -100,
            max: 100,
            onChanged: (value) {
              setState(() {
                flipBoardIndex = value.round();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CButton.filled(
                text: "-1",
                onPressed: () {
                  setState(() {
                    flipBoardIndex--;
                  });
                },
              ),
              const SizedBox(width: 16),
              CFlipBoard.builder(
                itemBuilder: (index) => items[index],
                itemCount: items.length,
                targetIndex: flipBoardIndex,
                shadeColor: Colors.black26,
                reflectionColor: Colors.white54,
                dividerGap: 1,
                boardBuilder: (context, child) => Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                    border: GradientBoxBorder(
                      gradient: child != null
                          ? const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.red,
                              ],
                              begin: Alignment.topCenter,
                            )
                          : null,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: child,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              CButton.filled(
                text: "+1",
                onPressed: () {
                  setState(() {
                    flipBoardIndex++;
                  });
                },
              ),
            ],
          ),
          Slider(
            value: flipNumbersValue.toDouble(),
            min: 0,
            max: 100000,
            onChanged: (value) {
              setState(() {
                flipNumbersValue = value.round();
              });
            },
          ),
          CFlipNumbers(
            digits: 5,
            value: flipNumbersValue,
            showZeroAtBeginning: false,
            boardBuilder: (context, child, itemConstrains) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: child != null ? Colors.white : Colors.transparent,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
