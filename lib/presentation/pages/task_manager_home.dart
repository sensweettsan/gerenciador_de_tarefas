import 'package:flutter/material.dart';
import 'package:gerenciador_de_tarefas/models/taks_model.dart';
import 'package:gerenciador_de_tarefas/presentation/task_calendar.dart';
import 'package:intl/intl.dart';
//import 'package:gerenciador_de_tarefas/presentation/pages/task_item_widget.dart';
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

  Future<void> addTask(String title, String description, DateTime? startDate,
      DateTime? deadline, String status) async {
    if (startDate != null && deadline != null && startDate.isAfter(deadline)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'A data de início não pode ser posterior à data de conclusão.')),
      );
      return;
    }

    await TaskDatabase.instance.create(Task(
      title: title,
      description: description,
      startDate: startDate,
      deadline: deadline,
      status: status,
    ));
    refreshTasks();
  }

  Future<void> editTask(Task task, String newTitle, String newDescription,
      DateTime? newStartDate, DateTime? newDeadline, String newStatus) async {
    if (newStartDate != null &&
        newDeadline != null &&
        newStartDate.isAfter(newDeadline)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'A data de início não pode ser posterior à data de conclusão.')),
      );
      return;
    }

    await TaskDatabase.instance.update(Task(
      id: task.id,
      title: newTitle,
      description: newDescription,
      startDate: newStartDate,
      deadline: newDeadline,
      status: newStatus,
    ));
    refreshTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.delete(id);
    refreshTasks();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa deletada com sucesso!')),
    );
  }

  void showAddTaskDialog() {
    final TextEditingController taskController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? startDate;
    DateTime? deadline;
    String status = 'Pendente';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Nova Tarefa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration:
                      const InputDecoration(hintText: 'Título da tarefa'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: 'Descrição da tarefa'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
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
                        startDate = picked;
                      });
                    }
                  },
                  child: Text(startDate == null
                      ? 'Selecionar Data de Início'
                      : 'Início: ${DateFormat('dd/MM/yyyy').format(startDate!)}'),
                ),
                const SizedBox(height: 10),
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
                        deadline = picked;
                      });
                    }
                  },
                  child: Text(deadline == null
                      ? 'Selecionar Data de Conclusão'
                      : 'Conclusão: ${DateFormat('dd/MM/yyyy').format(deadline!)}'),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: status,
                  onChanged: (String? newValue) {
                    setState(() {
                      status = newValue!;
                    });
                  },
                  items: <String>['Pendente', 'Andamento', 'Concluído']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  addTask(
                    taskController.text,
                    descriptionController.text,
                    startDate,
                    deadline,
                    status,
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void showEditTaskDialog(Task task) {
    final TextEditingController taskController =
        TextEditingController(text: task.title);
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);
    DateTime? startDate = task.startDate;
    DateTime? deadline = task.deadline;
    String status = task.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration:
                      const InputDecoration(hintText: 'Título da tarefa'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: 'Descrição da tarefa'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        startDate = picked;
                      });
                    }
                  },
                  child: Text(startDate == null
                      ? 'Selecionar Data de Início'
                      : 'Início: ${DateFormat('dd/MM/yyyy').format(startDate!)}'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: deadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        deadline = picked;
                      });
                    }
                  },
                  child: Text(deadline == null
                      ? 'Selecionar Data de Conclusão'
                      : 'Conclusão: ${DateFormat('dd/MM/yyyy').format(deadline!)}'),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: status,
                  onChanged: (String? newValue) {
                    setState(() {
                      status = newValue!;
                    });
                  },
                  items: <String>['Pendente', 'Andamento', 'Concluído']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  editTask(
                    task,
                    taskController.text,
                    descriptionController.text,
                    startDate,
                    deadline,
                    status,
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
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
        title: const Text('Gerenciador de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddTaskDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada.'));
          }

          final tasks = snapshot.data!;
          return TaskCalendar(tasks: tasks);
        },
      ),
    );
  }
}
