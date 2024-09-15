import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tasks_manager_forcen/api/models/task_model.dart';
import 'package:tasks_manager_forcen/api/services/database_helper_service.dart';

import '../../constants/utils.dart';

class TaskRepository {
  final String apiUrl;
  final String accessToken;

  TaskRepository({this.apiUrl = kBaseUrlApi, required this.accessToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

  Future<List<TaskModel>> fetchTasks() async {
    print("Fetching tasks from $apiUrl with token: $accessToken");
    final response =
        await http.get(Uri.parse("$apiUrl/task"), headers: _headers);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<TaskModel> tasks =
          jsonResponse.map((task) => TaskModel.fromJson(task)).toList();
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return tasks;
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  // Obtenir la liste des tâches (API -> Base locale -> Affichage)
  Future<List<TaskModel>> getTasks() async {
    try {
      // Tenter de récupérer les tâches depuis l'API
      final tasks = await fetchTasks();
      // Stocker les tâches dans la base locale
      await cacheTasks(tasks);
      return tasks;
    } catch (e) {
      // Si l'API échoue, récupérer les données depuis la base locale
      print('Failed to fetch from API, loading from local cache: $e');
      return await DatabaseHelper().getTasks();
    }
  }

  // Insérer les tâches récupérées dans la base de données locale
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    await DatabaseHelper().insertTasks(tasks);
  }

  Future<void> createTask(TaskModel task) async {
    final response = await http.post(
      Uri.parse("$apiUrl/task"),
      headers: _headers,
      body: jsonEncode(task.toJson()),
    );
    print("Create task response status: ${response.statusCode}");
    print("Create task response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Failed to create task: ${response.reasonPhrase}');
    }
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await http.patch(
      Uri.parse('$apiUrl/task/${task.id}'),
      headers: _headers,
      body: jsonEncode(task.toJson()),
    );
    print("Update task response status: ${response.statusCode}");
    print("Update task response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to update task: ${response.reasonPhrase}');
    }
    return task;
  }

  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/task/$taskId'),
      headers: _headers,
    );
    print("Delete task response status: ${response.statusCode}");
    print("Delete task response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task: ${response.reasonPhrase}');
    }
  }
}
