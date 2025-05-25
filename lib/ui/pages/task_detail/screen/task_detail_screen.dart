import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/presentation/main_cubit/cubit.dart';
import 'package:to_do_app/presentation/main_cubit/state.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});
  static const routeName = '/main/task_detail';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, BaseState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Деталі завдання'),
          ),
          body: Center(
              child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                state.currentTask.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                state.currentTask.description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Task List'),
              ),
              const SizedBox(height: 50),
            ],
          )),
        );
      },
    );
  }
}
