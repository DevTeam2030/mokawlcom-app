import 'package:equatable/equatable.dart';

class ActivateAccountResponseModel extends Equatable {
  final int id;
  final String message;
  final String type;
  final String token;
 

  const ActivateAccountResponseModel({
    required this.id,
    required this.message,
    required this.token,
    required this.type,
   
  });
  factory ActivateAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivateAccountResponseModel(
        id: json["data"]?["id"] ?? 0,
        message: json["message"] ?? "",
        token: json["data"]?["token"] ?? "",
        type: json["data"]?["type"] ?? "",
      );
  const ActivateAccountResponseModel.empty()
    : this(
        id: 0,
        message: "",
        token: "",
        type: "",
      );
  @override
  List<Object> get props => [
    id,
    message,
    type,
    token,
  ];
}
