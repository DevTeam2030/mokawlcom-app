import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';

class FavoritesModel extends Equatable {
  final int currentpage;
  final int totalPages;
  final List<FavoriteModel> favorites;

  const FavoritesModel({
    required this.currentpage,
    required this.totalPages,
    required this.favorites,
  });
  factory FavoritesModel.fromJson(Map<String, dynamic> json) => FavoritesModel(
    currentpage: json["current_page"],
    totalPages: json["total_pages"],
    favorites: List<FavoriteModel>.from(
      (json["contractors"] as List? ?? []).map(
        (e) => FavoriteModel.fromJson(e),
      ),
    ),
  );
  const FavoritesModel.empty()
    : this(currentpage: 0, totalPages: 0, favorites: const []);
  FavoritesModel copyWith({List<FavoriteModel>? favorites}) {
    return FavoritesModel(
      currentpage: currentpage,
      totalPages: totalPages,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object> get props => [currentpage, totalPages, favorites];
}
