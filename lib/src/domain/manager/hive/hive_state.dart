// States
import '../../../data/models/note.dart';

abstract class HiveState {}

class HiveInitial extends HiveState {}

class HiveLoading extends HiveState {}

class HiveLoaded extends HiveState {
  final List<Note> notes;

  HiveLoaded({required this.notes});
}

class HiveErrors extends HiveState {
  final String message;

  HiveErrors({required this.message});
}
