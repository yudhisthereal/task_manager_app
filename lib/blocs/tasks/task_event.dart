// Events
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/data/models/task.dart';

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