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
        images: List<String>.from(
          (json['images'] as List<dynamic>? ?? []).map((x) => x),
        ),
      );
  @override
  List<Object?> get props => [id, title, description, price, images];
}
