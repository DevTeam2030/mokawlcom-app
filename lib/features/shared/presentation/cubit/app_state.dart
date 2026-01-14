import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';

class AppState extends Equatable {
  final UserType userType;
  final bool isArabic;
  final bool areNotificationsEnabled;
  final int tabIndex;

  const AppState({
    this.userType = UserType.visitor,
    this.isArabic = true,
    this.areNotificationsEnabled = false,
    this.tabIndex = 0,
  });

  AppState copyWith({
    UserType? userType,
    bool? isArabic,
    bool? areNotificationsEnabled,
    int? tabIndex,
  }) {
    return AppState(
      userType: userType ?? this.userType,
      isArabic: isArabic ?? this.isArabic,
      areNotificationsEnabled:
          areNotificationsEnabled ?? this.areNotificationsEnabled,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  List<Object?> get props => [
        userType,
        isArabic,
        areNotificationsEnabled,
        tabIndex,
      ];
}
