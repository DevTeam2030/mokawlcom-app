import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';

class SettingsResultModel extends Equatable {
  final List<SettingsModel> classifications;
  final List<SettingsModel> services;
  final List<String> banners;

  const SettingsResultModel({
    required this.classifications,
    required this.services,
    required this.banners,
  });
  const SettingsResultModel.empty()
    : this(classifications: const [], services: const [], banners: const []);
 
  @override
  List<Object> get props => [classifications, services, banners];
}
