import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';

class UserOffersModel extends Equatable {
  final int totalPages;
  final int currentPage;
  final List<OfferModel> offers;

  const UserOffersModel({
    required this.totalPages,
    required this.currentPage,
    required this.offers,
  });

  factory UserOffersModel.fromJson(Map<String, dynamic> json) {
    return UserOffersModel(
      totalPages: json["total_pages"] ?? 0,
      currentPage: json["current_page"] ?? 0,
      offers: (json["offers"] as List<dynamic>? ?? [])
          .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  const UserOffersModel.empty()
    : this(totalPages: 0, currentPage: 0, offers: const []);

  UserOffersModel copyWith({List<OfferModel>? offers}) {
    return UserOffersModel(
      totalPages: totalPages,
      currentPage: currentPage,
      offers: offers ?? this.offers,
    );
  }

  @override
  List<Object> get props => [totalPages, currentPage, offers];
}
