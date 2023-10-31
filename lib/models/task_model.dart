import 'package:equatable/equatable.dart';
import 'package:work_flow_manager/models/member_model.dart';

class TaskModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final MemberModel assignedMember;

  const TaskModel({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.assignedMember,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      assignedMember: json['assignedMember'],
    );
  }

  @override
  List<Object> get props => [
        name,
        description,
        startDate,
        endDate,
        assignedMember,
      ];
}
