import 'package:equatable/equatable.dart';

class ServiceModel extends Equatable {
  final int id;
  final int number;
  final String name;
  final String image;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.number,
    required this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    number: json['no_sub_cat'] ?? 0,
    image: json['image'] ?? '',
  );

  @override
  List<Object> get props => [id, name, number, image];
}