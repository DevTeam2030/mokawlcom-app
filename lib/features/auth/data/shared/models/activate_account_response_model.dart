import 'package:equatable/equatable.dart';

class ActivateAccountResponseModel extends Equatable {
  final String message;
  final String type;
  final String token;

  const ActivateAccountResponseModel({
    required this.message,
    required this.token,
    required this.type,
  });
  factory ActivateAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivateAccountResponseModel(
        message: json["message"] ?? "",
        token: json["data"]?["token"] ?? "",
        type: json["data"]?["type"] ?? "",
      );
  const ActivateAccountResponseModel.empty()
    : this(message: "", token: "", type: "");
  @override
  List<Object> get props => [message, type, token];
}
