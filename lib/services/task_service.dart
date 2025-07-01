// lib/services/task_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  final String _baseUrl = 'https://triade-task-service.onrender.com/tasks';

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Task.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar tarefas');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao criar tarefa.');
    }
  }

  Future<Task> updateTask(int id, Task task) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao atualizar tarefa.');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao deletar tarefa.');
    }
  }
}