// main.dart
import 'package:flutter/material.dart';
import 'CalculatorScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calculator',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.teal,
            scaffoldBackgroundColor: Colors.grey.shade100,
            appBarTheme: const AppBarTheme(
              centerTitle: false,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.cyan,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              centerTitle: false,
            ),
          ),
          themeMode: currentMode,
          home: const CalculatorScreen(),
        );
      },
    );
  }
}
