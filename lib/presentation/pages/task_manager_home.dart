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
    setState(() {
      tasksFuture = TaskDatabase.instance.readAllTasks();
    });
  }

  Future<void> addTask(String title, DateTime? deadline) async {
    await TaskDatabase.instance.create(Task(title: title, deadline: deadline));
    refreshTasks();
  }

  Future<void> editTask(Task task, String newTitle, String newStatus,
      DateTime? newDeadline) async {
    await TaskDatabase.instance.update(Task(
        id: task.id,
        title: newTitle,
        status: newStatus,
        deadline: newDeadline));
    refreshTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.delete(id);
    refreshTasks();
  }

  void showAddTaskDialog() {
    final TextEditingController taskController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Nova Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(hintText: 'Título da tarefa'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Text(selectedDate == null
                    ? 'Selecionar Data de Conclusão'
                    : DateFormat('dd/MM/yyyy').format(selectedDate!)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  addTask(taskController.text, selectedDate);
                }
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddTaskDialog,
          ),
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
                onChanged: () => editTask(
                    task,
                    task.title,
                    task.status == 'Concluído' ? 'Pendente' : 'Concluído',
                    task.deadline),
              );
            },
          );
        },
      ),
    );
  }
}
