import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/models/record_model.dart';
import 'package:work_flow_manager/repository/record/record_state.dart';

class RecordRepository extends Cubit<RecordState> {
  RecordRepository(this._firestore) : super(RecordInitialState());
  final FirebaseFirestore _firestore;

  Future<void> addRecord(RecordModel recordModel) async {
    await _firestore
        .collection('records')
        .doc(recordModel.id)
        .set(recordModel.toJson());

    emit(RecordLoadedState(recordCreated: true));
  }

  Future<void> updateRecord(RecordModel recordModel) async {
    await _firestore
        .collection('records')
        .doc(recordModel.id)
        .update(recordModel.toJson());

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
