import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/data/data_source/profile_data_source.dart';
import 'package:mokawlcom_app/features/profile/data/models/plan/plan_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/add_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/edit_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/change_password_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deals_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/edit_contractor_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/service_response_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_offers_model.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileDataSource profileDataSource;

  ProfileRepoImpl({required this.profileDataSource});

  @override
  Future<Either<Failure, String>> updateProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  }) async => safeApiCall<String>(
    () => profileDataSource.updateProfile(
      updateUserProfileRequestModel: updateUserProfileRequestModel,
    ),
  );

  @override
  Future<Either<Failure, String>> changeProfileImage({
    required File image,
  }) async => safeApiCall<String>(
    () => profileDataSource.changeProfileImage(image: image),
  );

  @override
  Future<Either<Failure, String>> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) async => safeApiCall<String>(
    () => profileDataSource.changePassword(
      changePasswordRequestModel: changePasswordRequestModel,
    ),
  );

  @override
  Future<Either<Failure, String>> deleteAccount() async =>
      safeApiCall<String>(() => profileDataSource.deleteAccount());

  @override
  Future<Either<Failure, String>> editContractorProfile({
    required EditContractorProfileRequestModel
    editContractorProfileRequestModel,
  }) async => safeApiCall<String>(
    () => profileDataSource.editContractorProfile(
      editContractorProfileRequestModel: editContractorProfileRequestModel,
    ),
  );

  @override
  Future<Either<Failure, String>> logout() async =>
      safeApiCall<String>(() => profileDataSource.logout());

  @override
  Future<Either<Failure, UserModel>> getUserProfile() async =>
      safeApiCall<UserModel>(() => profileDataSource.getUserProfile());

  @override
  Future<Either<Failure, UserOffersModel>> getUserOffers({
    required int page,
  }) async => safeApiCall<UserOffersModel>(
    () => profileDataSource.getUserOffers(page: page),
  );

  @override
  Future<Either<Failure, ContractorServicesModel>> getContractorServices({
    required int page,
  }) async => safeApiCall<ContractorServicesModel>(
    () => profileDataSource.getContractorServices(page: page),
  );

  @override
  Future<Either<Failure, UserModel>> getContractorProfile() async =>
      safeApiCall<UserModel>(() => profileDataSource.getContractorProfile());

  @override
  Future<Either<Failure, ServiceResponseModel>> addService({
    required AddServiceRequestModel addServiceRequestModel,
    required void Function(int, int)? onSendProgress,
  }) async => safeApiCall<ServiceResponseModel>(
    () => profileDataSource.addService(
      addServiceRequestModel: addServiceRequestModel,
      onSendProgress: onSendProgress,
    ),
  );

  @override
  Future<Either<Failure, ServiceResponseModel>> editService({
    required EditServiceRequestModel editServiceRequestModel,
    required void Function(int, int)? onSendProgress,
  }) async => safeApiCall<ServiceResponseModel>(
    () => profileDataSource.editService(
      editServiceRequestModel: editServiceRequestModel,
      onSendProgress: onSendProgress,
    ),
  );

  @override
  Future<Either<Failure, DealsModel>> getDeals({required int page}) async =>
      safeApiCall<DealsModel>(() => profileDataSource.getDeals(page: page));
  @override
  Future<Either<Failure, String>> addDeal({
    required String title,
    required String description,
  }) async => safeApiCall<String>(
    () => profileDataSource.addDeal(title: title, description: description),
  );
  @override
  Future<Either<Failure, String>> deleteDeal({required int dealId}) async =>
      safeApiCall<String>(() => profileDataSource.deleteDeal(dealId: dealId));
  @override
  Future<Either<Failure, String>> editDeal({
    required int dealId,
    required String title,
    required String description,
  }) async => safeApiCall<String>(
    () => profileDataSource.editDeal(
      dealId: dealId,
      title: title,
      description: description,
    ),
  );

  @override
  Future<Either<Failure, PlanModel>> getPlan() async =>
      safeApiCall<PlanModel>(() => profileDataSource.getPlan());

  @override
  Future<Either<Failure, String>> deleteService({
    required int serviceId,
  }) async => safeApiCall<String>(
    () => profileDataSource.deleteService(serviceId: serviceId),
  );
}
