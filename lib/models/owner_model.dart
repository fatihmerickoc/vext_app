// ignore_for_file: non_constant_identifier_names

class OwnerModel {
  final String? owner_id;
  final String? owner_email;
  final String? owner_password;
  final String? owner_displayName;
  OwnerModel({
    this.owner_id,
    this.owner_email,
    this.owner_password,
    this.owner_displayName,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      owner_id: json['owner_id'] ?? '',
      owner_email: json['owner_email'] ?? '',
      owner_password: json['owner_password'] ?? '',
      owner_displayName: json['owner_displayName'] ?? '',
    );
  }
}
