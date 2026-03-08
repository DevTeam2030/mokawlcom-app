import 'package:equatable/equatable.dart';

class PlanModel extends Equatable {
  final int numberOfMonths;
  final String startDate;
  final String endDate;

  const PlanModel({required this.numberOfMonths, required this.startDate, required this.endDate});
  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    numberOfMonths: json['no_months'] ?? 0,
    startDate: json['start_date'] ?? '',
    endDate: json['end_date'] ?? '',
  );
  const PlanModel.empty() : this(numberOfMonths: 0, startDate: '', endDate: '');
  @override
  List<Object> get props => [numberOfMonths, startDate, endDate];
}
