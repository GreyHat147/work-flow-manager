import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/task_model.dart';
import 'package:work_flow_manager/repository/tasks/tasks_state.dart';

class TasksRepository extends Cubit<TasksState> {
  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;
  TasksRepository(
    this._firestore,
    this._sharedPreferences,
  ) : super(TasksInitialState());

  void getTasks() async {
    _firestore.collection('tasks').snapshots().listen((snapshot) {
      final tasks = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void getTasksByUser(String projectId) async {
    String userId = _sharedPreferences.getString('id')!;
    final snapshots = await _firestore
        .collection('tasks')
        .where('assignedMember', isEqualTo: userId)
        .where('projectId', isEqualTo: projectId)
        .get();

    final tasks = snapshots.docs.map((doc) => doc.data()).toList();
  }

  void addTask(TaskModel taskModel, String? projectId) async {
    if (projectId != null) {
      await _firestore.collection('projects').doc(projectId).update({
        'tasks': FieldValue.arrayUnion([taskModel.toJson()])
      });
    }

    await _firestore.collection('tasks').add(taskModel.toJson());

    emit(TasksLoadedState(wasTaskCreated: true));
  }

  void deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  void getMembers() async {
    final membersSnapshot = await _firestore.collection('members').get();
    final members = membersSnapshot.docs
        .map((e) => MemberModel.fromJson(e.data()))
        .toList();
    members.removeWhere((element) => element.id == "5NlEdhBMAeXHgIeBS1wf");
    emit(
      TasksLoadedState(
        members: members,
      ),
    );
  }
}
