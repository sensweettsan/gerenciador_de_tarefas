import 'package:flutter/material.dart';
import 'package:gerenciador_de_tarefas/models/taks_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onChanged;

  const TaskItem({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.status == 'Concluído'
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 8),
            Text(
              'Status: ${task.status}',
              style: TextStyle(
                color: task.status == 'Andamento' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: task.status == 'Concluído',
          onChanged: (value) {
            onChanged();
          },
        ),
      ),
    );
  }
}
