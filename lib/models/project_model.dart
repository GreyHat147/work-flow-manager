import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/task_model.dart';

class ProjectModel extends Equatable {
  final String? id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final String projectType;
  final List<MemberModel> members;
  final List<TaskModel> tasks;

  const ProjectModel({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.projectType,
    required this.members,
    required this.createdAt,
    this.tasks = const [],
  });

  static ProjectModel fromJson(dynamic json) {
    print(json['startDate'].runtimeType);
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      projectType: json['projectType'],
      startDate: json['startDate'].toDate(),
      endDate: json['endDate'].toDate(),
      members: json['members']
          .map<MemberModel>((e) => MemberModel.fromJson(e))
          .toList(),
      createdAt: json['createdAt'].toDate(),
      tasks: json['tasks'] != null
          ? json['tasks'].map<TaskModel>((e) => TaskModel.fromJson(e)).toList()
          : [],
    );
  }

  dynamic toJson() {
    return {
      'id': id,
      'name': name,
      'projectType': projectType,
      'startDate': startDate,
      'endDate': endDate,
      'members': members.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'tasks': tasks.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props =>
      [name, startDate, endDate, members, projectType, createdAt, tasks];
}
