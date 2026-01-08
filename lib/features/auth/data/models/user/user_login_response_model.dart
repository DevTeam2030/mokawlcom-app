import 'package:equatable/equatable.dart';

class UserLoginResponseModel extends Equatable {
  final String message;
  final String token;
  final String type;
  final bool filesUploaded;
  final bool planCompleted;
  final bool completeData;

  const UserLoginResponseModel({
    required this.message,
    required this.token,
    required this.type,
    required this.filesUploaded,
    required this.planCompleted,
    required this.completeData,
  });

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseModel(
      message: json['message'] ?? "",
      token: json["data"]?['access_token'] ?? "",
      type: json["data"]?['type'] ?? "",
      filesUploaded: json["data"]?['files_uploaded'] ?? true,
      planCompleted: json["data"]?['plan_completed'] ?? true,
      completeData: json["data"]?['complete_data'] ?? true,
    );
  }
  const UserLoginResponseModel.empty()
    : this(
        message: "",
        token: "",
        type: "",
        filesUploaded: true,
        planCompleted: true,
        completeData: true,
      );
  @override
  List<Object> get props => [
    message,
    token,
    type,
    filesUploaded,
    planCompleted,
    completeData,
  ];
}
