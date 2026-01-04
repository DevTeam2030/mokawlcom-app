import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';

class SettingsResultModel extends Equatable {
  final List<SettingsModel> classifications;
  final List<SettingsModel> services;

  const SettingsResultModel({
    required this.classifications,
    required this.services,
  });
  const SettingsResultModel.empty()
    : this(classifications: const [], services: const []);
  @override
  List<Object> get props => [classifications, services];
}
