import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vext_app/main.dart';
import 'package:vext_app/providers/user_provider.dart';
import 'package:vext_app/styles/styles.dart';

class LoginAuth extends StatefulWidget {
  const LoginAuth({super.key});

  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
        obscureText: isPassword,
        controller: isPassword ? _passwordController : _emailController,
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
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        if (userProvider.isLoading) return;
        final isLoginSuccessful = await userProvider.logIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        _emailController.clear();
        _passwordController.clear();

        if (isLoginSuccessful) {
          context.showSnackBar('Login successful');
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          context.showSnackBar('Login failed, please try again', isError: true);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: Styles.darkGreen,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: userProvider.isLoading
              ? const CircularProgressIndicator(
                  color: Styles.white,
                )
              : Text(
                  'Sign In',
                  style: Styles.title_text.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
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
