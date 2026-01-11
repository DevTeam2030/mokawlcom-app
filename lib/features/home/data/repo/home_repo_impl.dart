import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/home/data/data_source/home_data_source.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_details_model.dart';
import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeDataSource homeDataSource;
  HomeRepoImpl({required this.homeDataSource});
  @override
  Future<Either<Failure, List<String>>> getBanners() async =>
      await safeApiCall<List<String>>(
        () async => await homeDataSource.getBanners(),
      );
  @override
  Future<Either<Failure, ContractorsModel>> getContractors({
    required int page,
    int? classification,
    int? service,
    String? search,
  }) async => await safeApiCall<ContractorsModel>(
    () async => await homeDataSource.getContractors(
      page: page,
      classification: classification,
      service: service,
      search: search,
    ),
  );
  @override
  Future<Either<Failure, ContractorDetailsModel>> getContractorDetails({
    required int contractorId,
  }) async => await safeApiCall<ContractorDetailsModel>(
    () async => await homeDataSource.getContractorDetails(
      contractorId: contractorId,
    ),
  );
}
