import 'package:flutter/material.dart';
import 'package:gerenciador_de_tarefas/models/taks_model.dart';
import 'package:gerenciador_de_tarefas/presentation/pages/task_item_widget.dart';

import '../../core/task_database.dart';

class TaskManagerHome extends StatefulWidget {
  @override
  _TaskManagerHomeState createState() => _TaskManagerHomeState();
}

class _TaskManagerHomeState extends State<TaskManagerHome> {
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    refreshTasks();
  }

  void refreshTasks() {
    tasksFuture = TaskDatabase.instance.readAllTasks();
  }

  Future<void> addTask(String title) async {
    await TaskDatabase.instance.create(Task(title: title));
    refreshTasks();
  }

  Future<void> editTask(Task task, String newTitle, String newStatus) async {
    await TaskDatabase.instance
        .update(Task(id: task.id, title: newTitle, status: newStatus));
    refreshTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.delete(id);
    refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Adicionar lógica de cadastrar tarefa
            },
          )
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma tarefa encontrada.'));
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItem(
                task: task,
                onChanged: () => editTask(task, task.title,
                    task.status == 'Concluído' ? 'Pendente' : 'Concluído'),
              );
            },
          );
        },
      ),
    );
  }
}
