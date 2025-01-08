import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/tasks/task_bloc.dart';
import 'package:task_manager_app/data/local/shared_prefs_helper.dart';
import 'package:task_manager_app/data/models/task.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _isCompleted = widget.task!.isCompleted;
    }
  }

  Future<void> _loadUserId() async {
    final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final userId = await sharedPrefsHelper.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Completed'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value ?? false;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User ID not loaded yet')),
                  );
                  return;
                }

                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();

                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty')),
                  );
                  return;
                }

                final task = Task(
                  id: isEditing ? widget.task?.id : null,
                  userId: _userId!,
                  title: title,
                  description: description.isEmpty ? null : description,
                  isCompleted: _isCompleted,
                );

                context.read<TaskBloc>().add(
                      isEditing ? UpdateTaskEvent(task) : AddTaskEvent(task),
                    );

                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Update Task' : 'Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
