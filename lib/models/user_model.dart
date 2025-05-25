import 'package:json_annotation/json_annotation.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/presentation/main_cubit/state.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String login;
  final String password;
  List<TaskModel> tasks;

  UserModel({
    required this.login,
    required this.password,
    this.tasks = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel.fromState(BaseState state, this.tasks)
      : login = state.currentTask.title,
        password = state.currentTask.description;
}
