import 'package:equatable/equatable.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/project_model.dart';

abstract class ProjectsState extends Equatable {}

class ProjectsInitialState extends ProjectsState {
  @override
  List<Object?> get props => [];
}

class ProjectsLoadingState extends ProjectsState {
  @override
  List<Object?> get props => [];
}

class ProjectDetailsState extends ProjectsState {
  final ProjectModel projectSelected;

  ProjectDetailsState({required this.projectSelected});

  @override
  List<Object?> get props => [];
}

class ProjectsLoadedState extends ProjectsState {
  final List<ProjectModel> projects;
  final ProjectModel? projectSelected;
  final List<MemberModel> members;
  final bool wasProjectCreated;

  ProjectsLoadedState({
    this.projects = const [],
    this.projectSelected,
    this.members = const [],
    this.wasProjectCreated = false,
  });

  @override
  List<Object?> get props => [
        projects,
        projectSelected,
        members,
        wasProjectCreated,
      ];
}

class ProjectsErrorState extends ProjectsState {
  @override
  List<Object?> get props => [];
}
