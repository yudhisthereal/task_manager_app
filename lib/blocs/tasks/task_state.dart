// States
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/data/models/task.dart';

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