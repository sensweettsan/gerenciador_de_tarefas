import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gerenciador_de_tarefas/presentation/pages/task_item_widget.dart';
import 'package:gerenciador_de_tarefas/models/taks_model.dart';

class TaskCalendar extends StatefulWidget {
  final List<Task> tasks;

  TaskCalendar({required this.tasks});

  @override
  _TaskCalendarState createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) {
            return widget.tasks
                .where((task) => isSameDay(task.startDate, day))
                .toList();
          },
        ),
        SizedBox(height: 20),
        if (_selectedDay != null)
          Expanded(
            child: ListView(
              children: widget.tasks
                  .where((task) => isSameDay(task.startDate, _selectedDay))
                  .map((task) => TaskItem(task: task, onChanged: () {}))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
