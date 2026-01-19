import 'package:equatable/equatable.dart';

class ClassificationModel extends Equatable {
  final int id;
  final int numberOfServices;
  final String name;
  final String image;

  const ClassificationModel({
    required this.id,
    required this.numberOfServices,
    required this.name,
    required this.image,
  });

  factory ClassificationModel.fromJson(Map<String, dynamic> json) =>
      ClassificationModel(
        id: json['id'] ?? 0,
        numberOfServices: json['no_sub_cat'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
      );

  @override
  List<Object> get props => [id, numberOfServices, name, image];
}
