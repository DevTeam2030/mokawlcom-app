import 'package:equatable/equatable.dart';

class ContractorServiceModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String price;
  final List<String> images;

  const ContractorServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
  });
  factory ContractorServiceModel.fromJson(Map<String, dynamic> json) =>
      ContractorServiceModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        price: json['price'] ?? '',
        images: List<String>.from(json['images'] ?? []),
      );
  
  ContractorServiceModel copyWith({
    String? title,
    String? description,
    String? price,
    List<String>? images,
  }) =>
      ContractorServiceModel(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        images: images ?? this.images,
      );
  
  @override
  List<Object> get props => [id, title, description, price, images];
}
