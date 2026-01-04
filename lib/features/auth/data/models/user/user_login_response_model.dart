import 'package:equatable/equatable.dart';

class UserLoginResponseModel extends Equatable {
  final String message;
  final String token;
  final String type;

  const UserLoginResponseModel({
    required this.message,
    required this.token,
    required this.type,
  });

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseModel(
      message: json['message'] ?? "",
      token: json["data"]?['access_token'] ?? "",
      type: json["data"]?['type'] ?? "",
    );
  }
  const UserLoginResponseModel.empty() : this(message: "", token: "", type: "");
  @override
  List<Object> get props => [message, token, type];
}
