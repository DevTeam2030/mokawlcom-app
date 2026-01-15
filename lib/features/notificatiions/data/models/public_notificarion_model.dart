import 'package:equatable/equatable.dart';

class PublicNotificationModel extends Equatable {
  final int id;
  final String title;
  final String body;
  final String date;
  final String time;
  final bool status;

  const PublicNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.time,
    required this.status,
  });
  factory PublicNotificationModel.fromJson(Map<String, dynamic> json) =>
      PublicNotificationModel(
        id: json["id"] ?? 0,
        title: json["not_title"] ?? "",
        body: json["message"] ?? "",
        date: json["date"] ?? "",
        time: json["time"] ?? "",
        status: json["status"] ?? false,
      );
  PublicNotificationModel copyWith({bool? status}) {
    return PublicNotificationModel(
      id: id,
      title: title,
      body: body,
      date: date,
      time: time,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [id, title, body, date, time, status];
}
