import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vext_app/main.dart';

class AuthService {
  //create user
  Future<bool> registerUser(String email, password) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
          email: email,
          password: password,
          emailRedirectTo: 'fi.vext.vextapp://register-callback/');

      if (response.user != null) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  //login user
  Future<bool> logInUser(String email, password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  //logout user
  Future<void> logOutUser() async {
    try {
      if (supabase.auth.currentUser != null) {
        await supabase.auth.signOut();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
