import 'package:flutter/material.dart';
import 'package:vext_app/styles/styles.dart';

class LoginAuth extends StatefulWidget {
  const LoginAuth({super.key});

  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hello Again!",
              style: TextStyle(
                fontSize: 52.0,
                fontFamily: 'BebasNeue',
              ),
            ),
            const Text("Welcome back, you've been missed!",
                style: Styles.title_text),
            Styles.height_30,
            _loginTextField(),
            Styles.height_15,
            _loginTextField(isPassword: true),
            Styles.height_20,
            _loginButton(),
            Styles.height_10,
            _loginRegisterText()
          ],
        ),
      ),
    );
  }

  Widget _loginTextField({bool isPassword = false}) {
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

  Widget _loginButton() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Styles.darkGreen,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          'Sign In',
          style: Styles.title_text.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _loginRegisterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Not a member?',
          style: Styles.body_text,
        ),
        Styles.width_5,
        InkWell(
          onTap: () => Navigator.pushReplacementNamed(context, '/register'),
          child: Text(
            'Register here',
            style: Styles.body_text.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
