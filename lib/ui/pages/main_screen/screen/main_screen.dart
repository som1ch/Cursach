import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/presentation/main_cubit/cubit.dart';
import 'package:to_do_app/presentation/main_cubit/state.dart';
import 'package:to_do_app/ui/pages/task_detail/screen/task_detail_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key, required this.cubit});
  static const String routeName = '/main';
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final MainCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit..getTasks(),
      child: BlocBuilder<MainCubit, BaseState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Список завдань'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    cubit.logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
            body: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return ListTile(
                    title: Column(
                      children: [
                        Text(task.title),
                        const SizedBox(height: 8),
                        Text(task.description),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ],
                    ),
                    onTap: () {
                      cubit.selectTask(task);
                      context.go(TaskDetailScreen.routeName);
                    },
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Введіть дані'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: firstController,
                              decoration: const InputDecoration(
                                labelText: 'Перше поле',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: secondController,
                              decoration: const InputDecoration(
                                labelText: 'Друге поле',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // закрити діалог
                            },
                            child: const Text('Скасувати'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final firstText = firstController.text;
                              final secondText = secondController.text;
                              cubit.addNote(firstText, secondText);
                              firstController.clear();
                              secondController.clear();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Підтвердити'),
                          ),
                        ],
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
