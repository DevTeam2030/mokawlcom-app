import 'package:equatable/equatable.dart';

class UserLoginResponseModel extends Equatable {
  final String message;
  final String token;
  final String type;
  final String name;
  final String phone;
  final int userApproved;
  final bool filesUploaded;
  final bool planCompleted;
  final bool completeData;
  final int userId;

  const UserLoginResponseModel({
    required this.message,
    required this.token,
    required this.type,
    required this.name,
    required this.phone,
    required this.userApproved,
    required this.filesUploaded,
    required this.planCompleted,
    required this.completeData,
    required this.userId,
  });

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseModel(
      message: json['message'] ?? "",
      token: json["data"]?['access_token'] ?? "",
      type: json["data"]?['type'] ?? "",
      name: json["data"]?['name'] ?? "",
      phone: json["data"]?['phone'] ?? "",
      userApproved: json["data"]?['user_approved'] ?? 0,
      filesUploaded: json["data"]?['files_uploaded'] ?? true,
      planCompleted: json["data"]?['plan_completed'] ?? true,
      completeData: json["data"]?['complete_data'] ?? true,
      userId: json["data"]?['id'] ?? 0,
    );
  }
  const UserLoginResponseModel.empty()
    : this(
        message: "",
        token: "",
        type: "",
        name: "",
        phone: "",
        userApproved: 0,
        filesUploaded: true,
        planCompleted: true,
        completeData: true,
        userId: 0,
      );
  @override
  List<Object> get props => [
    message,
    token,
    type,
    name,
    phone,
    userApproved,
    filesUploaded,
    planCompleted,
    completeData,
    userId,
  ];
}
