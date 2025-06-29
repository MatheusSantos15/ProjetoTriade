import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _location = '';
  String _time = '';

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
                decoration: const InputDecoration(labelText: 'Nome da tarefa'),
                validator: (value) => value == null || value.isEmpty ? 'Preencha o nome' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Local'),
                onSaved: (value) => _location = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hora (ex: 14:00)'),
                onSaved: (value) => _time = value ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Navigator.pop(context, {
                      'name': _name,
                      'location': _location,
                      'time': _time,
                      'isCompleted': false,
                      'participants': [],
                      'category': 'Undone',
                    });
                  }
                },
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
