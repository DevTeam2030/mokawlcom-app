import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class AddOfferPriceRequestModel extends Equatable {
  final int contractorId;
  final String title;
  final String message;
  final String price;
  final File? file;

  const AddOfferPriceRequestModel({
    required this.contractorId,
    required this.title,
    required this.message,
    required this.price,
    required this.file,
  });

  Map<String, dynamic> toJson() => {
    "contractor_id": contractorId,
    "title": title,
    "message": message,
    "price": price,
  };

  @override
  List<Object?> get props => [contractorId, title, message, price, file];
}
