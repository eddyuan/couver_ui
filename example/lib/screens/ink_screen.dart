import 'package:couver_ui/couver_ui.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class InkScreen extends StatelessWidget {
  const InkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 6,
                color: Colors.blue,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sample"),
                  CButton.filled(
                    text: "BTN",
                    onPressed: () {
                      print("Button Press");
                    },
                  ),
                ],
              ),
            ),
          ),
          CInk(
            onTap: () {},
            borderColor: Colors.red,
            borderWidth: 6.0,
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
            materialOption: const CInkMaterialOption(inkOnTop: false),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sample"),
                  CButton.filled(
                    text: "BTN",
                    onPressed: () {
                      print("Button Press");
                    },
                  ),
                ],
              ),
            ),
          ),
          CInk(
            onTap: () {},
            borderWidth: 12.0,
            borderRadius: BorderRadius.circular(40),
            borderGradient: const LinearGradient(colors: [
              Colors.orange,
              Colors.purple,
            ]),
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text("CInk - Gradient"),
            ),
          )
        ],
      ),
    );
  }
}
