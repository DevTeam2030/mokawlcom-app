import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';

class ContractorDetailsModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String logo;
  final String companyName;
  final String address;
  final String description;
  final String category;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String twitter;
  final String spanchat;
  final List<String> classifications;
  final List<ContractorServiceModel> services;

  const ContractorDetailsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.logo,
    required this.companyName,
    required this.address,
    required this.description,
    required this.category,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.spanchat,
    required this.classifications,
    required this.services,
  });

  factory ContractorDetailsModel.fromJson(Map<String, dynamic> json) =>
      ContractorDetailsModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        logo: json['logo'] ?? '',
        companyName: json['company_name'] ?? '',
        address: json['address'] ?? '',
        description: json['store_description'] ?? '',
        category: json['category'] ?? '',
        whatsapp: json['whatsapp'] ?? '',
        facebook: json['facebook'] ?? '',
        instagram: json['instagram'] ?? '',
        twitter: json['twitter'] ?? '',
        spanchat: json['spanchat'] ?? '',
        classifications: (json['sub_categories'] as List<dynamic>? ?? [])
            .map((e) => e['name'] as String? ?? '')
            .toList(),

        services: List<ContractorServiceModel>.from(
          (json['services'] as List<dynamic>? ?? []).map(
            (x) => ContractorServiceModel.fromJson(x),
          ),
        ),
      );
  const ContractorDetailsModel.empty()
    : this(
        id: 0,
        name: '',
        email: '',
        phone: '',
        logo: '',
        companyName: '',
        address: '',
        description: '',
        category: '',
        whatsapp: '',
        facebook: '',
        instagram: '',
        twitter: '',
        spanchat: '',
        classifications: const [],
        services: const [],
      );
  @override
  List<Object> get props => [
    id,
    name,
    email,
    phone,
    logo,
    companyName,
    address,
    description,
    category,
    whatsapp,
    facebook,
    instagram,
    twitter,
    spanchat,
    classifications,
    services,
  ];
}
