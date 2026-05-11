import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorites_model.dart';

abstract class FavoriteRepo {
  Future<Either<Failure, FavoritesModel>> getFavorites({required int page});
  Future<Either<Failure, FavoriteModel>> addFavorite({
    required int contractorId,
  });
  Future<Either<Failure, String>> removeFavorite({required int contractorId});
}
