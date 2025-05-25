import 'package:flutter/material.dart';
import 'package:to_do_app/data_source/local_data_source.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/presentation/base_cubit.dart';
import 'package:to_do_app/presentation/main_cubit/state.dart';

class MainCubit extends BaseCubit<BaseState> {
  MainCubit(
    this._localDataSource,
  ) : super(const BaseState());
  final LocalDataSource _localDataSource;

  void login(String login, String password) async {
    final user = await _localDataSource.getUser();
    if (user?.login == login && user?.password == password) {
      emit(state.copyWith(
        isSuccessLogin: true,
      ));
    } else if (user?.login != login) {
      _localDataSource
          .saveUserData(UserModel(login: login, password: password));
      emit(state.copyWith(
        isSuccessLogin: true,
      ));
    } else if (user?.login == login && user?.password != password) {
      emit(state.copyWith(
        isSuccessLogin: false,
      ));
    }
  }

  void logout() {
    _localDataSource.clearUserData();
  }

  void getTasks() async {
    final tasks = _localDataSource.userModel.tasks;
    emit(state.copyWith(tasks: tasks));
  }

  void addNote(String title, String task) {
    final newTask = TaskModel(title: title, description: task);
    final updatedTasks = List<TaskModel>.from(state.tasks)..add(newTask);
    _localDataSource.saveTaskData(updatedTasks);
    emit(state.copyWith(tasks: updatedTasks));
  }

  void deleteNote() {
    final updatedTasks = List<TaskModel>.from(state.tasks)
      ..remove(state.currentTask);
    _localDataSource.saveTaskData(updatedTasks);
    emit(state.copyWith(
        tasks: updatedTasks,
        currentTask: const TaskModel(title: '', description: '')));
  }

  void selectTask(TaskModel task) {
    emit(state.copyWith(currentTask: task));
  }

  @override
  void handleError(String errorMessage) {
    debugPrint('Error: $errorMessage');
  }
}
