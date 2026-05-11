import 'package:equatable/equatable.dart';

class ChangePasswordRequestModel extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
  Map<String, dynamic> toJson() => {
    "current_password": currentPassword,
    "password": newPassword,
    "password_confirmation": confirmPassword,
  };

  @override
  List<Object> get props => [currentPassword, newPassword, confirmPassword];
}
