// BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/note.dart';
import '../export.dart';

class HiveBloc extends Bloc<HiveEvent, HiveState> {
  final Box<Note> notesBox = Hive.box<Note>('notes');
  
  HiveBloc() : super(HiveInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  void _onLoadNotes(LoadNotes event, Emitter<HiveState> emit) {
    emit(HiveLoading());
    try {
      final notes = notesBox.values.toList();
      emit(HiveLoaded(notes: notes));
    } catch (e) {
      emit(HiveErrors(message: 'Failed to load notes: $e'));
    }
  }

  void _onAddNote(AddNote event, Emitter<HiveState> emit) {
    emit(HiveLoading());
    try {
      final note = Note(
        id: const Uuid().v4(),
        title: event.title,
        content: event.content,
        createdAt: DateTime.now(),
      );
      notesBox.put(note.id, note);
      final notes = notesBox.values.toList();
      emit(HiveLoaded(notes: notes));
    } catch (e) {
      emit(HiveErrors( message: 'Failed to add note: $e'));
    }
  }

  void _onUpdateNote(UpdateNote event, Emitter<HiveState> emit) {
    emit(HiveLoading());
    try {
      final updatedNote = event.note.copyWith(
        title: event.title,
        content: event.content,
      );
      notesBox.put(updatedNote.id, updatedNote);
      final notes = notesBox.values.toList();
      emit(HiveLoaded(notes: notes));
    } catch (e) {
      emit(HiveErrors(message: 'Failed to update note: $e'));
    }
  }

  void _onDeleteNote(DeleteNote event, Emitter<HiveState> emit) {
    emit(HiveLoading());
    try {
      notesBox.delete(event.note.id);
      final notes = notesBox.values.toList();
      emit(HiveLoaded(notes: notes));
    } catch (e) {
      emit(HiveErrors(message: 'Failed to delete note: $e'));
    }
  }
}