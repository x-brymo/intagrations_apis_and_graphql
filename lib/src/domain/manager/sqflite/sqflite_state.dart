// States
import '../../../data/export.dart';

abstract class SqfliteState {}

class SqfliteInitial extends SqfliteState {}

class SqfliteLoading extends SqfliteState {}

class SqfliteLoaded extends SqfliteState {
  final List<Task> tasks;

  SqfliteLoaded({required this.tasks});
}

class SqfliteError extends SqfliteState {
  final String message;

  SqfliteError({required this.message});
}