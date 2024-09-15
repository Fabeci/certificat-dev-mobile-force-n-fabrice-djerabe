import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:tasks_manager_forcen/api/repository/auth_repository.dart';
import 'package:tasks_manager_forcen/api/repository/task_repository.dart';
import 'package:tasks_manager_forcen/utils/session_manager.dart';
import 'package:tasks_manager_forcen/widgets/app_bar.dart';
import 'package:tasks_manager_forcen/widgets/app_drawer.dart';
import 'package:tasks_manager_forcen/widgets/task_widget.dart';

import '../../api/blocs/task_bloc.dart';
import '../../api/blocs/task_state.dart';
import '../../api/blocs/task_event.dart';
import 'detail_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  static const String routeName = '/tasks';

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String searchQuery = '';
  String priorityFilter = 'All';
  late final TaskBloc taskBloc;

  @override
  void initState() {
    super.initState();
    _initializeBloc();
  }

  Future<void> _initializeBloc() async {
    final sessionManager = SessionManager();
    final accessToken = await sessionManager.getAccessToken();

    taskBloc = TaskBloc(
      taskRepository: TaskRepository(accessToken: accessToken ?? ''),
    );

    BlocProvider.of<TaskBloc>(context).add(FetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context,
              '/add-task'); // Exemple de navigation vers une page d'ajout de tâche
        },
        backgroundColor: Theme.of(context)
            .primaryColor, // Couleur de fond du bouton flottant
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Ajustez le rayon ici
        ),
        elevation: 10.0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            context.read<TaskBloc>().add(FetchTasks());
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          if (state is TaskLoaded) {
            final tasks = state.tasks.where((task) {
              final matchesSearchQuery =
                  task.title.toLowerCase().contains(searchQuery.toLowerCase());
              final matchesPriorityFilter =
                  priorityFilter == 'All' || task.priority == priorityFilter;
              return matchesSearchQuery && matchesPriorityFilter;
            }).toList();

            // Trier les tâches par date de création dans l'ordre décroissant
            tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return Column(
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
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: ValueKey(task
                            .id), // Utilisez un identifiant unique pour chaque élément
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                        ),
                        onDismissed: (direction) {
                          // Assurez-vous que task.id n'est pas null avant de l'utiliser
                          if (task.id != null) {
                            BlocProvider.of<TaskBloc>(context)
                                .add(DeleteTask(task.id!));
                          } else {
                            // Gérez le cas où l'ID est nul, par exemple en affichant un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Task ID is missing.')),
                            );
                          }
                        },
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailPage(
                                  id: task.id!,
                                  title: task.title,
                                  description: task.content,
                                  date: task.dueDate,
                                  time: TimeOfDay(
                                    hour: task.dueDate.hour,
                                    minute: task.dueDate.minute,
                                  ),
                                  priority: task.priority,
                                  createdAt: task.createdAt,
                                ),
                              ),
                            );
                          },
                          child: Task(
                            title: task.title,
                            priority: task.priority,
                            date: task.dueDate,
                            time: TimeOfDay(
                              hour: task.dueDate.hour,
                              minute: task.dueDate.minute,
                            ),
                            description: task.content,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No tasks found.'));
        },
      ),
    );
  }
}
