import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/complete_contractor_data_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/contractor_sign_up_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classifications_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/services_model.dart';

abstract class ContractorAuthRepo {
  Future<Either<Failure, ClassificationsModel>> getClassifications({
    required int page,
  });
  Future<Either<Failure, ServicesModel>> getServices({
    required int page,
    required int classificationId,
  });
  Future<Either<Failure, String>> contractorSignUp({
    required ContractorSignUpRequestModel contractorSignUpRequestModel,
  });
  Future<Either<Failure, String>> uploadCommercialRegistry({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<Either<Failure, String>> uploadTradeLicense({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<Either<Failure, String>> uploadEstablishmentCertificate({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<Either<Failure, String>> uploadAuthorizedSignature({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<Either<Failure, String>> completeContractorData({
    required CompleteContractorDataRequestModel
    completeContractorDataRequestModel,
  });
  Future<Either<Failure, String>> subscibePlan();
}
