import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repository/isar/isar_board_repository.dart';
import 'package:todo/src/repository/isar/isar_datasource.dart';
import 'package:todo/src/repository/isar/task_model.dart';

class IsarDatasourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarBoardRepository repository;
  late IsarDatasourceMock datasource;

  setUp(() {
    datasource = IsarDatasourceMock();
    repository = IsarBoardRepository(datasource);
  });
  test('fetch', () async {
    when(() => datasource.getTasks()).thenAnswer((invocation) async => [
          TaskModel()..id = 1,
        ]);
    final tasks = await repository.fetch();

    expect(tasks.length, 1);
  });

  test('update', () async {
    when(() => datasource.deleteAllTasks())
        .thenAnswer((invocation) async => []);
    when(() => datasource.putAllTasks(any()))
        .thenAnswer((invocation) async => []);

    final tasks = await repository.update([
      const Task(id: -1, description: ''),
      const Task(id: 2, description: ''),
    ]);

    expect(tasks.length, 2);
  });
}
