import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';

class OfferDetailsModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final List<OfferModel> replies;

  const OfferDetailsModel({
    required this.currentPage,
    required this.totalPages,
    required this.replies,
  });
  factory OfferDetailsModel.fromJson(Map<String, dynamic> json) {
    return OfferDetailsModel(
      currentPage: json["current_page"] ?? 0,
      totalPages: json["total_pages"] ?? 0,
      replies: List<OfferModel>.from(
        (json["list"] as List? ?? []).map((x) => OfferModel.fromJson(x)),
      ),
    );
  }
  const OfferDetailsModel.empty()
    : this(currentPage: 0, totalPages: 0, replies: const []);

  OfferDetailsModel copyWith({List<OfferModel>? replies}) {
    return OfferDetailsModel(
      currentPage: currentPage,
      totalPages: totalPages,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object> get props => [currentPage, totalPages, replies];
}
