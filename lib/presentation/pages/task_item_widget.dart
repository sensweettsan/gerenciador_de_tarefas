import 'package:flutter/material.dart';
import 'package:gerenciador_de_tarefas/models/taks_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onChanged;

  TaskItem({required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.status == 'Concluído'
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      trailing: Checkbox(
        value: task.status == 'Concluído',
        onChanged: (value) {
          onChanged();
        },
      ),
    );
  }
}
