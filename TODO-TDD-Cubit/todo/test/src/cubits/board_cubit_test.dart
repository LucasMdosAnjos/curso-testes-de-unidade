import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/src/cubits/board_cubit.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repository/board_repository.dart';
import 'package:todo/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  final repository = BoardRepositoryMock();
  final cubit = BoardCubit(repository);
  tearDown(() => reset(repository));
  group('fetch tasks |', () {
    test('deve pegar todas as tasks', () async {
      when(() => repository.fetch()).thenAnswer((_) async => [
            const Task(id: 1, description: '', check: false),
          ]);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<LoadingBoardState>(),
            isA<GettedTasksBoardState>(),
          ]));

      await cubit.fetchTasks();
    });

    test('deve retornar um estado de erro ao falhar', () async {
      when(() => repository.fetch()).thenThrow((_) async => Exception('Error'));

      expect(cubit.stream,
          emitsInOrder([isA<LoadingBoardState>(), isA<FailureBoardState>()]));
      await cubit.fetchTasks();
    });
  });

  group('addTask |', () {
    test('deve adicionar uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTasksBoardState>(),
          ]));

      const task = Task(id: 1, description: '');
      await cubit.addTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    test('deve retornar um estado de erro ao adicionar uma task', () async {
      when(() => repository.update(any())).thenThrow((_) => Exception('Error'));

      expect(cubit.stream, emitsInOrder([isA<FailureBoardState>()]));
      const task = Task(id: 1, description: '');
      await cubit.addTask(task);
    });
  });

  group('removeTask |', () {
    test('deve remover uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTasksBoardState>(),
          ]));

      const task = Task(id: 1, description: '');
      await cubit.removeTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 0);
      expect(state.tasks, []);
    });

    test('deve retornar um estado de erro ao remover uma task', () async {
      when(() => repository.update(any())).thenThrow((_) => Exception('Error'));

      expect(cubit.stream, emitsInOrder([isA<FailureBoardState>()]));
      const task = Task(id: 1, description: '');
      await cubit.removeTask(task);
    });
  });
}
