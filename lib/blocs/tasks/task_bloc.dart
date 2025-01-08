import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/tasks/task_event.dart';
import 'package:task_manager_app/blocs/tasks/task_state.dart';
import 'package:task_manager_app/data/local/shared_prefs_helper.dart';
import 'package:task_manager_app/data/repositories/task_repository.dart';


// Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(TaskInitial()) {
    on<FetchTasksEvent>(_onFetchTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<RemoveTaskEvent>(_onRemoveTask);
  }

  void _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
    final int? userId = await sharedPrefsHelper.getUserId();

    if (userId != null) {
      try {
      final tasks = await taskRepository.fetchUserTasks(userId);
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to fetch tasks'));
        debugPrint('[FETCH TASK ERROR]: $e');
      }
    } else {
      emit(TaskError('No logged-in user'));
    }
  }

  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.addTask(event.task);
      add(FetchTasksEvent());
    } catch (e) {
      emit(TaskError('Failed to add task'));
      debugPrint('[ADD TASK ERROR]: $e');
    }
  }

  void _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(event.task);
      add(FetchTasksEvent());
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  void _onRemoveTask(RemoveTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.removeTask(event.id, event.userId);
      add(FetchTasksEvent());
    } catch (e) {
      emit(TaskError('Failed to delete task'));
    }
  }
}
