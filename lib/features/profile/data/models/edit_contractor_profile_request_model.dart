import 'package:equatable/equatable.dart';

class EditContractorProfileRequestModel extends Equatable{
  final String name;
  final int classificationId;
  final List<int> serviceIds;
  final String phone;
  final String whatsapp;
  final String address;
  final String facebook;
  final String twitter;
  final String instagram;
  final String spanchat;
  final String storeDescription;

  const EditContractorProfileRequestModel({
    required this.name,
    required this.classificationId,
    required this.serviceIds,
    required this.phone,
    required this.whatsapp,
    required this.address,
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.spanchat,
    required this.storeDescription,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "category_id": classificationId,
    "sub_category_id": List<dynamic>.from(serviceIds.map((x) => x)),
    "phone": phone,
    "whatsapp": whatsapp,
    "address": address,
    "facebook": facebook,
    "twitter": twitter,
    "instagram": instagram,
    "spanchat": spanchat,
    "store_description": storeDescription,
  };

  @override
  List<Object> get props => [
    name,
    classificationId,
    serviceIds,
    phone,
    whatsapp,
    address,
    facebook,
    twitter,
    instagram,
    spanchat,
    storeDescription,
  ];
}
