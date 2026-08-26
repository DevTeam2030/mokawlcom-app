import 'dart:io';

import 'package:equatable/equatable.dart';

class UpdateCustomerDealRequestModel extends Equatable {
  const UpdateCustomerDealRequestModel({
    required this.id,
    required this.title,
    required this.details,
    required this.categoryIds,
    required this.newFiles,
  });

  final int id;
  final String title;
  final String details;
  final List<int> categoryIds;
  final List<File> newFiles;

  @override
  List<Object> get props => [id, title, details, categoryIds, newFiles];
}
