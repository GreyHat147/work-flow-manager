import 'package:equatable/equatable.dart';
import 'package:work_flow_manager/models/member_model.dart';

class ProjectModel extends Equatable {
  final String? id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String projectType;
  final List<MemberModel> members;

  const ProjectModel({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.projectType,
    required this.members,
  });

  @override
  List<Object> get props => [name, startDate, endDate, projectType, members];

  static ProjectModel fromJson(dynamic json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      projectType: json['projectType'],
      members: json['members'].map((e) => MemberModel.fromJson(e)).toList(),
    );
  }

  dynamic toJson() {
    return {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
