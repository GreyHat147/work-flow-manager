import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/project_model.dart';
import 'package:work_flow_manager/repository/projects/projects_state.dart';

class ProjectsRepository extends Cubit<ProjectsState> {
  final FirebaseFirestore _firestore;

  ProjectsRepository(this._firestore) : super(ProjectsInitialState()) {
    /*  getProjects();
    getMembers(); */
  }

  void getProjects() async {
    emit(ProjectsLoadingState());
    _firestore
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final projects = snapshot.docs
          .map((doc) => ProjectModel.fromJson(doc.data()))
          .toList();
      emit(ProjectsLoadedState(projects: projects));
    });
  }

  void getProject(String id) async {
    emit(ProjectsLoadingState());
    _firestore.collection('projects').doc(id).snapshots().listen((snapshot) {
      final project = ProjectModel.fromJson(snapshot.data()!);
      print("found project");
      print(project);
      emit(ProjectDetailsState(projectSelected: project));
    });
  }

  void addProject(ProjectModel project) async {
    await _firestore
        .collection('projects')
        .doc(project.id)
        .set(project.toJson());
    emit(ProjectsLoadedState(wasProjectCreated: true));
  }

  void updateProject(ProjectModel project) async {
    await _firestore
        .collection('projects')
        .doc(project.id)
        .update(project.toJson());
  }

  void deleteProject(ProjectModel project) async {
    await _firestore.collection('projects').doc(project.id).delete();
  }

  void setProject(ProjectModel project) {
    print("setProject");
    print(project);
    emit(
      ProjectsLoadedState(
          projectSelected: project,
          wasProjectCreated: false,
          projects: (state as ProjectsLoadedState).projects),
    );
  }

  void getMembers() async {
    emit(ProjectsLoadingState());
    _firestore.collection('members').snapshots().listen((snapshot) {
      final members =
          snapshot.docs.map((doc) => MemberModel.fromJson(doc.data())).toList();
      print(members);
      emit(ProjectsLoadedState(members: members));
    });

    print('getMembers');
  }

  void removeMemberByProject(String memberId, ProjectModel project) async {
    print('removeMemberByProject');

    project.members.removeWhere((element) => element.id == memberId);

    await _firestore
        .collection('projects')
        .doc(project.id!)
        .update(project.toJson());

    getProject(project.id!);
  }

  void removeTaskByProject(String taskId, ProjectModel project) async {
    print('removeTaskByProject');
    print(taskId);

    project.tasks.removeWhere((element) => element.id == taskId);

    await _firestore
        .collection('projects')
        .doc(project.id!)
        .update(project.toJson());

    getProject(project.id!);
  }
}
