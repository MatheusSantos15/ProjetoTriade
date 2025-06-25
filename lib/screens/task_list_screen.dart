import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de exemplo (por enquanto fixa, depois vamos trazer da API)
    // Para fins de demonstração visual, adicionei um booleano para simular o "concluído"
    final List<Map<String, dynamic>> tasks = [
      {'name': 'Comprar pão', 'isCompleted': false},
      {'name': 'Estudar Flutter', 'isCompleted': true}, // Exemplo de tarefa concluída
      {'name': 'Ir à academia', 'isCompleted': false},
      {'name': 'Ligar para o médico', 'isCompleted': false},
      {'name': 'Pagar as contas', 'isCompleted': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Tarefas',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Deixa o título mais forte
            color: Colors.white, // Cor do texto do título
          ),
        ),
        backgroundColor: Colors.teal, // Uma cor que remete a produtividade
        elevation: 0, // Remove a sombra da AppBar
      ),
      body: Container(
        color: Colors.teal[50], // Um fundo claro para a lista, combinando com a AppBar
        child: ListView.builder(
          padding: const EdgeInsets.all(12.0), // Padding geral na lista
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final String taskName = task['name'];
            final bool isCompleted = task['isCompleted'];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Espaçamento entre os cards
              elevation: 3, // Uma leve sombra para destacar o card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordas arredondadas
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: GestureDetector(
                  onTap: () {
                    // Lógica para marcar/desmarcar tarefa (você vai implementar isso com setState no seu StatefullWidget futuro)
                    print('Tarefa "${taskName}" clicada para mudar status!');
                  },
                  child: Icon(
                    isCompleted ? Icons.check_circle : Icons.circle_outlined, // Ícone de concluído/pendente
                    color: isCompleted ? Colors.teal : Colors.grey[400], // Cor do ícone
                    size: 28,
                  ),
                ),
                title: Text(
                  taskName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600, // Um pouco mais de peso na fonte
                    decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none, // Risca o texto se concluído
                    color: isCompleted ? Colors.grey[600] : Colors.black87, // Cor mais suave se concluído
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, // Para que a Row ocupe o mínimo de espaço
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueGrey[400]), // Ícone de editar
                      onPressed: () {
                        // Lógica para editar a tarefa
                        print('Editar tarefa: ${taskName}');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent), // Ícone de lixeira em vermelho
                      onPressed: () {
                        // Aqui você vai colocar a lógica para deletar a tarefa
                        print('Deletar tarefa: ${taskName}');
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Você pode adicionar uma ação ao tocar no item inteiro, como ver detalhes
                  print('Item da lista clicado: ${taskName}');
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aqui você vai colocar a navegação para a tela de adicionar tarefa
          print('Botão de adicionar clicado!');
        },
        backgroundColor: Colors.teal, // Cor do FAB combinando
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}