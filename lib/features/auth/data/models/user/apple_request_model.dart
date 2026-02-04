import 'package:equatable/equatable.dart';

class AppleRequestModel extends Equatable {
  final String idToken;
  final String name;
  final String fcmToken;

  const AppleRequestModel({
    required this.idToken,
    required this.name,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_token": idToken,
      "name": name,
      "fcm_token": fcmToken,
    };
  }

  @override
  List<Object> get props => [idToken, name, fcmToken];
}