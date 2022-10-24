import 'package:couver_ui/couver_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/routes.dart';

import '../main.dart';

class Screen extends StatelessWidget {
  const Screen({
    super.key,
    this.child,
    this.backgroundColor,
    this.actions,
    this.pageName,
  });
  final List<Widget>? actions;
  final Widget? child;
  final Color? backgroundColor;
  final String? pageName;

  @override
  Widget build(BuildContext context) {
    final String? pageName =
        this.pageName ?? ModalRoute.of(context)?.settings.name?.toRouteName();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CAppBar(
        title: pageName != null ? Text(pageName) : null,
        actions: [
          CButton.circle(
            child: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              if (isDark) {
                MyApp.of(context).changeTheme(ThemeMode.light);
              } else {
                MyApp.of(context).changeTheme(ThemeMode.dark);
              }
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (actions != null)
            Column(
              children: actions ?? [],
            ),
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
