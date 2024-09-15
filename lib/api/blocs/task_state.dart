// lib/blocs/task_state.dart

import 'package:equatable/equatable.dart';
import 'package:tasks_manager_forcen/api/models/task_model.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {

}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  TaskLoaded({required this.tasks});
  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;
  TaskError({required this.message});
  @override
  List<Object?> get props => [message];
}

class TaskUpdated extends TaskState {
  final TaskModel updatedTask;
  TaskUpdated(this.updatedTask);

  @override
  List<Object?> get props => [updatedTask];
}
