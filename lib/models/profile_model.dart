class ProfileModel {
  final bool success;
  final String message;
  final User data;

  ProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: User.fromJson(json['data'] ?? {}),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }
}