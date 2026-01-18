import 'dart:io';

import 'package:equatable/equatable.dart';

class AddServiceRequestModel extends Equatable {
  final String classificationId;
  final String name;
  final String description;
  final String price;
  final List<File>? images;

  const AddServiceRequestModel({
    required this.classificationId,
    required this.name,
    required this.description,
    required this.price,
    this.images,
  });

  

  Map<String, dynamic> toJson() {
    return {
      'category_id': classificationId,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [
        classificationId,
        name,
        description,
        price,
        images,
      ];
}