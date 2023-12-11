import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  String assignedMember;
  final String projectId;
  double workedHours;

  TaskModel({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.assignedMember,
    required this.createdAt,
    required this.projectId,
    this.workedHours = 0,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'].toDate(),
      endDate: json['endDate'].toDate(),
      createdAt: json['createdAt'].toDate(),
      assignedMember: json['assignedMember'],
      projectId: json['projectId'],
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
      'assignedMember': assignedMember,
      'projectId': projectId,
      'workedHours': workedHours,
    };
  }

  @override
  List<Object> get props => [
        name,
        description,
        startDate,
        endDate,
        assignedMember,
        createdAt,
        projectId,
        workedHours,
      ];
}
