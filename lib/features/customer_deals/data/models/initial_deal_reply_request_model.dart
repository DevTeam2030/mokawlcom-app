import 'dart:io';

import 'package:equatable/equatable.dart';

class InitialDealReplyRequestModel extends Equatable {
  const InitialDealReplyRequestModel({
    required this.dealId,
    required this.price,
    required this.message,
    required this.files,
  });

  final int dealId;
  final String price;
  final String message;
  final List<File> files;

  @override
  List<Object> get props => [dealId, price, message, files];
}
