import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/add_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/change_password_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/edit_contractor_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_offers_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, String>> updateProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  });
  Future<Either<Failure, String>> changeProfileImage({required File image});
  Future<Either<Failure, String>> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  });
  Future<Either<Failure, String>> deleteAccount();
  Future<Either<Failure, String>> editContractorProfile({
    required EditContractorProfileRequestModel
    editContractorProfileRequestModel,
  });
  Future<Either<Failure, String>> logout();
  Future<Either<Failure, UserModel>> getUserProfile();
  Future<Either<Failure, UserOffersModel>> getUserOffers({required int page});
  Future<Either<Failure, ContractorServicesModel>> getContractorServices({
    required int page,
  });
  Future<Either<Failure, UserModel>> getContractorProfile();
  Future<Either<Failure, String>> addService({
    required AddServiceRequestModel addServiceRequestModel,
    required void Function(int, int)? onSendProgress,
  }); 
}
