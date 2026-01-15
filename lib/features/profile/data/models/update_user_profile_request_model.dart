import 'package:equatable/equatable.dart';

class UpdateUserProfileRequestModel extends Equatable{
  final String name;
  final String email;
  final String phone;
  final String address;

 const UpdateUserProfileRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
  };

  @override
  List<Object?> get props => [name, email, phone, address];
}