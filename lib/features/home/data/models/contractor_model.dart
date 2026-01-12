import 'package:equatable/equatable.dart';

class ContractorModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final String address;
  final String description;
  final String phone;
  final String whatsApp;
  final String category;
  final num rating;

  const ContractorModel({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.description,
    required this.phone,
    required this.whatsApp,
    required this.rating,
    required this.category,
  });

  factory ContractorModel.fromJson(Map<String, dynamic> json) =>
      ContractorModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        address: json['address'] ?? '',
        description: json['store_description'] ?? '',
        phone: json['phone'] ?? '',
        whatsApp: json['whatsapp'] ?? '',
        category: json['category'] ?? '',
        rating: (json['rate'] as num?)?.toDouble() ?? 0,
      );
  ContractorModel copyWith({num? rating}) {
    return ContractorModel(
      id: id,
      name: name,
      image: image,
      address: address,
      description: description,
      phone: phone,
      whatsApp: whatsApp,
      category: category,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    image,
    address,
    description,
    phone,
    whatsApp,
    rating,
    category,
  ];
}
