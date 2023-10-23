import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/member/create_member_view.dart';
import 'package:work_flow_manager/view/project/create_project_view.dart';
import 'package:work_flow_manager/view/project/detail_project_view.dart';
import 'package:work_flow_manager/view/project/projects_view.dart';
import 'package:work_flow_manager/view/view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const WorkFlowManagerApp()));
}

class WorkFlowManagerApp extends StatelessWidget {
  const WorkFlowManagerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Flow Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: DetailProjectView(),
    );
  }
}
