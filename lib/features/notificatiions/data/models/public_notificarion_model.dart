import 'package:equatable/equatable.dart';

class PublicNotificationModel extends Equatable {
  final int id;
  final String title;
  final String body;
  final String date;
  final String time;

  const PublicNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.time,
  });
  factory PublicNotificationModel.fromJson(Map<String, dynamic> json) =>
      PublicNotificationModel(
        id: json["id"] ?? 0,
        title: json["not_title"] ?? "",
        body: json["message"] ?? "",
        date: json["date"] ?? "",
        time: json["time"] ?? "",
      );

  @override
  List<Object> get props => [id, title, body, date, time];
}
