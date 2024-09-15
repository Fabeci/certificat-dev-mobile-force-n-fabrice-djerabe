import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasks_manager_forcen/api/repository/auth_repository.dart';
import 'package:tasks_manager_forcen/widgets/app_bar.dart';
import 'package:tasks_manager_forcen/widgets/app_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Map<DateTime, List<Task>> _tasks = {
    DateTime.utc(2024, 7, 20): [Task('Task 1', 'High', true)],
    DateTime.utc(2024, 7, 21): [Task('Task 2', 'Medium', false)],
    DateTime.utc(2024, 7, 22): [
      Task('Task 3', 'Low', false),
      Task('Task 4', 'High', true)
    ],
  };

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    return Scaffold(
      appBar: CustomAppBar(
        authRepository: authRepository,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Résumé des tâches
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  TaskSummaryWidget(
                    title: 'Total Tasks',
                    count: 20,
                    color: Colors.blue,
                  ),
                  TaskSummaryWidget(
                    title: 'Completed',
                    count: 15,
                    color: Colors.green,
                  ),
                  TaskSummaryWidget(
                    title: 'In Progress',
                    count: 3,
                    color: Colors.orange,
                  ),
                  TaskSummaryWidget(
                    title: 'Overdue',
                    count: 2,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Liste des tâches récentes
              const Text(
                'Recent Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const RecentTasksWidget(),
              const SizedBox(height: 20),
              // Calendrier des tâches
              const Text(
                'Task Calendar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TaskCalendarWidget(tasks: _tasks),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskSummaryWidget extends StatelessWidget {
  const TaskSummaryWidget({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RecentTasksWidget extends StatelessWidget {
  const RecentTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Example: 5 recent tasks
        itemBuilder: (context, index) {
          final taskDate = DateTime.now().add(Duration(days: index));
          final taskTime = TimeOfDay.now();
          final priority = ['High', 'Medium', 'Low'][index % 3];
          final priorityColor = _getPriorityColor(priority);

          return Container(
            width: 250,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Task description goes here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${taskDate.year}-${taskDate.month}-${taskDate.day}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        taskTime.format(context),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.priority_high,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(fontSize: 14, color: priorityColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class TaskCalendarWidget extends StatefulWidget {
  final Map<DateTime, List<Task>> tasks;

  const TaskCalendarWidget({super.key, required this.tasks});

  @override
  State<TaskCalendarWidget> createState() => _TaskCalendarWidgetState();
}

class _TaskCalendarWidgetState extends State<TaskCalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Task> _getTasksForDay(DateTime day) {
    return widget.tasks[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Task>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      eventLoader: _getTasksForDay,
      calendarStyle: const CalendarStyle(
        markersMaxCount: 1,
        canMarkersOverflow: false,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, tasks) {
          if (tasks.isNotEmpty) {
            final task = tasks.first;
            Color color;
            if (task.isCompleted) {
              color = Colors.green;
            } else {
              color = task.priority == 'High'
                  ? Colors.red
                  : (task.priority == 'Medium' ? Colors.orange : Colors.blue);
            }
            return Container(
              margin: const EdgeInsets.all(3.0),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
    );
  }
}

class Task {
  final String name;
  final String priority;
  final bool isCompleted;

  Task(this.name, this.priority, this.isCompleted);
}
