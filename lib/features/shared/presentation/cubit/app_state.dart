import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';

class AppState extends Equatable {
  final UserType userType;
  final bool isArabic;
  final String classification;

  const AppState({
    this.userType = UserType.visitor,
    this.isArabic = true,
    this.classification = '',
  });

  AppState copyWith({
    UserType? userType,
    bool? isArabic,
    String? classification,
  }) {
    return AppState(
      userType: userType ?? this.userType,
      isArabic: isArabic ?? this.isArabic,
      classification: classification ?? this.classification,
    );
  }

  @override
  List<Object?> get props => [
        userType,
        isArabic,
        classification,
      ];
}
