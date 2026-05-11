import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/home/data/models/add_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_details_model.dart';
import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<String>>> getBanners();
  Future<Either<Failure, ContractorsModel>> getContractors({
    required int page,
    int? classification,
    int? service,
    String? search,
  });
  Future<Either<Failure, ContractorDetailsModel>> getContractorDetails({
    required int contractorId,
  });
  Future<Either<Failure, void>> rateContractor({
    required String contractorId,
    required String rating,
  });
  Future<Either<Failure, String>> addOfferPrice({
    required AddOfferPriceRequestModel addOfferPriceRequestModel,
    required void Function(double progress) onProgress,
  });
}
