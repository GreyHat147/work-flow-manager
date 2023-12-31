import 'package:equatable/equatable.dart';

abstract class MemberState extends Equatable {}

class MemberInitialState extends MemberState {
  @override
  List<Object?> get props => [];
}

class MemberLoadingState extends MemberState {
  @override
  List<Object?> get props => [];
}

class MemberCreationState extends MemberState {
  final bool wasCreated;

  MemberCreationState({this.wasCreated = false});

  @override
  List<Object?> get props => [wasCreated];
}
