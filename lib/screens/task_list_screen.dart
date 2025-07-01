// lib/screens/task_list_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'edit_task_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  late Future<List<Task>> _tasksFuture;
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  String _selectedFilter = 'Undone';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _tasksFuture = _taskService.getTasks();
    });
  }

  void _filterTasks() {
    if (_selectedFilter == 'Undone') {
      _filteredTasks = _allTasks.where((task) => !task.isCompleted).toList();
    } else if (_selectedFilter == 'All') {
      _filteredTasks = _allTasks;
    } else {
      _filteredTasks =
          _allTasks.where((task) => task.category == _selectedFilter).toList();
    }
  }

  void _deleteTask(int id) async {
    try {
      await _taskService.deleteTask(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa excluída com sucesso!')),
      );
      _loadTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao excluir tarefa: $e')),
      );
    }
  }

  void _toggleComplete(Task task) async {
    try {
      task.isCompleted = !task.isCompleted;
      await _taskService.updateTask(task.id!, task);
      // For a faster UI response, we can update the state locally
      // before waiting for the full reload.
      setState(() {
        _filterTasks();
      });
    } catch (e) {
      setState(() {
        task.isCompleted = !task.isCompleted; // Revert on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar status da tarefa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterChips(),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: _tasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erro: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    _allTasks = snapshot.data!;
                    _filterTasks(); // Apply initial filter
                    return _buildTaskList();
                  } else {
                    return const Center(child: Text("Nenhuma tarefa encontrada"));
                  }
                },
              ),
            ),
            _buildAddTaskButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) {
        // AQUI ESTÁ A CORREÇÃO:
        // 'task' agora é garantidamente um objeto do tipo Task.
        final Task task = _filteredTasks[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _toggleComplete(task),
                  child: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                    color: task.isCompleted ? Colors.green : Colors.grey[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          color: task.isCompleted ? Colors.grey[600] : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(task.time, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Agora está correto: enviando um objeto Task.
                                builder: (context) => EditTaskScreen(task: task),
                              ),
                            );
                            if (result == true) {
                              _loadTasks();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () => _deleteTask(task.id!),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green[800])),
              const SizedBox(height: 4),
              Text(
                '${DateTime.now().day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][DateTime.now().month - 1]} ${DateTime.now().year}, ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][DateTime.now().weekday - 1]}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.person, color: Colors.green),
                  tooltip: 'Usuários',
                  onPressed: () => Navigator.pushNamed(context, '/users')),
              IconButton(
                  icon: const Icon(Icons.category, color: Colors.green),
                  tooltip: 'Categorias',
                  onPressed: () => Navigator.pushNamed(context, '/categories')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: Colors.green[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.green[50],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Undone'),
            const SizedBox(width: 8),
            _buildFilterChip('Meetings'),
            const SizedBox(width: 8),
            _buildFilterChip('Design'),
            const SizedBox(width: 8),
            _buildFilterChip('All'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedFilter = label;
            _filterTasks(); // Refilter the list when a chip is selected
          });
        }
      },
      selectedColor: Colors.green,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      backgroundColor: Colors.green[50],
    );
  }

  Widget _buildAddTaskButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 10.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add new task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}