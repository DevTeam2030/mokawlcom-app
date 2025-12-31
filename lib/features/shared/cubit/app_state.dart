import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';

class AppState extends Equatable {
  final UserType userType;
  final bool isArabic;

  const AppState({this.userType = UserType.visitor,  this.isArabic = true});

  AppState copyWith({UserType? userType, bool? isArabic}) {
    return AppState(
      userType: userType ?? this.userType,
      isArabic: isArabic ?? this.isArabic,
    );
  }

  @override
  List<Object?> get props => [userType, isArabic];
}
