import 'package:flutter/material.dart';
import 'package:work_flow_manager/view/home_view.dart';
import 'package:work_flow_manager/view/login_view.dart';
import 'package:work_flow_manager/view/member/create_member_view.dart';
import 'package:work_flow_manager/view/project/create_project_view.dart';
import 'package:work_flow_manager/view/task/create_task_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/createProject':
      return _getPageRoute(const CreateProjectView(), settings);
    case '/addMember':
      return _getPageRoute(const CreateMemberView(), settings);
    case '/addTask':
      return _getPageRoute(const CreateTaskView(), settings);
    case '/home':
      return _getPageRoute(const HomeView(title: ''), settings);
    case '/login':
      return _getPageRoute(LoginView(), settings);
    default:
      return _getPageRoute(const HomeView(title: ''), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(
    child: child,
    routeName: settings.name!,
    arguments: settings.arguments,
  );
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  final Object? arguments;
  _FadeRoute({
    required this.child,
    required this.routeName,
    this.arguments,
  }) : super(
          settings: RouteSettings(name: routeName, arguments: arguments),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
