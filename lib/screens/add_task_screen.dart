// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();

  // Controladores para os campos do formulário
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();

  bool _isLoading = false;

  // Função para salvar a tarefa via API
  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Cria um novo objeto Task com os dados do formulário
      final newTask = Task(
        name: _nameController.text,
        location: _locationController.text,
        time: _timeController.text,
        isCompleted: false,
        category: 'Undone', // Categoria padrão para novas tarefas
      );

      try {
        // Chama o serviço para criar a tarefa na API
        await _taskService.createTask(newTask);

        // Mostra uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa criada com sucesso!')),
        );

        // Volta para a tela anterior e sinaliza que a lista deve ser atualizada
        Navigator.pop(context, true);

      } catch (e) {
        // Mostra uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao criar tarefa: $e')),
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
    // Limpa os controladores quando a tela é descartada
    _nameController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Tarefa'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Hora (ex: 14:00)'),
              ),
              const SizedBox(height: 24),
              // Mostra um botão de salvar ou um indicador de carregamento
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                      ),
                      child: const Text('Salvar Tarefa'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}