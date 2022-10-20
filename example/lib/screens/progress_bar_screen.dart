import 'package:couver_ui/couver_ui.dart';
import 'package:flutter/material.dart';

class ProgressBarScreen extends StatefulWidget {
  const ProgressBarScreen({super.key});

  @override
  State<ProgressBarScreen> createState() => _ProgressBarScreenState();
}

class _ProgressBarScreenState extends State<ProgressBarScreen> {
  double _value = 0.1;
  bool indeterminate = false;
  double? get value => indeterminate ? null : _value;

  static const double kGap = 40;

  void addVal() {
    setState(() {
      _value = (_value + 0.1) % 1;
    });
  }

  void toggleIndeterminate() {
    setState(() {
      indeterminate = !indeterminate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(),
      body: ListView(
        children: [
          CListTile(
            title: const Text("Add Value"),
            subtitle: Text(value?.toStringAsFixed(5) ?? value.toString()),
            trailing: Icon(Icons.add),
            onTap: addVal,
          ),
          CListTile(
            title: const Text("Indeterminate"),
            trailing: Switch.adaptive(
              value: indeterminate,
              onChanged: (val) => {},
            ),
            onTap: toggleIndeterminate,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: kGap),
                CLinearProgressIndicator(
                  borderRadius: BorderRadius.circular(8),
                  value: value,
                  minHeight: 8,
                  color: Colors.red,
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                ),
                const SizedBox(height: kGap),
                CLinearProgressIndicator(
                  value: value,
                  color: Colors.red,
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                ),
                const SizedBox(height: kGap),
                CLinearProgressIndicator.divided(
                  color: Colors.red,
                  backgroundColor: Colors.black,
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  step: value == null ? null : value! * 5,
                  steps: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
