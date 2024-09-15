// task_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:tasks_manager_forcen/api/services/database_helper_service.dart';
import '../repository/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<FetchTasks>(_onFetchTasks);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is UpdateTask) {
      yield TaskLoading();
      try {
        // Appelez la méthode de mise à jour de votre repository
        final updatedTask = await taskRepository.updateTask(event.task);
        yield TaskUpdated(updatedTask);
      } catch (e) {
        yield TaskError(message: e.toString());
      }
    }
  }

  /*TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<FetchTasks>(_onFetchTasks);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }*/

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.createTask(event.task);
      final tasks = await taskRepository.fetchTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  void _onFetchTasks(FetchTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.updateTask(event.task);
      final tasks = await taskRepository.fetchTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.deleteTask(event.taskId);
      final tasks = await taskRepository.fetchTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
