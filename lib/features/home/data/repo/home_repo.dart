import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<String>>> getBanners();
} 