import 'package:flutter/material.dart';
import 'package:vext_app/styles/styles.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Membership',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Memberships are coming soon!',
                style: Styles.title_text,
              ),
            ),
            Text(
              'We’ll notify you when they are here',
              style: Styles.body_text.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
