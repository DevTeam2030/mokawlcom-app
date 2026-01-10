import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';

class ClassificationsModel extends Equatable {
  final int totalPages;
  final int currentPage;
  final List<ClassificationModel> classifications;

  const ClassificationsModel({
    required this.totalPages,
    required this.currentPage,
    required this.classifications,
  });

  factory ClassificationsModel.fromJson(Map<String, dynamic> json) =>
      ClassificationsModel(
        totalPages: json["data"]?["total_pages"],
        currentPage: json["data"]?["current_page"],
        classifications: List<ClassificationModel>.from(
          (json["data"]?["categories"] as List<dynamic>? ?? []).map(
            (x) => ClassificationModel.fromJson(x),
          ),
        ),
      );
  const ClassificationsModel.empty() : this(
    totalPages: 0,
    currentPage: 0,
    classifications: const [],
  );

  @override
  List<Object> get props => [totalPages, currentPage, classifications];
}
