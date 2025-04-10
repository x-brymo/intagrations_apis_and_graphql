// models/note.dart
import 'package:hive/hive.dart';

part 'note.g.dart'; // This will be generated with 'flutter packages pub run build_runner build'

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String content;
  
  @HiveField(3)
  final DateTime createdAt;
  
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
  
  Note copyWith({
    String? title,
    String? content,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
    );
  }
}