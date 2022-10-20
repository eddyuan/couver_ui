import 'package:couver_ui/couver_ui.dart';
import 'package:example/constants/c_gradient.dart';
import 'package:example/constants/c_theme.dart';
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      appBar: CAppBar(
        title: const Text("Buttons"),
        actions: [
          Switch.adaptive(
            value: loading,
            onChanged: (val) {
              setState(() {
                loading = val;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(CTheme.padding),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      CButton.input(
                        child: const Text("A input styled button"),
                        onPressed: () {
                          // Map datas = {};
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Filled",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: CouverTheme.of(context).pagePadding),
                        child: Text(
                          "Circle (Icon)",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Wrap(
                        children: ButtonDemoConfig.build()
                            .map(
                              (e) => CButton.circle(
                                text: "Filled${e.extraText}",
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
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      ...ButtonDemoConfig.build()
                          .map((e) => CButton.filled(
                                text: "Filled${e.extraText}",
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
                          style: Theme.of(context).textTheme.headline6,
                        ),
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
                          style: Theme.of(context).textTheme.headline6,
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
