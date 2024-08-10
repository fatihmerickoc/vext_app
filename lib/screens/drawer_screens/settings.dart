import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vext_app/providers/cabinet_provider.dart';
import 'package:vext_app/styles/styles.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //method that produces widget with same size and boldness for settings page
  Widget _settingsText(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
      child: Text(
        text,
        style: Styles.drawer_text.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  //method that build listTile according to the settings page
  Widget _settingsListTile(String title, trailing) {
    return ListTile(
      title: Text(
        title,
        style: Styles.body_text,
      ),
      trailing: Text(
        trailing,
        style: Styles.body_text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cabinetProvider = Provider.of<CabinetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _settingsText('Network & Security'),
            _settingsListTile(
                'Wi-Fi Network', cabinetProvider.cabinet.cabinet_network),
            _settingsText('Notifications'),
            _settingsListTile('Push Notifications', 'On'),
            _settingsText('Firmware Updates'),
            _settingsListTile('Check for updates', 'Check Now'),
            _settingsText('Device Information'),
            ListTile(
              title: Text(
                'Serial Number: ${cabinetProvider.cabinet.cabinet_idTB}',
                style: Styles.body_text.copyWith(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                'Model: 2.0.12',
                style: Styles.subtitle_text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Remove Device',
                style: Styles.body_text.copyWith(color: Styles.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
