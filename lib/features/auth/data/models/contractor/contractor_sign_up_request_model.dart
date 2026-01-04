import 'package:equatable/equatable.dart';

class ContractorSignUpRequestModel extends Equatable {
  final int classificationId;
  final List<int> services;
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String fcmToken;

  const ContractorSignUpRequestModel({
    required this.classificationId,
    required this.services,
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
    "category_id": classificationId,
    "sub_category_id": List<int>.from(services.map((x) => x)),
    "name": name,
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
    "phone": phone,
    "fcm_token": fcmToken,
  };

  @override
  List<Object> get props => [
    classificationId,
    services,
    name,
    email,
    password,
    passwordConfirmation,
    phone,
    fcmToken,
  ];
}
