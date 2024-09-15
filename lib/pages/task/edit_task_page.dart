import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_manager_forcen/constants/app_colors.dart';
import 'package:tasks_manager_forcen/pages/task/detail_task_page.dart';
import 'package:tasks_manager_forcen/pages/task/tasks_page.dart';
import '../../api/blocs/task_bloc.dart';
import '../../api/blocs/task_event.dart';
import '../../api/blocs/task_state.dart';
import '../../api/models/task_model.dart';

class EditTaskPage extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String priority;
  final String createdAt;

  const EditTaskPage({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    required this.createdAt,
  });

  static const String routeName = '/edit-task';

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _priority;
  late DateTime _date;
  late TimeOfDay _time;
  late String _selectedPriority;
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _priority = widget.priority;
    _date = widget.date;
    _time = widget.time;
    _selectedPriority = widget.priority; // Initialize with widget.priority
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return 'Red';
      case 'Medium':
        return 'Orange';
      case 'Low':
      default:
        return 'Green';
    }
  }

  void _updateTask() {
    DateTime parsedCreatedAt;
    try {
      parsedCreatedAt = DateTime.parse(widget.createdAt);
    } catch (e) {
      print('Date parsing error: $e');
      parsedCreatedAt =
          DateTime.now(); // Fallback to current date/time or handle as needed
    }

    final updatedTask = TaskModel(
      id: widget.id,
      title: _titleController.text,
      content: _descriptionController.text,
      dueDate: DateTime(
          _date.year, _date.month, _date.day, _time.hour, _time.minute),
      priority: _selectedPriority,
      color: _getPriorityColor(_selectedPriority),
      createdAt: parsedCreatedAt, // Use the parsed createdAt value
    );
    context.read<TaskBloc>().add(UpdateTask(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskUpdated) {
            print("SNACKKKKK $state");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task updated successfully')),
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskDetailPage(
                          id: widget.id,
                          title: widget.title,
                          description: widget.description,
                          date: widget.date,
                          time: widget.time,
                          priority: widget.priority,
                          createdAt: DateTime.parse(widget.createdAt),
                        )),
                /*MaterialPageRoute(
                    builder: (context) => TaskDetailPage(
                      id: widget.id,
                      title: widget.title,
                      description: widget.description,
                      date: widget.date,
                      time: widget.time,
                      priority: widget.priority, 
                      createdAt: DateTime.parse(widget.createdAt),
                    )),*/
              );
            });
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Select a priority',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: _priorities.map((String priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != _date) {
                          setState(() {
                            _date = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: "${_date.toLocal()}".split(' ')[0],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _time,
                        );
                        if (pickedTime != null && pickedTime != _time) {
                          setState(() {
                            _time = pickedTime;
                          });
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: _time.format(context),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _updateTask();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasksPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.kPrimaryColor, // couleur de fond
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
