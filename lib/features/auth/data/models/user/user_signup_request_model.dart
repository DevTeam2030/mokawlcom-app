import 'package:equatable/equatable.dart';

class UserSignupRequestModel extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  final String phone;
  final String fcmToken;

  const UserSignupRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.confirmPassword,
    required this.fcmToken,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "password_confirmation": confirmPassword,
      "fcm_token": fcmToken,
    };
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    phone,
    confirmPassword,
    fcmToken,
  ];
}
