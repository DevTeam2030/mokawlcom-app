import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/setting_result_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';

abstract class ContractorAuthRepo {
  Future<Either<Failure, SettingsResultModel>> getSettings();
  List<SettingsModel> get classifications;
  List<SettingsModel> get services;
}
