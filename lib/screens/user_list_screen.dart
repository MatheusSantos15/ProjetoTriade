import 'package:flutter/material.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> users = [
      {
        'name': 'Ana Carolina',
        'email': 'ana@example.com',
        'role': 'Designer',
        'avatar': 'assets/images/avatar.png',
      },
      {
        'name': 'João Pedro',
        'email': 'joao@example.com',
        'role': 'Desenvolvedor',
        'avatar': 'assets/images/avatar.png',
      },
      {
        'name': 'Maria Silva',
        'email': 'maria@example.com',
        'role': 'Gerente de Projeto',
        'avatar': 'assets/images/avatar.png',
      },
      {
        'name': 'Carlos Souza',
        'email': 'carlos@example.com',
        'role': 'QA Tester',
        'avatar': 'assets/images/avatar.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(user['avatar']!),
              ),
              title: Text(
                user['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['email']!),
                  Text(user['role']!, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                // Aqui você pode abrir detalhes se quiser
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Detalhes de ${user['name']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
