import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vext_app/screens/auth_screens/login.dart';
import 'package:vext_app/screens/auth_screens/register.dart';
import 'package:vext_app/screens/home.dart';
import 'package:vext_app/styles/styles.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://tlftvzpsqqprwfyqywbs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRsZnR2enBzcXFwcndmeXF5d2JzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxODYwOTEsImV4cCI6MjAzNTc2MjA5MX0.9faWaUyKpZRGGZC8Q_RCAOjgl6-pcPhiwWPdZUpli9Y',
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(const ProviderScope(child: MyApp())),
  );
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
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Styles.ligthBlack,
            textStyle: Styles.subtitle_text,
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Styles.backgroundColor,
        ),
        colorScheme: const ColorScheme.light(
          background: Styles.backgroundColor,
        ),
      ),
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const LoginAuth(),
        '/register': (context) => const RegisterAuth(),
      },
      home: const RegisterAuth(),
    );
  }
}
