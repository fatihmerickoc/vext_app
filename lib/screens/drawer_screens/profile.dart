import 'package:flutter/material.dart';
import 'package:vext_app/styles/styles.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  // method that produces text with same size and boldness for profile page
  Text _profileText(String text) {
    return Text(
      text,
      style: Styles.body_text.copyWith(fontWeight: FontWeight.w500),
    );
  }

  //method that builds TextFormField with chosen decoration
  TextFormField _typingBox(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Styles.darkGreen, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Styles.ligthBlack,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My profile',
          style: Styles.appBar_text,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileText('First Name'),
              _typingBox(_nameController),
              Styles.height_15,
              _profileText('Last Name'),
              _typingBox(_surnameController),
              Styles.height_15,
              _profileText('peter.parker@email.com'),
              Styles.height_15,
              Center(
                child: Text(
                  'Remove Account',
                  style: Styles.body_text
                      .copyWith(fontWeight: FontWeight.w500, color: Styles.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
