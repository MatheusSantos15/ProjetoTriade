import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task['name']);
    _locationController = TextEditingController(text: widget.task['location']);
    _timeController = TextEditingController(text: widget.task['time']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveTask() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'location': _locationController.text,
      'time': _timeController.text,
      'isCompleted': widget.task['isCompleted'],
      'participants': widget.task['participants'],
      'category': widget.task['category'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome da tarefa'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Local'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Horário'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Salvar alterações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
