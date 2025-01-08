import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/auth/auth_bloc.dart';
import 'package:task_manager_app/blocs/auth/auth_event.dart'
  show LogoutEvent;
import 'package:task_manager_app/blocs/tasks/task_bloc.dart';
import 'package:task_manager_app/data/models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  bool _showDeleteButtons = false; // State to control the visibility of delete buttons

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(FetchTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showDeleteButtons = !_showDeleteButtons; // Toggle the delete button visibility
              });
            },
            icon: Icon(
              _showDeleteButtons ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          IconButton(
            onPressed: () async {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;

            if (tasks.isEmpty) {
              return const Center(
                child: Text('No tasks found. Add a new task!'),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Text(
                    '${index + 1}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.description ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          context.read<TaskBloc>().add(UpdateTaskEvent(
                                task.copyWith(isCompleted: value ?? false),
                              ));
                        },
                      ),
                      if (_showDeleteButtons) // Conditionally render delete button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, task);
                          },
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/add-edit-task',
                      arguments: task,
                    );
                  },
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.error));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-edit-task');
        },
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskBloc>().add(RemoveTaskEvent(task.id!, task.userId));
                Navigator.pop(ctx); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
