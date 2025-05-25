import 'package:flutter/material.dart';
import 'package:to_do_app/data_source/local_data_source.dart';
import 'package:to_do_app/ui/navigation/navigator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final LocalDataSource localDataSource = LocalDataSource();

  late final NavigationService navigationService;

  @override
  void initState() {
    super.initState();
    navigationService = NavigationService(localDataSource);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: navigationService.router,
    );
  }
}
