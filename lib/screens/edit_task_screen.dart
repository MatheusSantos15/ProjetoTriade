// lib/screens/edit_task_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  // Agora recebe um objeto Task completo
  final Task task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Preenche os controladores com os dados da tarefa existente
    _nameController = TextEditingController(text: widget.task.name);
    _locationController = TextEditingController(text: widget.task.location);
    _timeController = TextEditingController(text: widget.task.time);
  }

  // Função para salvar as alterações via API
  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Cria um objeto Task atualizado
      final updatedTask = Task(
        id: widget.task.id,
        name: _nameController.text,
        location: _locationController.text,
        time: _timeController.text,
        isCompleted: widget.task.isCompleted,
        category: widget.task.category,
      );

      try {
        // Chama o serviço para atualizar a tarefa na API
        await _taskService.updateTask(widget.task.id!, updatedTask);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa atualizada com sucesso!')),
        );

        // Volta e sinaliza para recarregar a lista
        Navigator.pop(context, true);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao atualizar tarefa: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da tarefa'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Horário'),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
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
      ),
    );
  }
}