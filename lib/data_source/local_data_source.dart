import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';

class LocalDataSource {
  UserModel userModel = UserModel(login: '', password: '');

  void saveUserData(UserModel model) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('user', jsonEncode(model.toJson()));
    userModel = model;
  }

  Future<UserModel?> getUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final res = _prefs.getString('user');

    if (res == null) {
      return null;
    }
    final Map<String, dynamic> json = jsonDecode(res);

    userModel = UserModel.fromJson(json);
    return UserModel.fromJson(json);
  }

  void clearUserData() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove('user');
    userModel = UserModel(login: '', password: '');
  }

  void saveTaskData(List<TaskModel> taskModel) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    final String value = jsonEncode(taskModel.map((e) => e.toJson()).toList());
    userModel.tasks = taskModel;
    await _prefs.setString('user', jsonEncode(userModel.toJson()));
  }

  void clearTaskData(TaskModel model) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String key = model.title;
    await _prefs.remove(key);
  }
}
