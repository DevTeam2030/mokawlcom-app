import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classifications_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/services_model.dart';

ClassificationsModel parseClassificationsModel(Map<String, dynamic> json) {
  return ClassificationsModel.fromJson(json);
}

ServicesModel parseServicesModel(Map<String, dynamic> json) {
  return ServicesModel.fromJson(json);
}
