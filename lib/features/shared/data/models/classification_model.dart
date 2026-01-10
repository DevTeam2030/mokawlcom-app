import 'package:equatable/equatable.dart';

class ClassificationModel extends Equatable {
  final int id;
  final int number;
  final String name;
  final String image;

  const ClassificationModel({
    required this.id,
    required this.number,
    required this.name,
    required this.image,
  });

  factory ClassificationModel.fromJson(Map<String, dynamic> json) =>
      ClassificationModel(
        id: json['id'] ?? 0,
        number: json['no_sub_cat'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
      );

  @override
  List<Object> get props => [id, number, name, image];
}
