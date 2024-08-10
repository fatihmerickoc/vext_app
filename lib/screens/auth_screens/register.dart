import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vext_app/main.dart';
import 'package:vext_app/screens/home.dart';
import 'package:vext_app/services/auth_service.dart';
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
      _handleAuthStateChange,
      onError: _handleAuthError,
    );
  }

  void _handleAuthStateChange(AuthState data) {
    if (_redirecting) return;
    final session = data.session;
    if (session != null) {
      _redirecting = true;
      context.showSnackBar('Email confirmed successfully, logging you in');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  void _handleAuthError(error) {
    _authStateSubscription.cancel();
    context.showSnackBar(
      'An error occurred confirming your email, please try to log in instead',
      isError: true,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
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
            _registerLoginText(),
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
    final AuthService authService = AuthService();
    return GestureDetector(
      onTap: () async {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          context.showSnackBar('Email and password cannot be empty',
              isError: true);
          return;
        }

        final isRegisterSuccessful =
            await authService.registerUser(email, password);
        _emailController.clear();
        _passwordController.clear();

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
          child: Text(
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
