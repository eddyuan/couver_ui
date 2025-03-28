import 'package:couver_ui/couver_ui.dart';
import 'package:example/constants/c_gradient.dart';
import 'package:example/constants/c_theme.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class ButtonDemoConfig {
  const ButtonDemoConfig({
    this.gradient,
    this.onPressed,
    this.text,
    this.size,
    this.disabled = false,
    this.platformStyle = PlatformStyle.auto,
    this.child,
    this.color,
  });
  final Gradient? gradient;

  final VoidCallback? onPressed;
  final String? text;
  final BtnSize? size;
  final bool disabled;
  final PlatformStyle platformStyle;
  final Widget? child;
  final Color? color;
  String get extraText => text != null ? " ($text)" : "";
  static List<ButtonDemoConfig> build() {
    return [
      const ButtonDemoConfig(),
      const ButtonDemoConfig(
          text: "Cupertino", platformStyle: PlatformStyle.cupertino),
      const ButtonDemoConfig(
          text: "Material", platformStyle: PlatformStyle.material),
      const ButtonDemoConfig(gradient: CGradient.primary, text: "Gradient"),
      const ButtonDemoConfig(text: "Disabled", disabled: true),
      ButtonDemoConfig(
        color: Colors.lime.withOpacity(0.5),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Custom children"),
            Icon(Icons.abc_outlined),
          ],
        ),
      ),
      ButtonDemoConfig(
        text: "xl - ${BtnSize.xl.minHeight}",
        size: BtnSize.xl,
        color: Colors.white,
      ),
      ButtonDemoConfig(
        text: "lg - ${BtnSize.lg.minHeight}",
        size: BtnSize.lg,
        color: Colors.white70,
      ),
      ButtonDemoConfig(
        text: "md - ${BtnSize.md.minHeight}",
        size: BtnSize.md,
        color: Colors.white30,
      ),
      ButtonDemoConfig(
        text: "sm - ${BtnSize.sm.minHeight}",
        size: BtnSize.sm,
        color: Colors.purple.withOpacity(0.7),
      ),
      ButtonDemoConfig(
        text: "xs - ${BtnSize.xs.minHeight}",
        size: BtnSize.xs,
        color: Colors.purple.withOpacity(0.5),
      ),
      ButtonDemoConfig(
        text: "mini - ${BtnSize.mini.minHeight}",
        size: BtnSize.mini,
        color: Colors.purple.withOpacity(0.2),
      ),
    ];
  }
}

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  bool loading = false;
  BtnSize btnSize = BtnSize.df;
  @override
  Widget build(BuildContext context) {
    return Screen(
      backgroundColor: Colors.grey.shade400,
      actions: [
        CListTile(
          dense: true,
          title: const Text("Loading"),
          tileColor: Theme.of(context).colorScheme.surface,
          trailing: Switch.adaptive(
            value: loading,
            onChanged: (val) {
              setState(() {
                loading = val;
              });
            },
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(CTheme.padding),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // CButton2(
              //   text: "CButton2",
              //   onPressed: () {},
              // ),
              ElevatedButton(
                onPressed: () {},
                child: Text('elevated button'),
                style: ButtonStyle(
                  elevation: MaterialStatePropertyAll(0),
                  animationDuration: Durations.short1,
                  shape: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.pressed)) {
                        return GradientRoundedRectangleBorder(
                          side: GradientBorderSide(
                            width: 3,
                            gradient: LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.blue,
                              ],
                            ).withAlpha(100),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        );
                      }
                      return GradientRoundedRectangleBorder(
                        side: GradientBorderSide(
                          width: 3,
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.blue,
                            ],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      );
                    },
                  ),

                  // WidgetStatePropertyAll(
                  //   GradientRoundedRectangleBorder(
                  //     side: GradientBorderSide(
                  //       width: 3,
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           Colors.red,
                  //           Colors.blue,
                  //         ],
                  //       ),
                  //     ),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  // ),
                  // side: WidgetStatePropertyAll(BorderSide(color: Colors.red)),
                  backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                  // backgroundBuilder: (context, states, child) {
                  //   return Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.green.withAlpha(100),
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           Colors.blue,
                  //           Colors.red,
                  //         ],
                  //       ),
                  //     ),
                  //     child: Stack(
                  //       alignment: Alignment.center,
                  //       children: [
                  //         const SizedBox(
                  //           width: 20,
                  //           height: 20,
                  //           child: CCircularProgressIndicator(),
                  //         ),
                  //         Opacity(
                  //           opacity: 0,
                  //           child: child,
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // },
                  // foregroundBuilder: (context, states, child) {
                  //   return Container(
                  //     decoration: BoxDecoration(color: Colors.red),
                  //     child: child ?? const SizedBox.shrink(),
                  //   );
                  // },
                ),
              ),
              CButton.input(
                child: const Text("A input styled button"),
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: CouverTheme.of(context).pagePadding),
                child: Text(
                  "Circle (Icon)",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
              CIconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
              Wrap(
                children: ButtonDemoConfig.build()
                    .map(
                      (e) => CButton.circle(
                        gradient: e.gradient,
                        onPressed: () => {},
                        loading: loading,
                        size: e.size?.minHeight,
                        margin: const EdgeInsets.only(bottom: 6),
                        disabled: e.disabled,
                        platformStyle: e.platformStyle,
                        color: e.color,
                        child: const Icon(Icons.read_more),
                        // child: e.child,
                      ),
                    )
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Filled",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ElevatedButton(
                onPressed: loading ? null : () {},
                child: const Text("ABC Original"),
              ),
              CElevatedButton(
                onPressed: loading ? null : () {},
                child: const Text("ABC Original"),
              ),
              ...ButtonDemoConfig.build()
                  .map((e) => CButton.filled(
                        text: "ABC ${e.text ?? 'Base'}",
                        gradient: e.gradient,
                        onPressed: () => {},
                        loading: loading,
                        size: e.size ?? const BtnSize(),
                        margin: const EdgeInsets.only(bottom: 6),
                        disabled: e.disabled,
                        platformStyle: e.platformStyle,
                        color: e.color,
                        child: e.child,
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 32),
                child: Text(
                  "Text",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: loading ? null : () {},
                child: const Text("Original"),
              ),
              CTextButton(
                onPressed: loading ? null : () {},
                child: const Text("Original2"),
              ),
              ...ButtonDemoConfig.build()
                  .map((e) => CButton(
                        text: "Text${e.extraText}",
                        gradient: e.gradient,
                        onPressed: () => {},
                        loading: loading,
                        size: e.size ?? const BtnSize(),
                        margin: const EdgeInsets.only(bottom: 6),
                        disabled: e.disabled,
                        platformStyle: e.platformStyle,
                        color: e.color,
                        child: e.child,
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 32),
                child: Text(
                  "Outlined",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              OutlinedButton(
                onPressed: loading ? null : () {},
                child: const Text("Original"),
              ),
              OutlinedButton(
                onPressed: loading ? null : () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                      // color: Colors.blue,
                      ),
                ),
                child: const Text("Original"),
              ),
              COutlinedButton(
                onPressed: loading ? null : () {},
                child: const Text("Original 2"),
              ),
              ...ButtonDemoConfig.build()
                  .map((e) => CButton.outlined(
                        text: "Outlined${e.extraText}",
                        gradient: e.gradient,
                        onPressed: () => {},
                        loading: loading,
                        size: e.size ?? const BtnSize(),
                        margin: const EdgeInsets.only(bottom: 6),
                        disabled: e.disabled,
                        platformStyle: e.platformStyle,
                        color: e.color,
                        child: e.child,
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
