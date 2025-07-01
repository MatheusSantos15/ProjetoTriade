// lib/models/task.dart

class Task {
  final int? id;
  final String name;
  final String time;
  final String location;
  bool isCompleted;
  final String category;

  Task({
    this.id,
    required this.name,
    required this.time,
    required this.location,
    required this.isCompleted,
    required this.category,
  });

  // Construtor de fábrica para criar uma Task a partir de um JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      
      // Se 'name' for nulo, usa uma string vazia ''
      name: json['name'] ?? '', 
      
      // Se 'time' for nulo, usa uma string vazia ''
      time: json['time'] ?? '',

      // Se 'location' for nulo, usa uma string vazia ''
      location: json['location'] ?? '',

      // AQUI ESTÁ A CORREÇÃO PRINCIPAL:
      // Se 'isCompleted' for nulo, assume o valor 'false'.
      isCompleted: json['isCompleted'] ?? false,

      // Se 'category' for nulo, usa 'General' como padrão
      category: json['category'] ?? 'General',
    );
  }

  // Método para converter uma Task em um JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'location': location,
      'isCompleted': isCompleted,
      'category': category,
    };
  }
}