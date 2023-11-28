import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow_manager/repository/auth/auth_respository.dart';
import 'package:work_flow_manager/repository/members/member_repository.dart';
import 'package:work_flow_manager/repository/projects/projects_repository.dart';
import 'package:work_flow_manager/repository/record/record_repository.dart';
import 'package:work_flow_manager/repository/reports/reports_repository.dart';
import 'package:work_flow_manager/repository/tasks/tasks_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  await getIt.isReady<SharedPreferences>();
  getIt.registerFactory<ProjectsRepository>(
    () => ProjectsRepository(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerFactory<MemberRepository>(
    () => MemberRepository(getIt(), getIt()),
  );

  await getIt.isReady<SharedPreferences>();
  getIt.registerFactory<TasksRepository>(
    () => TasksRepository(getIt(), getIt()),
  );

  getIt.registerFactory<RecordRepository>(
    () => RecordRepository(
      getIt(),
      getIt(),
    ),
  );

  await getIt.isReady<SharedPreferences>();
  getIt.registerFactory<AuthRepository>(
    () => AuthRepository(
      firebaseAuth: getIt(),
      sharedPreferences: getIt(),
      firestore: getIt(),
    ),
  );

  getIt.registerFactory<ReportsRepository>(
    () => ReportsRepository(
      getIt(),
    ),
  );
}
