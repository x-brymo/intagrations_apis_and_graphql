// BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/export.dart';
import '../export.dart';

class SqfliteBloc extends Bloc<SqfliteEvent, SqfliteState> {
  Database? _database;
  
  SqfliteBloc() : super(SqfliteInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleTask>(_onToggleTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, isCompleted INTEGER)',
        );
      },
      version: 1,
    );
    add(LoadTasks());
  }

  void _onLoadTasks(LoadTasks event, Emitter<SqfliteState> emit) async {
    emit(SqfliteLoading());
    try {
      final List<Map<String, dynamic>> maps = await _database!.query('tasks');
      final tasks = List.generate(maps.length, (i) {
        return Task.fromMap(maps[i]);
      });
      emit(SqfliteLoaded(tasks: tasks));
    } catch (e) {
      emit(SqfliteError(message: 'Failed to load tasks: $e'));
    }
  }

  void _onAddTask(AddTask event, Emitter<SqfliteState> emit) async {
    emit(SqfliteLoading());
    try {
      final task = Task(
        title: event.title,
        description: event.description,
      );
      await _database!.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      add(LoadTasks());
    } catch (e) {
      emit(SqfliteError(message: 'Failed to add task: $e'));
    }
  }

  void _onToggleTask(ToggleTask event, Emitter<SqfliteState> emit) async {
    emit(SqfliteLoading());
    try {
      final updatedTask = Task(
        id: event.task.id,
        title: event.task.title,
        description: event.task.description,
        isCompleted: !event.task.isCompleted,
      );
      await _database!.update(
        'tasks',
        updatedTask.toMap(),
        where: 'id = ?',
        whereArgs: [updatedTask.id],
      );
      add(LoadTasks());
    } catch (e) {
      emit(SqfliteError(message: 'Failed to toggle task: $e'));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<SqfliteState> emit) async {
    emit(SqfliteLoading());
    try {
      final updatedTask = Task(
        id: event.task.id,
        title: event.title,
        description: event.description,
        isCompleted: event.task.isCompleted,
      );
      await _database!.update(
        'tasks',
        updatedTask.toMap(),
        where: 'id = ?',
        whereArgs: [updatedTask.id],
      );
      add(LoadTasks());
    } catch (e) {
      emit(SqfliteError(message: 'Failed to update task: $e'));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<SqfliteState> emit) async {
    emit(SqfliteLoading());
    try {
      await _database!.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [event.task.id],
      );
      add(LoadTasks());
    } catch (e) {
      emit(SqfliteError(message: 'Failed to delete task: $e'));
    }
  }
}