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
  final List<ServiceModel> userServices;
  final String classification;
  final String message;

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
    required this.userServices,
    required this.classification,
    required this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final subCategories = data['sub_categories'] as List<dynamic>? ?? [];

    return UserModel(
      id: int.tryParse(data['id']?.toString() ?? '0') ?? 0,
      message: json['message'] ?? '',
      name: data['name']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      logo: data['logo']?.toString() ?? '',
      facabook: data['facebook']?.toString() ?? '',
      twitter: data['twitter']?.toString() ?? '',
      instagram: data['instagram']?.toString() ?? '',
      snapchat: data['spanchat']?.toString() ?? '',
      whatsapp: data['whatsapp']?.toString() ?? '',
      hintAboutComppany: data['store_description']?.toString() ?? '',
      classificationId:
          int.tryParse(data['category_id']?.toString() ?? '0') ?? 0,
      classification: data['category']?.toString() ?? '',
      userServices: subCategories
          .map(
            (x) => ServiceModel(
              id: int.tryParse(x['id']?.toString() ?? '0') ?? 0,
              name: x['name']?.toString() ?? '',
              number: 0,
              image: '',
            ),
          )
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
        message: '',
        twitter: '',
        instagram: '',
        snapchat: '',
        whatsapp: '',
        hintAboutComppany: '',
        classificationId: 0,
        userServices: const [],
        classification: '',
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
    userServices,
    classification,
    message,
  ];
}
