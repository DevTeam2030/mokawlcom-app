import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';

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
  final int classificationId;
  final List<int> services;
  final List<ServiceModel> userServices;

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
    required this.classificationId,
    required this.services,
    required this.userServices,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final subCategories = json['sub_categories'] as List<dynamic>? ?? [];
    
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
      classificationId: json['category_id'] ?? 0,
      services: subCategories
          .map((x) => (x['id'] as int?) ?? 0)
          .toList(),
      userServices: subCategories
          .map((x) => ServiceModel(
                id: x['id'] ?? 0,
                name: x['name'] ?? '',
                number: 0,
                image: '',
              ))
          .toList(),
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
        classificationId: 0,
        services: const [],
        userServices: const [],
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
    classificationId,
    services,
    userServices,
  ];
}
