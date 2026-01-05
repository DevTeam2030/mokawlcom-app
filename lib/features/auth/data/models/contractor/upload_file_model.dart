import 'dart:io';

import 'package:equatable/equatable.dart';

class UploadFileModel extends Equatable {
  final int userId;
  final String fileNumber;
  final File file;
  final String expiryDate;

  const UploadFileModel({
    required this.userId,
    required this.fileNumber,
    required this.file,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [userId, fileNumber, file, expiryDate];
}

