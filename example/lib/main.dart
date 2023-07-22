import 'package:couver_ui/couver_ui.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  bool useMaterial3 = true;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      this.themeMode = themeMode;
    });
  }

  void toggleMaterial() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Couver UI Demo',
      theme: ThemeData(
        useMaterial3: useMaterial3,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: useMaterial3,
      ),
      themeMode: themeMode,
      initialRoute: "/",
      routes: AppRoutes.routes,
      builder: (context, child) => CouverTheme(
        theme: const CouverThemeData(
          gutter: 4,
          pagePadding: 20,
        ),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        ),
      ),
    );
  }
}
