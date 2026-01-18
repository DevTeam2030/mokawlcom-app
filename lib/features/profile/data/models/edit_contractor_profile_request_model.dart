import 'package:equatable/equatable.dart';

class EditContractorProfileRequestModel extends Equatable {
  final String name;
  final int classificationId;
  final List<int> serviceIds;
  final String phone;
  final String? whatsapp;
  final String? address;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? spanchat;
  final String hintAboutCompany;

  const EditContractorProfileRequestModel({
    required this.name,
    required this.classificationId,
    required this.serviceIds,
    required this.phone,
    this.whatsapp,
    this.address,
    this.facebook,
    this.twitter,
    this.instagram,
    this.spanchat,
    required this.hintAboutCompany,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "category_id": classificationId,
    "sub_category_id": List<int>.from(serviceIds.map((x) => x)),
    "phone": phone,
    "whatsapp": whatsapp ?? "",
    "address": address??"",
    "facebook": facebook??"",
    "twitter": twitter??"",
    "instagram": instagram??"",
    "latitude":"",
    "longitude":"",
    "spanchat": spanchat??"",
    "store_description": hintAboutCompany,
  };

  @override
  List<Object?> get props => [
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
    hintAboutCompany,
  ];
}
