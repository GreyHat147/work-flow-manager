import 'package:equatable/equatable.dart';

class RecordModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final String taskId;
  final int workedHours;

  const RecordModel({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.taskId,
    required this.workedHours,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'].toDate(),
      endDate: json['endDate'].toDate(),
      createdAt: json['createdAt'].toDate(),
      taskId: json['taskId'],
      workedHours: json['workedHours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'taskId': taskId,
      'workedHours': workedHours,
    };
  }

  @override
  List<Object> get props => [
        name,
        description,
        startDate,
        endDate,
        createdAt,
        taskId,
        workedHours,
      ];
}
