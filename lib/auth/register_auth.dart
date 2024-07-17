import 'package:flutter/material.dart';
import 'package:vext_app/styles/styles.dart';

class RegisterAuth extends StatefulWidget {
  const RegisterAuth({super.key});

  @override
  _RegisterAuthState createState() => _RegisterAuthState();
}

class _RegisterAuthState extends State<RegisterAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Vext!",
              style: TextStyle(
                fontSize: 52.0,
                fontFamily: 'BebasNeue',
              ),
            ),
            const Text(
              'The Hassle-Free Smart Garden',
              style: Styles.title_text,
            ),
            Styles.height_30,
            _registerTextField(),
            Styles.height_15,
            _registerTextField(isPassword: true),
            Styles.height_20,
            _registerButton(),
            Styles.height_10,
            _registerLoginText()
          ],
        ),
      ),
    );
  }

  Widget _registerTextField({bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          border: InputBorder.none,
          hintText: isPassword ? 'Password:' : 'Email:',
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Styles.darkGreen,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          'Sign Up',
          style: Styles.title_text.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _registerLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: Styles.body_text,
        ),
        Styles.width_5,
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/login'),
          child: Text(
            'Login here',
            style: Styles.body_text.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
