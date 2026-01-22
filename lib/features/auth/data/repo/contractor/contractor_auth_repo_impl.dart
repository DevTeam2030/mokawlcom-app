import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/auth/data/data_source/contractor_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/complete_contractor_data_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/contractor_sign_up_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classifications_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/services_model.dart';

class ContractorAuthRepoImpl implements ContractorAuthRepo {
  final ContractorAuthDataSource contractorAuthDataSource;

  ContractorAuthRepoImpl({required this.contractorAuthDataSource});

  @override
  Future<Either<Failure, ClassificationsModel>>
  getClassifications({
    required int page,
  }) async {
    return await safeApiCall<ClassificationsModel>(
      () => contractorAuthDataSource.getClassifications(page: page),
    );
  }

  @override
  Future<Either<Failure, ServicesModel>> getServices({
    required int page,
    required int classificationId,
  }) async {
    return await safeApiCall<ServicesModel>(
      () => contractorAuthDataSource.getServices(page: page, classificationId: classificationId),
    );
  }

  @override
  Future<Either<Failure, String>> contractorSignUp({
    required ContractorSignUpRequestModel contractorSignUpRequestModel,
  }) async {
    return await safeApiCall<String>(
      () => contractorAuthDataSource.contractorSignUp(
        contractorSignUpRequestModel: contractorSignUpRequestModel,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> uploadCommercialRegistry({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    return await safeApiCall<String>(
      () => contractorAuthDataSource.uploadCommercialRegistry(
        fileModel: fileModel,
        onProgress: onProgress,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> uploadTradeLicense({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    return await safeApiCall<String>(
      () => contractorAuthDataSource.uploadTradeLicense(
        fileModel: fileModel,
        onProgress: onProgress,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> uploadEstablishmentCertificate({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    return await safeApiCall<String>(
      () => contractorAuthDataSource.uploadEstablishmentCertificate(
        fileModel: fileModel,
        onProgress: onProgress,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> uploadAuthorizedSignature({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    return await safeApiCall<String>(
      () => contractorAuthDataSource.uploadAuthorizedSignature(
        fileModel: fileModel,
        onProgress: onProgress,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> completeContractorData({
    required CompleteContractorDataRequestModel
    completeContractorDataRequestModel,
  }) async {
    return await safeApiCall<String>(
      () => contractorAuthDataSource.completeContractorData(
        completeContractorDataRequestModel: completeContractorDataRequestModel,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> subscibePlan() async {
    return await safeApiCall<String>(
      () => contractorAuthDataSource.subscibePlan(),
    );
  }
}
