import 'package:equatable/equatable.dart';
import 'package:work_flow_manager/models/member_model.dart';

abstract class TasksState extends Equatable {}

class TasksInitialState extends TasksState {
  @override
  List<Object> get props => [];
}

class TasksLoadingState extends TasksState {
  @override
  List<Object> get props => [];
}

class TasksLoadedState extends TasksState {
  final List<MemberModel> members;
  final bool wasTaskCreated;

  TasksLoadedState({
    this.members = const [],
    this.wasTaskCreated = false,
  });

  @override
  List<Object> get props => [members];
}
