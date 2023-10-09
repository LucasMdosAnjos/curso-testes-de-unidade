import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/src/cubits/board_cubit.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repository/board_repository.dart';
import 'package:todo/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository;
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });
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
            isA<GettedTasksBoardState>(),
          ]));

      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);

      await cubit.removeTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 0);
      expect(state.tasks, []);
    });

    test('deve retornar um estado de erro ao remover uma task', () async {
      when(() => repository.update(any())).thenThrow((_) => Exception('Error'));
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);
      expect(cubit.stream, emitsInOrder([isA<FailureBoardState>()]));

      await cubit.removeTask(task);
    });
  });

  group('checkTask |', () {
    test('deve checar uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);
      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTasksBoardState>(),
          ]));

      await cubit.checkTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.first.check, true);
    });

    test('deve retornar um estado de erro ao checar uma task', () async {
      when(() => repository.update(any())).thenThrow((_) => Exception('Error'));
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);
      expect(cubit.stream, emitsInOrder([isA<FailureBoardState>()]));

      await cubit.checkTask(task);
    });
  });
}
