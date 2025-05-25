import 'package:equatable/equatable.dart';
import 'package:to_do_app/models/task_model.dart';

class BaseState extends Equatable {
  final bool isSuccessLogin;
  final bool loginError;
  final List<TaskModel> tasks;
  final TaskModel currentTask;

  const BaseState({
    this.isSuccessLogin = false,
    this.loginError = false,
    this.currentTask = const TaskModel(title: '', description: ''),
    this.tasks = const [],
  });

  BaseState copyWith({
    bool? isSuccessLogin,
    List<TaskModel>? tasks,
    TaskModel? currentTask,
    bool? loginError,
  }) {
    return BaseState(
      isSuccessLogin: isSuccessLogin ?? this.isSuccessLogin,
      tasks: tasks ?? this.tasks,
      currentTask: currentTask ?? this.currentTask,
      loginError: loginError ?? this.loginError,
    );
  }

  @override
  List<Object?> get props => [
        isSuccessLogin,
        tasks,
        currentTask,
        loginError,
      ];
}
