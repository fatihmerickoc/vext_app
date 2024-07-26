import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vext_app/main.dart';
import 'package:vext_app/providers/user_provider.dart';
import 'package:vext_app/screens/home.dart';
import 'package:vext_app/styles/styles.dart';

class RegisterAuth extends StatefulWidget {
  const RegisterAuth({super.key});

  @override
  _RegisterAuthState createState() => _RegisterAuthState();
}

class _RegisterAuthState extends State<RegisterAuth> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late final StreamSubscription<AuthState> _authStateSubscription;
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      },
      onError: (error) {
        if (error is AuthException) {
          context.showSnackBar(error.message, isError: true);
        } else {
          context.showSnackBar('Unexpected error occurred', isError: true);
        }
      },
    );
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

  Widget _registerButton() {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        if (userProvider.isLoading) return;

        final isRegisterSuccessful = await userProvider.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (isRegisterSuccessful) {
          context
              .showSnackBar('Please, check your email to verify your account');
        } else {
          context.showSnackBar(
            'Registration failed, please try again',
            isError: true,
          );
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
                  'Sign Up',
                  style: Styles.title_text.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
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
