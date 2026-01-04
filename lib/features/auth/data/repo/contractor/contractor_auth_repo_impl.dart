import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/auth/data/data_source/contractor_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/setting_result_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';

class ContractorAuthRepoImpl implements ContractorAuthRepo {
  final ContractorAuthDataSource contractorAuthDataSource;

  ContractorAuthRepoImpl({required this.contractorAuthDataSource});
  List<SettingsModel> _classfications = [];
  List<SettingsModel> _services = [];

  @override
  List<SettingsModel> get classifications => _classfications;

  @override
  List<SettingsModel> get services => _services;

  @override
  Future<Either<Failure, SettingsResultModel>> getSettings() async {
    final result = await safeApiCall<Map<String, dynamic>>(
      () => contractorAuthDataSource.getSettings(),
    );
    return result.fold((failure) => Left(failure), (r) {
      _classfications = ((r["data"]?["categories"] as List?)??[])
          .map((e) => SettingsModel.fromJson(e))
          .toList();

      _services = ((r["data"]?["subCategories"] as List?)??[])
          .map((e) => SettingsModel.fromJson(e))
          .toList();

      return Right(
        SettingsResultModel(
          classifications: _classfications,
          services: _services,
        ),
      );
    });
  }
}
