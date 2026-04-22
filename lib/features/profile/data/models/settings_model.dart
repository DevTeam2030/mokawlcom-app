import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final String privacyPolicy;
  final String termsAndConditions;
  final String email;

  const SettingsModel({
    required this.privacyPolicy,
    required this.termsAndConditions,
    required this.email,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      privacyPolicy: json['privacy_policy'] ?? '',
      termsAndConditions: json['about_us'] ?? '',
      email: json['contact_us_email'] ?? '',
    );
  }

  const SettingsModel.empty()
      : this(privacyPolicy: "", termsAndConditions: "", email: "");

  @override
  List<Object> get props => [privacyPolicy, termsAndConditions, email];
}
