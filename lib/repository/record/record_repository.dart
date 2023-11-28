import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/project_model.dart';
import 'package:work_flow_manager/models/record_model.dart';
import 'package:work_flow_manager/repository/record/record_state.dart';

class RecordRepository extends Cubit<RecordState> {
  RecordRepository(this._firestore, this._sharedPreferences)
      : super(RecordInitialState());
  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;

  Future<void> addRecord(RecordModel recordModel, String projectId) async {
    final String? id = _sharedPreferences.getString('id');
    await _firestore
        .collection('records')
        .doc(recordModel.id)
        .set(recordModel.toJson());

    // 1. Update general hours
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('projects').doc(projectId).get();

    final ProjectModel projectModel = ProjectModel.fromJson(snapshot.data()!);

    MemberModel member =
        projectModel.members.firstWhere((element) => element.id == id);

    member.workedHours = member.workedHours + recordModel.workedHours;

    await _firestore.collection('projects').doc(projectId).update({
      'totalHours': FieldValue.increment(recordModel.workedHours),
      'members': projectModel.members.map((e) => e.toJson()),
    });

    emit(RecordLoadedState(recordCreated: true));
  }

  Future<void> updateRecord(RecordModel recordModel, String projectId) async {
    final String? id = _sharedPreferences.getString('id');
    await _firestore
        .collection('records')
        .doc(recordModel.id)
        .update(recordModel.toJson());

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('projects').doc(projectId).get();

    final ProjectModel projectModel = ProjectModel.fromJson(snapshot.data()!);

    MemberModel member =
        projectModel.members.firstWhere((element) => element.id == id);

    member.workedHours = member.workedHours + recordModel.workedHours;

    await _firestore.collection('projects').doc(projectId).update({
      'totalHours': FieldValue.increment(recordModel.workedHours),
      'members': projectModel.members.map((e) => e.toJson()),
    });

    emit(RecordLoadedState(recordUpdated: true));
  }

  Future<void> deleteRecord(String id) async {
    await _firestore.collection('records').doc(id).delete();
    emit(RecordLoadedState(recordDeleted: true));
  }

  Future<void> getRecordsByTasks(String taskId) async {
    emit(RecordLoadingState());
    final snapshots = await _firestore
        .collection('records')
        .where('taskId', isEqualTo: taskId)
        .orderBy('createdAt', descending: true)
        .get();

    final records =
        snapshots.docs.map((e) => RecordModel.fromJson(e.data())).toList();

    emit(RecordLoadedState(records: records));
  }

  Future<void> getRecord(String recordId) async {
    final snapshot = await _firestore.collection('records').doc(recordId).get();

    final record = RecordModel.fromJson(snapshot.data()!);
  }
}
