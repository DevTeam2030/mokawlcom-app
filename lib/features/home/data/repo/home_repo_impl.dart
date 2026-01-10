import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/home/data/data_source/home_data_source.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeDataSource homeDataSource;
  HomeRepoImpl({required this.homeDataSource});
  @override
  Future<Either<Failure, List<String>>> getBanners() async =>
      await safeApiCall<List<String>>(()async => await homeDataSource.getBanners());
}
