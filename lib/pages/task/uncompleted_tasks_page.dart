import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks_manager_forcen/constants/app_colors.dart';
import '../../widgets/task_widget.dart';

class UncompletedTasksPage extends StatefulWidget {
  const UncompletedTasksPage({super.key});
  static const String routeName = '/uncompleted-tasks';

  @override
  State<UncompletedTasksPage> createState() => _UncompletedTasksPageState();
}

class _UncompletedTasksPageState extends State<UncompletedTasksPage> {
  String searchQuery = '';
  String priorityFilter = 'All';

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Task 1',
      'priority': 'Low',
      'date': '2024-07-21',
      'time': '14:00',
      'isCompleted': false,
    },
    {
      'title': 'Task 2',
      'priority': 'High',
      'date': '2024-07-22',
      'time': '16:00',
      'isCompleted': false,
    },
    {
      'title': 'Task 3',
      'priority': 'Medium',
      'date': '2024-07-23',
      'time': '18:00',
      'isCompleted': false,
    },
    {
      'title': 'Task 4',
      'priority': 'Medium',
      'date': '2024-07-23',
      'time': '18:00',
      'isCompleted': false,
    },
    {
      'title': 'Task 5',
      'priority': 'Medium',
      'date': '2024-07-23',
      'time': '18:00',
      'isCompleted': false,
    },
  ];

  List<Map<String, dynamic>> get filteredTasks {
    return tasks.where((task) {
      final matchesSearchQuery = task['title'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesPriorityFilter = priorityFilter == 'All' || task['priority'] == priorityFilter;
      return matchesSearchQuery && matchesPriorityFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        title: const Text("Completed tasks"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search tasks...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  "Filter by priority: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff112255),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: priorityFilter,
                  items: <String>['All', 'High', 'Medium', 'Low']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      priorityFilter = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Task(
                  title: task['title'],
                  priority: task['priority'],
                  date: DateTime.parse(task['date']),
                  time: _parseTime(task['time']),
                  description: task['content'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
