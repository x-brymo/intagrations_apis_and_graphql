// screens/hive_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/export.dart';
import '../../domain/manager/export.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({Key? key}) : super(key: key);

  @override
  _HiveScreenState createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Note? _editingNote;

  @override
  void initState() {
    super.initState();
    context.read<HiveBloc>().add(LoadNotes());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _titleController.clear();
    _contentController.clear();
    _editingNote = null;
  }

  void _prepareForEdit(Note note) {
    _titleController.text = note.title;
    _contentController.text = note.content;
    _editingNote = note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
      ),
      body: BlocConsumer<HiveBloc, HiveState>(
        listener: (context, state) {
          if (state is HiveErrors) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is HiveLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HiveLoaded) {
            return _buildContent(context, state.notes);
          } else {
            return const Center(child: Text('No notes yet'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildNoteDialog(context),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Note> notes) {
    if (notes.isEmpty) {
      return const Center(
        child: Text(
          'No notes yet. Tap + to add one.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(
              note.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _prepareForEdit(note);
                    showDialog(
                      context: context,
                      builder: (context) => _buildNoteDialog(context),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<HiveBloc>().add(DeleteNote(note: note));
                  },
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(note.title),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(note.content),
                        const SizedBox(height: 16),
                        Text(
                          'Created: ${note.createdAt.toString().substring(0, 16)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNoteDialog(BuildContext context) {
    final isEditing = _editingNote != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Note' : 'Add Note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _clearControllers();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all fields')),
              );
              return;
            }
            
            if (isEditing) {
              context.read<HiveBloc>().add(
                UpdateNote(
                  note: _editingNote!,
                  title: _titleController.text,
                  content: _contentController.text,
                ),
              );
            } else {
              context.read<HiveBloc>().add(
                AddNote(
                  title: _titleController.text,
                  content: _contentController.text,
                ),
              );
            }
            
            Navigator.pop(context);
            _clearControllers();
          },
          child: Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}