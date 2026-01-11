import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<String>>> getBanners();
  Future<Either<Failure, ContractorsModel>> getContractors({
    required int page,
    int? classification,
    int? service,
    String? search,
  });
} 