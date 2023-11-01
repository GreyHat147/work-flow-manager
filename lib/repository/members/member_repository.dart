import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/repository/members/member_state.dart';

class MemberRepository extends Cubit<MemberState> {
  final FirebaseFirestore _firestore;
  MemberRepository(this._firestore) : super(MemberInitialState());

  void getMembers() async {
    _firestore.collection('members').snapshots().listen((snapshot) {
      final members = snapshot.docs.map((doc) => doc.data()).toList();
      print("members");
      print(members);
    });
  }

  void addMember(MemberModel memberModel, String? projectId) async {
    if (projectId != null) {
      await _firestore.collection('projects').doc(projectId).update({
        'members': FieldValue.arrayUnion([memberModel.toJson()])
      });
    }
    await _firestore.collection('members').add(memberModel.toJson());
    emit(MemberCreationState(wasCreated: true));
  }

  void updateMember(Map<String, dynamic> member) async {
    await _firestore.collection('members').doc(member['id']).update(member);
  }

  void deleteMember(Map<String, dynamic> member) async {
    await _firestore.collection('members').doc(member['id']).delete();
  }
}
