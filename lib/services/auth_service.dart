import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vext_app/main.dart';
import 'package:vext_app/models/user_model.dart';

class AuthService {
  //create user
  Future<UserModel?> registerUser(String email, password) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
          email: email,
          password: password,
          emailRedirectTo: 'fi.vext.vextapp://register-callback/');

      if (response.user != null) {
        return UserModel(
          user_id: response.user!.id,
          user_email: response.user!.email ?? '',
        );
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //login user
  Future<UserModel?> logInUser(String email, password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return UserModel(
          user_id: response.user!.id,
          user_email: response.user!.email ?? '',
        );
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //logout user
  Future<void> logOutUser() async {
    if (supabase.auth.currentUser != null) {
      await supabase.auth.signOut();
    }
  }
}
