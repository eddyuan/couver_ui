import 'package:couver_ui/couver_ui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        title: const Text('Couver UI Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CButton.filled(
            text: "Buttons",
            onPressed: () {
              Navigator.pushNamed(context, '/buttons');
            },
          ),
          CButton.filled(
            text: "Cards",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
