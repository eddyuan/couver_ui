import 'package:couver_ui/couver_ui.dart';
import 'package:example/constants/c_gradient.dart';
import 'package:example/constants/c_theme.dart';
import 'package:flutter/material.dart';

class ButtonDemoConfig {
  const ButtonDemoConfig({
    this.gradient,
    this.loading = false,
    this.onPressed,
    this.text,
    this.size,
    this.disabled = false,
    this.platformStyle = PlatformStyle.auto,
    this.child,
  });
  final Gradient? gradient;
  final bool loading;
  final VoidCallback? onPressed;
  final String? text;
  final BtnSize? size;
  final bool disabled;
  final PlatformStyle platformStyle;
  final Widget? child;
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
      const ButtonDemoConfig(text: "Loading", loading: true),
      ButtonDemoConfig(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Custom children"),
            Icon(Icons.abc_outlined),
          ],
        ),
      ),
      ButtonDemoConfig(text: "xl - ${BtnSize.xl.value}", size: BtnSize.xl),
      ButtonDemoConfig(text: "lg - ${BtnSize.lg.value}", size: BtnSize.lg),
      ButtonDemoConfig(text: "md - ${BtnSize.md.value}", size: BtnSize.md),
      ButtonDemoConfig(text: "sm - ${BtnSize.sm.value}", size: BtnSize.sm),
      ButtonDemoConfig(text: "xs - ${BtnSize.xs.value}", size: BtnSize.xs),
      ButtonDemoConfig(
          text: "mini - ${BtnSize.mini.value}", size: BtnSize.mini),
    ];
  }
}

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        title: const Text("Buttons"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(CTheme.padding),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Filled",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  CButton.input(
                    child: const Text("A input styled button"),
                    onPressed: () {
                      Map datas = {};
                      print(datas["123"].toString());
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: CouverTheme.of(context).pagePadding),
                    child: Text(
                      "Circle (Icon)",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  CButton.circle(
                    onPressed: () => {},
                    color: Colors.red,
                    child: const Icon(Icons.read_more),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Filled",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ...ButtonDemoConfig.build()
                      .map((e) => CButton.filled(
                            text: "Filled${e.extraText}",
                            gradient: e.gradient,
                            onPressed: () => {},
                            loading: e.loading,
                            size: e.size,
                            margin: const EdgeInsets.only(bottom: 6),
                            disabled: e.disabled,
                            style: e.platformStyle,
                            child: e.child,
                          ))
                      .toList(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 32),
                    child: Text(
                      "Text",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ...ButtonDemoConfig.build()
                      .map((e) => CButton(
                            text: "Text${e.extraText}",
                            gradient: e.gradient,
                            onPressed: () => {},
                            loading: e.loading,
                            size: e.size,
                            margin: const EdgeInsets.only(bottom: 6),
                            disabled: e.disabled,
                            style: e.platformStyle,
                            child: e.child,
                          ))
                      .toList(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 32),
                    child: Text(
                      "Outlined",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ...ButtonDemoConfig.build()
                      .map((e) => CButton.outlined(
                            text: "Outlined${e.extraText}",
                            gradient: e.gradient,
                            onPressed: () => {},
                            loading: e.loading,
                            size: e.size,
                            margin: const EdgeInsets.only(bottom: 6),
                            disabled: e.disabled,
                            style: e.platformStyle,
                            child: e.child,
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
