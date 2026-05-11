import 'package:equatable/equatable.dart';

class GoogleSignInRequestModel extends Equatable {
  final String idToken;
  final String fcmToken;

  const GoogleSignInRequestModel({
    required this.idToken,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {'id_token': idToken, 'fcm_token': fcmToken};
  @override
  List<Object> get props => [idToken, fcmToken];
}
