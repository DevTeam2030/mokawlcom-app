import 'package:equatable/equatable.dart';

class AppVersionModel extends Equatable {
  final PlatformVersionModel android;
  final PlatformVersionModel ios;

  const AppVersionModel({required this.android, required this.ios});

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      android: PlatformVersionModel.fromJson(
        json['android'] as Map<String, dynamic>? ?? const {},
      ),
      ios: PlatformVersionModel.fromJson(
        json['ios'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  @override
  List<Object> get props => [android, ios];
}

class PlatformVersionModel extends Equatable {
  final String minVersion;
  final String latestVersion;
  final bool forceUpdate;
  final String updateUrl;
  final String message;
  final bool maintainanceMode;
  final String maintainanceMessage;

  const PlatformVersionModel({
    required this.minVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.updateUrl,
    required this.message,
    required this.maintainanceMode,
    required this.maintainanceMessage,
  });

  factory PlatformVersionModel.fromJson(Map<String, dynamic> json) {
    return PlatformVersionModel(
      minVersion: json['min_version'] as String? ?? '0.0.0',
      latestVersion: json['latest_version'] as String? ?? '0.0.0',
      forceUpdate: json['force_update'] as bool? ?? false,
      updateUrl: json['update_url'] as String? ?? '',
      message: json['message'] as String? ?? '',
      maintainanceMode: json['maintenance_mode'] as bool? ?? false,
      maintainanceMessage: json['maintenance_message'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [
    minVersion,
    latestVersion,
    forceUpdate,
    updateUrl,
    message,
    maintainanceMode,
    maintainanceMessage,
  ];
}
