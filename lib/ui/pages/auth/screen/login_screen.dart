import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/presentation/main_cubit/cubit.dart';
import 'package:to_do_app/presentation/main_cubit/state.dart';
import 'package:to_do_app/ui/pages/main_screen/screen/main_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainCubit, BaseState>(
      listener: (context, state) {
        if (state.isSuccessLogin) {
          context.go(MainScreen.routeName);
        } else if (state.loginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('error'),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Text('Login Screen'),
              const Spacer(),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    context.read<MainCubit>().login(
                          emailController.text,
                          passwordController.text,
                        );
                  }
                },
                child: const Text('Login'),
              ),
              const Spacer(),
            ],
          ),
        )),
      ),
    );
  }
}
