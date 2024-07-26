// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserModel {
  final String? user_id;
  final String? user_email;
  final String? user_displayName;
  UserModel({
    this.user_id,
    this.user_email,
    this.user_displayName,
  });

  String encodeUser() {
    final String encodedUser = jsonEncode({
      'user_id': user_id,
      'user_email': user_email,
      'user_displayName': user_displayName,
    });
    return encodedUser;
  }

  Map<String, dynamic> decodeUser(String encodedUser) {
    final Map<String, dynamic> decodedUser = jsonDecode(encodedUser);
    return decodedUser;
  }
}
