import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/cubits/board_cubit.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/states/board_state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BoardCubit>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    final state = cubit.state;
    Widget body = Container();
    if (state is EmptyBoardState) {
      body = const Center(
        key: Key('EmptyState'),
        child: Text('Adicione uma nova Task'),
      );
    }

    if (state is GettedTasksBoardState) {
      final tasks = state.tasks;
      body = ListView.builder(
          key: const Key('GettedState'),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return CheckboxListTile(
              value: task.check,
              onChanged: (value) {
                cubit.checkTask(task);
              },
              title: Text(task.description),
            );
          });
    }

    if (state is FailureBoardState) {
      body = const Center(
        key: Key('FailureState'),
        child: Text('Falha ao pegas as tasks'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void addTaskDialog() {
    var description = '';
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog.adaptive(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Sair')),
              TextButton(
                  onPressed: () {
                    context.read<BoardCubit>().addTask(Task(id: -1, description: description));
                    Navigator.pop(context);
                  },
                  child: const Text('Criar')),
            ],
            title: const Text('Adicionar nova Task'),
            content: TextField(
              onChanged: (value) {
                description = value;
              },
            ),
          );
        });
  }
}
