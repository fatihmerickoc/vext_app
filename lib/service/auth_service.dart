import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vext_app/models/user_model.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  //create user
  Future<UserModel?> registerUser(String email, password) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('User registered successfully');
        return UserModel(
          user_id: response.user!.id,
          user_email: response.user!.email ?? '',
          user_displayName: response.user!.userMetadata!['full_name'] ?? '',
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
      final AuthResponse response =
          await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('User logged in successfully');
        return UserModel(
          user_id: response.user!.id,
          user_email: response.user!.email ?? '',
          user_displayName: response.user!.userMetadata!['full_name'] ?? '',
        );
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //logout user
  Future<void> logOutUser() async {
    if (_supabaseClient.auth.currentUser != null) {
      await _supabaseClient.auth.signOut();
    }
  }
}
