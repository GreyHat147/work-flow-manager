import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:work_flow_manager/repository/members/member_repository.dart';
import 'package:work_flow_manager/repository/projects/projects_repository.dart';
import 'package:work_flow_manager/repository/tasks/tasks_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerFactory<ProjectsRepository>(
    () => ProjectsRepository(getIt()),
  );

  getIt.registerFactory<MemberRepository>(
    () => MemberRepository(getIt(), getIt()),
  );

  getIt.registerFactory<TasksRepository>(
    () => TasksRepository(getIt()),
  );
}
