import 'package:couver_ui/couver_ui.dart';
import 'package:flutter/material.dart';

class TextsScreen extends StatelessWidget {
  const TextsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CRichText(
              "data <b>bold</b> <small>small</small> <u>UnderLine</u> <sp>Special</sp>",
              tagConfig: {
                "sp": CTextSpanConfig(
                    style: const TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Dialog Title'),
                          content: Text('This is a basic dialog message.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Add action here
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }),
              },
            ),
          ],
        ),
      ),
    );
  }
}
