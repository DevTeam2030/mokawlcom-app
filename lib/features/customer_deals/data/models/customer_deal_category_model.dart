import 'package:equatable/equatable.dart';

class CustomerDealCategoryModel extends Equatable {
  const CustomerDealCategoryModel({required this.id, required this.name});

  final int id;
  final String name;

  factory CustomerDealCategoryModel.fromJson(Map<String, dynamic> json) {
    return CustomerDealCategoryModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  @override
  List<Object> get props => [id, name];
}
