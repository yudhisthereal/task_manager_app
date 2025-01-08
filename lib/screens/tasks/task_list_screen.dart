import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/tasks/task_bloc.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger FetchTasksEvent when the screen is created
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
              Navigator.pushNamed(context, '/add-edit-task');
            },
            icon: const Icon(Icons.add),
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
                  title: Text(task.title),
                  subtitle: Text(task.description ?? ''),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      context.read<TaskBloc>().add(UpdateTaskEvent(
                            task.copyWith(isCompleted: value ?? false),
                          ));
                    },
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
    );
  }
}
