import 'package:couver_ui/couver_ui.dart';
import 'package:flutter/material.dart';

const List<double> fontSizes = [14, 28];
const List<double> fractions = [0.6, 1, 300];
const List<int> lines = [1, 3];

class TextsScreen extends StatelessWidget {
  const TextsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const t =
        "data <b>bold</b> <small>small</small> <u>UnderLine</u> <sp>Special</sp> dwoando awjod jawpjd pawjdp awjpdjawpijd pawjdp aiwjpdj awpjd piawjdp ajwpdj pawjdp japwdj ";
    return Scaffold(
      appBar: CAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CRichText.rich(
              TextSpan(
                children: [
                  TextSpan(text: '123123'),
                  ...List.generate(
                    50,
                    (index) => WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          color: Colors.green,
                          child: Text("Text $index"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              expandable: true,
            ),
            CRichText(
              "This is a fucking gradient text This is a fucking gradient text This is a fucking gradient text fucking gradient text..",
              maxLines: 2,
              expandable: true,
            ),
            const SizedBox(height: 24),
            CRichText(
              "This is a fucking gradient text\nThis is a fucking gradient text\nThis is a fucking gradient text",
              maxLines: 2,
              expandable: true,
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.blue,
                ],
              ),
            ),
            Divider(),
            ...List.generate(lines.length, (lineIndex) {
              final line = lines[lineIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(fractions.length, (fractionIndex) {
                  final fraction = fractions[fractionIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // CRichText("Fraction: $fraction, Line: $line"),
                      ...List.generate(fontSizes.length, (fontSizeIndex) {
                        final fontSize = fontSizes[fontSizeIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CRichText(
                                "Fraction: $fraction, Line: $line, Size: $fontSize"),
                            CRichText(
                              "",
                              loading: true,
                              style: TextStyle(fontSize: fontSize),
                              loadingLines: line,
                              loadingWidth: fraction,
                            ),
                            CRichText("Wrap"),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: List.generate(
                                3,
                                (index) => CRichText(
                                  "",
                                  loading: true,
                                  style: TextStyle(fontSize: fontSize),
                                  loadingLines: 1,
                                  loadingWidth: 0.2,
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      }),
                    ],
                  );
                }),
              );
            }),
            // CRichText("F0.6, line1"),
            // CRichText(
            //   "F0.6, line1",
            //   loading: true,
            // ),
            // CRichText(
            //   "F0.6, line1",
            //   loading: true,
            //   style: TextStyle(fontSize: 30),
            // ),
            // CRichText("F0.6, line2"),
            // CRichText(
            //   "F0.6, line1",
            //   loading: true,
            //   loadingLines: 2,
            // ),
            // Divider(),
            // CRichText("F100, line1"),
            // CRichText(
            //   "F0.6, line1",
            //   loading: true,
            //   loadingLines: 1,
            //   loadingWidth: 100,
            // ),
            // CRichText("F100, line2"),
            // CRichText(
            //   "F0.6, line1",
            //   loading: true,
            //   loadingLines: 2,
            //   loadingWidth: 100,
            // ),
            // Divider(),
            // CRichText("F100, line1, Wrap"),
            // Wrap(
            //   children: [
            //     CRichText(
            //       "F0.6, line1",
            //       loading: true,
            //       loadingLines: 1,
            //       loadingWidth: 100,
            //     ),
            //     CRichText(
            //       "F0.6, line1",
            //       loading: true,
            //       loadingLines: 1,
            //       loadingWidth: 100,
            //     ),
            //   ],
            // ),
            // Divider(),
            // CRichText("F0.6, line1, Wrap"),
            // Wrap(
            //   children: [
            //     CRichText(
            //       "F0.6, line1",
            //       loading: true,
            //       loadingLines: 1,
            //     ),
            //     CRichText(
            //       "F0.6, line1",
            //       loading: true,
            //       loadingLines: 1,
            //     ),
            //   ],
            // ),
            CRichText(
              t,
              maxLines: 2,
              loadingLines: 3,
              loading: false,
              loadingWidth: 200,
              expandable: true,
              tagConfig: {
                "sp": CRichTextConfig(
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
