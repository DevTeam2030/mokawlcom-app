import 'dart:io';

import 'package:equatable/equatable.dart';

class AddCustomerDealRequestModel extends Equatable {
  const AddCustomerDealRequestModel({
    required this.title,
    required this.details,
    required this.categoryIds,
    required this.files,
  });

  final String title;
  final String details;
  final List<int> categoryIds;
  final List<File> files;

  @override
  List<Object> get props => [title, details, categoryIds, files];
}
