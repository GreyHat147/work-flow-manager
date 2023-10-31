import 'package:equatable/equatable.dart';

class RecordModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  const RecordModel({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  @override
  List<Object> get props => [
        name,
        description,
        startDate,
        endDate,
      ];
}
