import 'package:flutter/material.dart';
import 'screens/add_task_screen.dart';
import 'screens/task_list_screen.dart'; // ou onde estiver sua tela principal
import 'screens/user_list_screen.dart';
import 'screens/category_list_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const TaskListScreen(),
      routes: {
        '/add': (context) => const AddTaskScreen(),
        '/users': (context) => const UserListScreen(),
        '/categories': (context) => const CategoryListScreen(),

      },
    );
  }
}

