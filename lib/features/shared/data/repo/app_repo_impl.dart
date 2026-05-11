import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/shared/data/data_source/app_data_source.dart';
import 'package:mokawlcom_app/features/shared/data/models/app_version_model.dart';
import 'package:mokawlcom_app/features/shared/data/repo/app_repo.dart';

class AppRepoImpl implements AppRepo {
  final AppDataSource appDataSource;

  AppRepoImpl({required this.appDataSource});

  @override
  Future<Either<Failure, AppVersionModel>> getAppVersion() async =>
      await safeApiCall<AppVersionModel>(() => appDataSource.getAppVersion());
}
