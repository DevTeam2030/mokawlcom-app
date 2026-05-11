import 'dart:io';

import 'package:equatable/equatable.dart';

class EditServiceRequestModel extends Equatable {
  final int serviceId;
  final String classificationId;
  final String name;
  final String description;
  final String price;
  final List<File>? images;

  const EditServiceRequestModel({
    required this.serviceId,
    required this.classificationId,
    required this.name,
    required this.description,
    required this.price,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'category_id': classificationId,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [
    serviceId,
    classificationId,
    name,
    description,
    price,
    images,
  ];
}
