import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/data/local/shared_prefs_helper.dart';
import 'package:task_manager_app/data/models/task.dart';
import 'package:task_manager_app/data/repositories/task_repository.dart';

// Events
abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class RemoveTaskEvent extends TaskEvent {
  final int id;
  final int userId;

  RemoveTaskEvent(this.id, this.userId);

  @override
  List<Object?> get props => [id, userId];
}

// States
class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String error;

  TaskError(this.error);

  @override
  List<Object?> get props => [error];
}

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
