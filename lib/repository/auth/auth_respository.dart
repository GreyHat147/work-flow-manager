import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow_manager/models/member_model.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoaded extends AuthState {
  AuthLoaded({
    this.msgError = '',
    this.loggedIn = false,
    this.loggedOut = false,
    this.name = '',
    this.role = '',
  });

  final String msgError;
  final bool loggedIn;
  final bool loggedOut;
  final String name;
  final String role;
  @override
  List<Object?> get props => [
        msgError,
        loggedIn,
        loggedOut,
        name,
        role,
      ];
}

class AuthRepository extends Cubit<AuthState> {
  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required SharedPreferences sharedPreferences,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _sharedPreferences = sharedPreferences,
        _firestore = FirebaseFirestore.instance,
        super(AuthInitial());

  final FirebaseAuth _firebaseAuth;
  final SharedPreferences _sharedPreferences;
  final FirebaseFirestore _firestore;

  Future<void> checkLogin() async {
    final String? uid = _sharedPreferences.getString('uid');
    final String? role = _sharedPreferences.getString('role');
    if (uid != null && role != null) {
      final MemberModel member = await getMember(uid);
      emit(
        AuthLoaded(
          loggedIn: true,
          name: member.name,
          role: member.memberType,
        ),
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoaded(msgError: ''));
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        final MemberModel member = await getMember(user.uid);
        await _sharedPreferences.setString('uid', user.uid);
        await _sharedPreferences.setString('id', member.id!);
        await _sharedPreferences.setString('role', member.memberType);
        emit(
          AuthLoaded(
            loggedIn: true,
            name: member.name,
            role: member.memberType,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(AuthLoaded(msgError: 'El usuario no existe'));
          break;
        case 'wrong-password':
          emit(AuthLoaded(msgError: 'Contraseña incorrecta'));
          break;
        default:
          emit(AuthLoaded(msgError: 'Error desconocido'));
      }
    }
  }

  Future<MemberModel> getMember(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> member = await _firestore
        .collection('members')
        .where('userUid', isEqualTo: uid)
        .get()
        .then((value) {
      return value.docs.first;
    });
    return MemberModel.fromJson(member.data()!);
  }

  Future<User> getCurrenUser() async {
    return _firebaseAuth.currentUser!;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _sharedPreferences.clear();
    emit(AuthLoaded(loggedOut: true));
  }
}
