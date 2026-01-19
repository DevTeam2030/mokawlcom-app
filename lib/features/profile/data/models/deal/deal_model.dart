import 'package:equatable/equatable.dart';

class DealModel extends Equatable {
  final int id;
  final String title;
  final String description;

  const DealModel({
    required this.id,
    required this.title,
    required this.description,
  });
  factory DealModel.fromJson(Map<String, dynamic> json) => DealModel(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
  );
  
  @override
  List<Object> get props => [id, title, description];
}
