import 'dart:io';

import 'package:equatable/equatable.dart';

class AddServiceRequestModel extends Equatable {
  final String name;
  final String description;
  final String price;
  final List<File>? images;

  const AddServiceRequestModel({
    required this.name,
    required this.description,
    required this.price,
    this.images,
  });

  

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [
        name,
        description,
        price,
        images,
      ];
}