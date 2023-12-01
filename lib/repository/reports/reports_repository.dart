import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/project_model.dart';

abstract class ReportsState extends Equatable {}

class ReportsInitial extends ReportsState {
  @override
  List<Object?> get props => [];
}

class ReportsLoading extends ReportsState {
  @override
  List<Object?> get props => [];
}

class ReportsLoaded extends ReportsState {
  ReportsLoaded({
    this.projects = const [],
    this.hoursByProject,
    this.hoursByMemberOfProject = const [],
    this.tasksByMemberOfProject = const [],
    this.membersByProject = const [],
  });

  final List<ProjectModel> projects;
  final double? hoursByProject;
  final List<Map<String, dynamic>> hoursByMemberOfProject;
  final List<Map<String, dynamic>> tasksByMemberOfProject;
  final List<Map<String, dynamic>> membersByProject;

  @override
  List<Object?> get props => [
        projects,
        hoursByProject,
        hoursByMemberOfProject,
        tasksByMemberOfProject,
        membersByProject,
      ];

  ReportsLoaded copyWith({
    List<ProjectModel>? projects,
    double? hoursByProject,
    List<Map<String, dynamic>>? hoursByMemberOfProject,
    List<Map<String, dynamic>>? tasksByMemberOfProject,
    List<Map<String, dynamic>>? membersByProject,
  }) {
    return ReportsLoaded(
      projects: projects ?? this.projects,
      hoursByProject: hoursByProject ?? this.hoursByProject,
      hoursByMemberOfProject:
          hoursByMemberOfProject ?? this.hoursByMemberOfProject,
      tasksByMemberOfProject:
          tasksByMemberOfProject ?? this.tasksByMemberOfProject,
      membersByProject: membersByProject ?? this.membersByProject,
    );
  }
}

class ReportsRepository extends Cubit<ReportsState> {
  ReportsRepository(this._firestore) : super(ReportsInitial());

  final FirebaseFirestore _firestore;

  Future<void> getProjects() async {
    emit(ReportsLoading());
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('projects').get();
    final List<ProjectModel> projects =
        querySnapshot.docs.map((e) => ProjectModel.fromJson(e.data())).toList();
    emit(ReportsLoaded(projects: projects));
  }

  Future<void> getHoursByProject(String projectId) async {
    final DocumentSnapshot projectSnapshot = await getProject(projectId);

    if (projectSnapshot.exists) {
      final ProjectModel project =
          ProjectModel.fromJson(projectSnapshot.data()!);
      emit((state as ReportsLoaded)
          .copyWith(hoursByProject: project.totalHours));
    }
  }

  Future<void> getHoursByMemberOfProject(String projectId,
      [DateTime? start, DateTime? end]) async {
    final DocumentSnapshot projectSnapshot = await getProject(projectId);

    if (projectSnapshot.exists) {
      final ProjectModel project =
          ProjectModel.fromJson(projectSnapshot.data()!);
      List<Map<String, dynamic>> hoursByMemberOfProject = [];

      final List<MemberModel> employees = project.members
          .where((element) => element.memberType == 'Empleado')
          .toList();

      for (var member in employees) {
        hoursByMemberOfProject.add({
          'name': member.name,
          'hours': member.workedHours,
        });
      }

      emit((state as ReportsLoaded)
          .copyWith(hoursByMemberOfProject: hoursByMemberOfProject));
    }
  }

  Future<void> getMembersByProject(String projectId) async {
    final ProjectModel project = ProjectModel.fromJson(
        (await getProject(projectId)).data()! as Map<String, dynamic>);
    List<Map<String, dynamic>> membersByProject = [];

    for (MemberModel member in project.members) {
      membersByProject.add({
        'id': member.id,
        'name': member.name,
        'workedHours': project.members.length,
      });
    }

    emit((state as ReportsLoaded).copyWith(membersByProject: membersByProject));
  }

  Future<void> getTasksByMember(String projectId) async {
    final DocumentSnapshot projectSnapshot = await getProject(projectId);

    if (projectSnapshot.exists) {
      final ProjectModel project =
          ProjectModel.fromJson(projectSnapshot.data()!);
      List<Map<String, dynamic>> tasksByMemberOfProject = [];

      for (var task in project.tasks) {
        final DocumentSnapshot snapshot = await getMember(task.assignedMember);

        if (snapshot.exists) {
          final MemberModel member =
              MemberModel.fromJson(snapshot.data()! as Map<String, dynamic>);
          if (member.memberType == 'Gerente') return;
          final memberExists = tasksByMemberOfProject
              .where((element) => element['id'] == member.id);

          if (memberExists.isEmpty) {
            tasksByMemberOfProject.add({
              'id': member.id,
              'name': member.name,
              'tasks': 1,
            });
          } else {
            tasksByMemberOfProject = tasksByMemberOfProject.map((e) {
              if (e['id'] == member.id) {
                e['tasks'] = e['tasks']++;
              }
              return e;
            }).toList();
          }
        }
      }
      emit((state as ReportsLoaded)
          .copyWith(tasksByMemberOfProject: tasksByMemberOfProject));
    }
  }

  Future<DocumentSnapshot> getProject(String projectId) async {
    final DocumentSnapshot projectSnapshot =
        await _firestore.collection('projects').doc(projectId).get();

    return projectSnapshot;
  }

  Future<DocumentSnapshot> getMember(String memberId) async {
    final DocumentSnapshot memberSnapshot =
        await _firestore.collection('members').doc(memberId).get();

    return memberSnapshot;
  }
}
