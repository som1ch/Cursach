import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/data_source/local_data_source.dart';
import 'package:to_do_app/presentation/main_cubit/cubit.dart';
import 'package:to_do_app/ui/navigation/path_consts.dart';
import 'package:to_do_app/ui/pages/auth/screen/login_screen.dart';
import 'package:to_do_app/ui/pages/main_screen/screen/main_screen.dart';
import 'package:to_do_app/ui/pages/task_detail/screen/task_detail_screen.dart';

final class NavigationService {
  NavigationService(this.authService);

  final LocalDataSource authService;

  GoRouter get router {
    final navigatorKey = GlobalKey<NavigatorState>();
    final cubit = MainCubit(authService);

    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: PathConsts.login,
      routes: <RouteBase>[
        GoRoute(
          path: PathConsts.login,
          builder: (context, state) {
            return BlocProvider.value(value: cubit, child: LoginScreen());
          },
          redirect: (context, state) async {
            if (await authService.getUser() != null) {
              return PathConsts.main;
            }
            return null;
          },
        ),
        GoRoute(
            path: PathConsts.main,
            builder: (context, state) {
              return MainScreen(cubit: cubit);
            },
            routes: [
              GoRoute(
                  path: PathConsts.taskDeatil,
                  builder: (context, state) {
                    return BlocProvider.value(
                      value: cubit,
                      child: const TaskDetailScreen(),
                    );
                  }),
            ]),
      ],
    );
  }
}
