import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repository/board_repository.dart';
import 'package:todo/src/states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) {
      return;
    }
    tasks.add(newTask);

    await emmitTasks(tasks);
  }

  Future<void> removeTask(Task task) async {
    final tasks = _getTasks();
    if (tasks == null) {
      return;
    }
    tasks.remove(task);
    await emmitTasks(tasks);
  }

  Future<void> checkTask(Task task) async {
    final tasks = _getTasks();
    if (tasks == null) {
      return;
    }
    final index = tasks.indexOf(task);
    tasks[index] = task.copyWith(check: !task.check);
    await emmitTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTasksBoardState(tasks: tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return null;
    }
    final tasks = state.tasks.toList();
    return tasks;
  }

  Future emmitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }
}
