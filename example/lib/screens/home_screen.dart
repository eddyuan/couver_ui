import 'package:couver_ui/couver_ui.dart';
import 'package:example/routes.dart';
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
        children: AppRoutes.buttons
            .map(
              (e) => CButton.filled(
                text: e.displayName,
                onPressed: () {
                  Navigator.pushNamed(context, e.routeName);
                },
              ),
            )
            .toList(),
        // [
        //   CButton.filled(
        //     text: "Buttons",
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/buttons');
        //     },
        //   ),
        //   CButton.filled(
        //     text: "Cards",
        //     onPressed: () {},
        //   ),
        // ],
      ),
    );
  }
}
