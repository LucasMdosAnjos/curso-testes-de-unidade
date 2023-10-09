import 'package:bloc/bloc.dart';
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
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return;
    }

    final tasks = state.tasks.toList();
    tasks.add(newTask);

    try {
      await repository.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> removeTask(Task task) async {
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    tasks.remove(task);
    try {
      await repository.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> checkTask(Task task) async {}
}
