import 'package:couver_ui/couver_ui.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class ListTileScreen extends StatefulWidget {
  const ListTileScreen({super.key});

  @override
  State<ListTileScreen> createState() => _ListTileScreenState();
}

class _ListTileScreenState extends State<ListTileScreen> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Screen(
      pageName: "ListTiles",
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CListTile(
              titleText: 'Title text',
              subtitleText: 'Subtitle text',
              leadingIcon: Icons.ac_unit,
              trailing: Icon(Icons.access_alarm_outlined),
            ),
            ...List.generate(
              3,
              (index) => CListTile.radio(
                titleText: 'Radio style $index',
                subtitleText: 'Subtitle text',
                leadingIcon: Icons.radio_button_checked,
                selected: selected == index,
                onTap: () {
                  setState(() {
                    selected = index;
                  });
                },
              ),
            ).toList(),
            ...List.generate(
              3,
              (index) => CListTile(
                titleText: 'Check style $index',
                subtitleText: 'Subtitle text',
                leadingIcon: Icons.check_circle,
                selected: selected == index,
                onTap: () {
                  setState(() {
                    selected = index;
                  });
                },
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }
}
