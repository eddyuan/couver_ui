// ignore_for_file: prefer_const_constructors

import 'package:couver_ui/couver_ui.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class InputScreen extends StatelessWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CTextFormField.outlined(
              labelText: 'CTextFormField.outlined',
              clearable: true,
            ),
            SizedBox(height: 16),
            CTextFormField(
              labelText: 'CTextFormField',
              clearable: true,
            ),
            SizedBox(height: 16),
            CTextFormField(
              border: UnderlineInputBorder(),
              labelText: 'CTextFormField',
              clearable: true,
              filled: true,
            ),
            SizedBox(height: 16),
            CTextFormField.outlined(
              labelText: 'CTextFormField',
              clearable: true,
              enabled: false,
            ),
            SizedBox(height: 16),
            CTextFormField.outlined(
              labelText: 'CTextFormField',
              clearable: true,
              // enabled: false,
              errorText: "123",
            ),
            CTextFormField.outlined(
              labelText: 'CTextFormField',
              clearable: true,
              loading: true,
              // enabled: false,
              // errorText: "123",
            ),
            Divider(height: 48),
            Text('Original'),
            TextFormField(
              decoration: InputDecoration(
                labelText: '123',
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '123',
                border: COutlineInputBorder(),
                enabledBorder: const COutlineInputBorder(),
                // enabledBorder: COutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '123',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
