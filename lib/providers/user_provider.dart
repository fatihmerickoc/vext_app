import 'package:flutter/material.dart';
import 'package:vext_app/models/user_model.dart';
import 'package:vext_app/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel();
  UserModel get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final AuthService _authService = AuthService();

  Future<bool> register(String email, password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedUser = await _authService.registerUser(email, password);

      if (fetchedUser != null) {
        _user = fetchedUser;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Caught an error registering user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> logIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedUser = await _authService.logInUser(email, password);

      if (fetchedUser != null) {
        _user = fetchedUser;

        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Caught an error logging in: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<void> logOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logOutUser();
      _user = UserModel();
      notifyListeners();
    } catch (e) {
      print('Caught an error logging out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
