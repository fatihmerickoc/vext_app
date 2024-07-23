import 'package:flutter/material.dart';
import 'package:vext_app/models/user_model.dart';
import 'package:vext_app/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel();
  UserModel get user => _user;

  final AuthService _authService = AuthService();

  bool get isAuthenticated {
    return _user.user_id != null;
  }

  Future<bool> register(String email, password) async {
    try {
      final fetchedUser = await _authService.registerUser(email, password);

      if (fetchedUser != null) {
        _user = fetchedUser;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Catched an error registering user : $e');
    }
    return false;
  }

  Future<bool> logIn(String email, String password) async {
    try {
      final fetchedUser = await _authService.logInUser(email, password);

      if (fetchedUser != null) {
        _user = fetchedUser;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Catched an error logging in: $e');
    }
    return false;
  }

  Future<void> logOut() async {
    try {
      await _authService.logOutUser();
      _user = UserModel();
      notifyListeners();
    } catch (e) {
      print('Catched an error logging out : $e');
    }
  }
}
