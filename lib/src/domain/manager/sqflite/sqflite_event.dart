// Events
import '../../../data/export.dart';

abstract class SqfliteEvent {}

class LoadTasks extends SqfliteEvent {}

class AddTask extends SqfliteEvent {
  final String title;
  final String description;

  AddTask({required this.title, required this.description});
}

class ToggleTask extends SqfliteEvent {
  final Task task;

  ToggleTask({required this.task});
}

class UpdateTask extends SqfliteEvent {
  final Task task;
  final String title;
  final String description;

  UpdateTask({
    required this.task,
    required this.title,
    required this.description,
  });
}

class DeleteTask extends SqfliteEvent {
  final Task task;

  DeleteTask({required this.task});
}