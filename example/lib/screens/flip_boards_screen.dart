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

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      20,
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
              CFlipBoard(
                items: items,
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
                    border: const GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.red,
                        ],
                        begin: Alignment.topCenter,
                      ),
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
                    // flipBoardIndex = (flipBoardIndex + 1) ;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
