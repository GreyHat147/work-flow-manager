import 'package:equatable/equatable.dart';
import 'package:work_flow_manager/models/record_model.dart';

abstract class RecordState extends Equatable {}

class RecordInitialState extends RecordState {
  @override
  List<Object?> get props => [];
}

class RecordLoadingState extends RecordState {
  @override
  List<Object?> get props => [];
}

class RecordLoadedState extends RecordState {
  final bool recordCreated;
  final bool recordUpdated;
  final bool recordDeleted;
  final List<RecordModel> records;

  RecordLoadedState({
    this.recordCreated = false,
    this.records = const [],
    this.recordUpdated = false,
    this.recordDeleted = false,
  });

  @override
  List<Object?> get props => [
        recordCreated,
        records,
        recordUpdated,
        recordDeleted,
      ];
}

class RecordErrorState extends RecordState {
  final String message;

  RecordErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
