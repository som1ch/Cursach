import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/presentation/main_cubit/cubit.dart';
import 'package:to_do_app/presentation/main_cubit/state.dart';
import 'package:to_do_app/ui/pages/task_detail/screen/task_detail_screen.dart';
import 'package:to_do_app/services/notification_service.dart'; // Додай сервіс

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.cubit});

  static const String routeName = '/main';
  final MainCubit cubit;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  TimeOfDay? selectedTime;

  void _pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit..getTasks(),
      child: BlocBuilder<MainCubit, BaseState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Мої нагадування'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    widget.cubit.logout();
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
                    widget.cubit.selectTask(task);
                    context.go(TaskDetailScreen.routeName);
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Додайте нотатку'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: firstController,
                              decoration: const InputDecoration(
                                labelText: 'Назва',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: secondController,
                              decoration: const InputDecoration(
                                labelText: 'Нотатки',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              selectedTime != null
                                  ? 'Обраний час: ${selectedTime!.format(context)}'
                                  : 'Час не вибрано',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _pickTime,
                              child: const Text('Вибрати час'),
                            ),
                          ],
                        ),
                      ),
                      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      actions: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Скасувати'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  final firstText = firstController.text;
                                  final secondText = secondController.text;
                                  widget.cubit.addNote(firstText, secondText);

                                  // Додано планування сповіщення
                                  if (selectedTime != null) {
                                    final now = DateTime.now();
                                    final scheduledTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      selectedTime!.hour,
                                      selectedTime!.minute,
                                    );

                                    if (scheduledTime.isAfter(now)) {
                                      NotificationService.scheduleNotification(
                                        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                                        title: firstText,
                                        body: secondText,
                                        scheduledTime: scheduledTime,
                                      );
                                    }
                                  }

                                  firstController.clear();
                                  secondController.clear();
                                  setState(() {
                                    selectedTime = null;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Підтвердити'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
