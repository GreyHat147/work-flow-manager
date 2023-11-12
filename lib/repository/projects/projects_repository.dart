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
    //emit(ProjectsLoadingState());
    /* _firestore.collection('projects').doc(id).snapshots().listen((snapshot) {
      final project = ProjectModel.fromJson(snapshot.data()!);
      //emit(ProjectDetailsState(projectSelected: project));
    }); */

    print('getting details');

    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('projects').doc(id).get();
    emit(ProjectDetailsState(
        projectSelected: ProjectModel.fromJson(documentSnapshot.data()!)));
  }

  void addProject(ProjectModel project) async {
    await _firestore
        .collection('projects')
        .doc(project.id)
        .set(project.toJson());

    List<String> membersId = project.members.map((e) => e.id!).toList();

    await _firestore
        .collection('members')
        .where('id', whereIn: membersId)
        .get()
        .then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) async {
        MemberModel member = MemberModel.fromJson(element.data());
        member.projects.add(project.id!);
        await _firestore
            .collection('members')
            .doc(member.id)
            .update(member.toJson());
      });
    });

    emit(ProjectsLoadedState(wasProjectCreated: true));
  }

  void updateProject(ProjectModel project) async {
    await _firestore
        .collection('projects')
        .doc(project.id)
        .update(project.toJson());
  }

  void deleteProject(String projectId) async {
    await _firestore.collection('projects').doc(projectId).delete();
    emit(ProjectDeletedState());
  }

  void setProject(ProjectModel project) {
    emit(
      ProjectsLoadedState(
          projectSelected: project,
          wasProjectCreated: false,
          projects: (state as ProjectsLoadedState).projects),
    );
  }

  void getMembers() async {
    final snapshot = await _firestore.collection('members').get();
    final members =
        snapshot.docs.map((doc) => MemberModel.fromJson(doc.data())).toList();
    emit(ProjectsLoadedState(members: members));
  }

  void removeMemberByProject(String memberId, ProjectModel project) async {
    project.members.removeWhere((element) => element.id == memberId);

    await _firestore
        .collection('projects')
        .doc(project.id!)
        .update(project.toJson());

    getProject(project.id!);
  }

  void removeTaskByProject(String taskId, ProjectModel project) async {
    project.tasks.removeWhere((element) => element.id == taskId);

    await _firestore
        .collection('projects')
        .doc(project.id!)
        .update(project.toJson());

    getProject(project.id!);
  }
}
