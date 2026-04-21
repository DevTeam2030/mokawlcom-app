import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/shared/data/models/app_version_model.dart';

abstract class AppRepo {
  Future<Either<Failure, AppVersionModel>> getAppVersion();
}
