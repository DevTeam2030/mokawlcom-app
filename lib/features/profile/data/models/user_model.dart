import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String logo;
  final String facabook;
  final String twitter;
  final String instagram;
  final String snapchat;
  final String whatsapp;
  final String hintAboutComppany;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.logo,
    required this.facabook,
    required this.twitter,
    required this.instagram,
    required this.snapchat,
    required this.whatsapp,
    required this.hintAboutComppany,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      logo: json['logo'] ?? '',
      facabook: json['facebook'] ?? '',
      twitter: json['twitter'] ?? '',
      instagram: json['instagram'] ?? '',
      snapchat: json['spanchat'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      hintAboutComppany: json['store_description'] ?? '',
    );
  }
  const UserModel.empty()
    : this(
        id: 0,
        name: '',
        phone: '',
        email: '',
        address: '',
        logo: '',
        facabook: '',
        twitter: '',
        instagram: '',
        snapchat: '',
        whatsapp: '',
        hintAboutComppany: '',
      );

  @override
  List<Object> get props => [
    id,
    name,
    phone,
    email,
    address,
    logo,
    facabook,
    twitter,
    instagram,
    snapchat,
    whatsapp,
    hintAboutComppany,
  ];
}
