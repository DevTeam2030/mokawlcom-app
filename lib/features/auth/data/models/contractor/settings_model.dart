import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final int id;
  final String name;
  final String image;

  const SettingsModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    id: (json["id"] as num?)?.toInt() ?? 0,
    name: json["name"] ?? "",
    image: json["image"] ?? "",
  );

  @override
  List<Object> get props => [id, name, image];
}
