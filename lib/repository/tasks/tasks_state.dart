import 'package:equatable/equatable.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/task_model.dart';

abstract class TasksState extends Equatable {}

class TasksInitialState extends TasksState {
  @override
  List<Object> get props => [];
}

class TasksLoadingState extends TasksState {
  @override
  List<Object> get props => [];
}

class TasksByUsersState extends TasksState {
  final List<TaskModel> tasks;

  TasksByUsersState({
    this.tasks = const [],
  });

  @override
  List<Object> get props => [tasks];
}

class TasksLoadedState extends TasksState {
  final List<MemberModel> members;
  final bool wasTaskCreated;
  final List<TaskModel> tasks;

  TasksLoadedState({
    this.members = const [],
    this.wasTaskCreated = false,
    this.tasks = const [],
  });

  @override
  List<Object> get props => [members];
}
