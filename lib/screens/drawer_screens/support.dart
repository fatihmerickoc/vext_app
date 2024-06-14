import 'package:flutter/material.dart';
import 'package:vext_app/styles/styles.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  //method that build listTile according to the settings page
  Widget _supportListTile(String title, subTitle) {
    return ListTile(
      title: Text(
        title,
        style: Styles.body_text,
      ),
      subtitle: Text(subTitle),
      trailing: const Icon(
        Icons.arrow_forward,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _supportListTile('Troubleshoot', 'Find solutions to problems'),
            _supportListTile('Manual', 'View your digital manual'),
            _supportListTile('Forum', 'Discuss with fellow Vext owners'),
            _supportListTile('support@vext.fi', 'Send a message to us'),
          ],
        ),
      ),
    );
  }
}
