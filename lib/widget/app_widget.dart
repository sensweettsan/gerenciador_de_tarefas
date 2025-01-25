import 'package:flutter/material.dart';
import '../presentation/pages/task_manager_home.dart';

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskManagerHome(),
    );
  }
}
