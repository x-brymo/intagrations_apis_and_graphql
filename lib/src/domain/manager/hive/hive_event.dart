// Events
import '../../../data/export.dart';

abstract class HiveEvent {}

class LoadNotes extends HiveEvent {}

class AddNote extends HiveEvent {
  final String title;
  final String content;

  AddNote({required this.title, required this.content});
}

class UpdateNote extends HiveEvent {
  final Note note;
  final String title;
  final String content;

  UpdateNote({
    required this.note,
    required this.title,
    required this.content,
  });
}

class DeleteNote extends HiveEvent {
  final Note note;

  DeleteNote({required this.note});
}