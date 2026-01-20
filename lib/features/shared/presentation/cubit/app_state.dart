import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';

class AppState extends Equatable {
  final UserType userType;
  final bool isArabic;
  final bool areNotificationsEnabled;

  const AppState({
    this.userType = UserType.visitor,
    this.isArabic = true,
    this.areNotificationsEnabled = false,
  });

  AppState copyWith({
    UserType? userType,
    bool? isArabic,
    bool? areNotificationsEnabled,
  }) {
    return AppState(
      userType: userType ?? this.userType,
      isArabic: isArabic ?? this.isArabic,
      areNotificationsEnabled:
          areNotificationsEnabled ?? this.areNotificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [userType, isArabic, areNotificationsEnabled];
}
