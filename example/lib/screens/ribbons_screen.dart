import 'package:couver_ui/couver_ui.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class RibbonsScreen extends StatelessWidget {
  const RibbonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: CCard(
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(64),
                    child: Text("Ribbon"),
                  ),
                ),
              ),
              // Positioned(
              //   // right: 24 - 6,
              //   // top: 24 + 12,
              //   child: CRibbon.rrect(
              //     child: Text('123123'),
              //   ),
              // ),
              Positioned(
                // right: 24 - 6,
                // top: 24 + 12,
                child: CRRectContainer(
                  child: Text('123123'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
