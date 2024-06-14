import 'package:flutter/material.dart';
import 'package:vext_app/screens/home.dart';
import 'package:vext_app/styles/styles.dart';

void main() {
  runApp(const MyApp());
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
/**Future<void> readFromServer() async {
    try {
      var tbClient = ThingsboardClient('https://thingsboard.vinicentus.net');

      // Perform login with default Tenant Administrator credentials
      await tbClient
          .login(LoginRequest('fatih+tenant.admin@vext.fi', '782246Vext.'));

      // Find Black Vext by it's ID
      var foundDevice = await tbClient
          .getDeviceService()
          .getDeviceInfo('7ffc0a50-0317-11ef-a0ef-7f542c4ca39c');

      // Get device shared attributes
      var attributes = await tbClient
          .getAttributeService()
          .getAttributesByScope(
              foundDevice!.id!,
              AttributeScope.SHARED_SCOPE.toShortString(),
              ['foggerOnSeconds', 'pumpOnSeconds']);
      for (AttributeKvEntry values in attributes) {
        print(
            "\nKEY:${values.getKey()}\nVALUE:${values.getValue()}\n-----------------");
      }

      // Finally perform logout to clear credentials
      await tbClient.logout();
    } catch (e, s) {
      print('Error: $e');
      print('Stack: $s');
    }
  } */