import 'package:equatable/equatable.dart';

class UserAppleLoginModel extends Equatable {
  final String idToken;
  final String name;

  const UserAppleLoginModel({required this.idToken, required this.name});

  @override
  List<Object> get props => [idToken, name];
}
