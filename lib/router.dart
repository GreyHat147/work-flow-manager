import 'package:flutter/material.dart';
import 'package:work_flow_manager/view/home_view.dart';
import 'package:work_flow_manager/view/member/create_member_view.dart';
import 'package:work_flow_manager/view/project/create_project_view.dart';
import 'package:work_flow_manager/view/task/create_task_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
/*     case '/projectDetails':
      return _getPageRoute(const DetailProjectView(), settings); */
    case '/createProject':
      return _getPageRoute(const CreateProjectView(), settings);
    case '/addMember':
      return _getPageRoute(const CreateMemberView(), settings);
    case '/addTask':
      return _getPageRoute(CreateTaskView(), settings);
    default:
      return _getPageRoute(HomeView(title: ''), settings);
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
