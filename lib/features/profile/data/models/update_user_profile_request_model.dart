import 'package:equatable/equatable.dart';

class UpdateUserProfileRequestModel extends Equatable{
  final String name;
  final String email;
  final String phone;

 const UpdateUserProfileRequestModel({
    required this.name,
    required this.email,
    required this.phone,
  });
  Map<String, dynamic> toJson() => {
    "name": name,
    //"email": email,
    "phone": phone,
   
  };

  @override
  List<Object> get props => [name, email, phone];
}