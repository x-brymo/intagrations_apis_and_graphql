// screens/sqflite_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/export.dart';
import '../../domain/manager/export.dart';

class SqfliteScreen extends StatefulWidget {
  const SqfliteScreen({super.key});

  @override
  _SqfliteScreenState createState() => _SqfliteScreenState();
}

class _SqfliteScreenState extends State<SqfliteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Task? _editingTask;

  @override
  void initState() {
    super.initState();
    context.read<SqfliteBloc>().add(LoadTasks());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _titleController.clear();
    _descriptionController.clear();
    _editingTask = null;
  }

  void _prepareForEdit(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _editingTask = task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Database'),
      ),
      body: BlocConsumer<SqfliteBloc, SqfliteState>(
        listener: (context, state) {
          if (state is SqfliteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SqfliteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SqfliteLoaded) {
            return _buildContent(context, state.tasks);
          } else {
            return const Center(child: Text('No tasks yet'));
          }
        },
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildTaskDialog(context),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks yet. Tap + to add one.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) {
                context.read<SqfliteBloc>().add(ToggleTask(task: task));
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _prepareForEdit(task);
                    showDialog(
                      context: context,
                      builder: (context) => _buildTaskDialog(context),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<SqfliteBloc>().add(DeleteTask(task: task));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskDialog(BuildContext context) {
    final isEditing = _editingTask != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'Add Task'),
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
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
            if (_titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a title')),
              );
              return;
            }
            
            if (isEditing) {
              context.read<SqfliteBloc>().add(
                UpdateTask(
                  task: _editingTask!,
                  title: _titleController.text,
                  description: _descriptionController.text,
                ),
              );
            } else {
              context.read<SqfliteBloc>().add(
                AddTask(
                  title: _titleController.text,
                  description: _descriptionController.text,
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