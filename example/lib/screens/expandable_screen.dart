import 'package:couver_ui/couver_ui.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class ExpandableScreen extends StatelessWidget {
  const ExpandableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        children: [
          CExpandable(
            header: (expanded) => Text(expanded ? "Expanded" : "Collapsed"),
            child: const Text('Expand Child'),
          ),
        ],
      ),
    );
  }
}
