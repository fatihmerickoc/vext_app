import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vext_app/screens/home.dart';
import 'package:vext_app/styles/styles.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vext',
      theme: ThemeData(
        fontFamily: 'Inter',
        drawerTheme: const DrawerThemeData(
          backgroundColor: Styles.backgroundColor,
        ),
        colorScheme: const ColorScheme.light(
          background: Styles.backgroundColor,
        ),
      ),
      home: const Home(),
    );
  }
}
