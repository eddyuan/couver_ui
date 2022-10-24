import 'package:couver_ui/couver_ui.dart';
import 'package:example/routes.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      pageName: "Couver UI Examples",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
        ),
      ),
    );
  }
}
