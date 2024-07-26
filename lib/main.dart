import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vext_app/providers/cabinet_provider.dart';
import 'package:vext_app/providers/user_provider.dart';
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
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => UserProvider(),
            child: const MyApp(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => CabinetProvider(),
            child: const MyApp(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

final supabase = Supabase.instance.client;

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
      home: supabase.auth.currentSession == null
          ? const LoginAuth()
          : const Home(),
    );
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Styles.red : Styles.darkGreen,
      ),
    );
  }
}
