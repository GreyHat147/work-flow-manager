import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/project_model.dart';
import 'package:work_flow_manager/repository/projects/projects_state.dart';

class ProjectsRepository extends Cubit<ProjectsState> {
  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;

  ProjectsRepository(
    this._firestore,
    this._sharedPreferences,
  ) : super(ProjectsInitialState());

  String? getUserId() {
    return _sharedPreferences.getString('id');
  }

  void getProjectsByUser() async {
    emit(ProjectsLoadingState());
    String? userId = _sharedPreferences.getString('id');
    if (userId == null) return;
    final snapshot = await _firestore.collection('members').doc(userId).get();

    if (snapshot.data() != null) {
      final MemberModel memberModel = MemberModel.fromJson(snapshot.data()!);

      final snapshotProjects = await _firestore
          .collection('projects')
          .where('id', whereIn: memberModel.projects)
          .orderBy('createdAt', descending: true)
          .get();

      final List<ProjectModel> projects = snapshotProjects.docs
          .map((doc) => ProjectModel.fromJson(doc.data()))
          .toList();

      emit(ProjectsByUser(projects: projects));
    } else {
      emit(ProjectsByUser(projects: const []));
    }
  }

  void getProjects() async {
    print("getting projects");
    emit(ProjectsLoadingState());
    await _firestore
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      print(value.docs);
      emit(ProjectsLoadedState(
          projects: value.docs
              .map((doc) => ProjectModel.fromJson(doc.data()))
              .toList()));
    });
  }

  void getProject(String id) async {
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('projects').doc(id).get();
    if (documentSnapshot.data() == null) return;
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

    members.removeWhere((element) => element.id == "5NlEdhBMAeXHgIeBS1wf");
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
