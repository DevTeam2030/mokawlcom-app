import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class CompleteContractorDataRequestModel extends Equatable {
  final File logo;
  final String name;
  final String hintAboutComany;
  final String phone;
  final String? whatsApp;
  final String? facebook;
  final String? twitter;
  final String? snapChat;

  const CompleteContractorDataRequestModel({
    required this.logo,
    required this.name,
    required this.hintAboutComany,
    required this.phone,
    required this.whatsApp,
    required this.facebook,
    required this.twitter,
    required this.snapChat,
  });
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "logo": await MultipartFile.fromFile(
        logo.path,
        filename: logo.path.split('/').last,
      ),
      "name": name,
      "store_description": hintAboutComany,
      "phone": phone,
      "whatsapp": whatsApp ?? "",
      "facebook": facebook ?? "",
      "twitter": twitter ?? "",
      "snapchat": snapChat ?? "",
    });
  }

  @override
  List<Object?> get props => [
    logo,
    name,
    hintAboutComany,
    phone,
    whatsApp,
    facebook,
    twitter,
    snapChat,
  ];
}
