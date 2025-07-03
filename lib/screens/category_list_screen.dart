import 'package:flutter/material.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Meetings',
        'description': 'Agendamentos e reuniões importantes',
        'color': Colors.teal
      },
      {
        'name': 'Design',
        'description': 'Tarefas de interface e experiência do usuário',
        'color': Colors.blue
      },
      {
        'name': 'Consummation',
        'description': 'Tarefas finalizadas e revisadas',
        'color': Colors.orange
      },
      {
        'name': 'Interviews',
        'description': 'Processos seletivos ou conversas técnicas',
        'color': Colors.purple
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: category['color'].withOpacity(0.1),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: category['color'],
                child: Text(
                  category['name'][0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(category['name']),
              subtitle: Text(category['description']),
              onTap: () {

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Categoria "${category['name']}" selecionada')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
