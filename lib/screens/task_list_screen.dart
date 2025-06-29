import 'package:flutter/material.dart';

// --- Classe principal que agora é um StatefulWidget ---
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

// --- Estado da tela de lista de tarefas ---
class _TaskListScreenState extends State<TaskListScreen> {
  // Lista de exemplo de tarefas com mais detalhes
  // Em uma aplicação real, você buscaria isso de um modelo/API
  List<Map<String, dynamic>> _tasks = [
    {
      'name': 'Project daily stand-up',
      'time': '9:00 am',
      'location': 'At the conference center',
      'isCompleted': false,
      'participants': [
        'assets/images/avatar.png', // Verde Claro
        'assets/images/avatar.png', // Verde Oliva
      ],
      'category': 'Meetings',
    },
    {
      'name': 'Internia new UI style',
      'time': '11:00 am',
      'location': 'Remember to bring presents', // Adaptando para uma descrição
      'isCompleted': false,
      'participants': [
        'assets/images/avatar.png', // Verde Mar
        'assets/images/avatar.png', // Verde Mar Claro
      ],
      'category': 'Design',
    },
    {
      'name': 'Weekly Review',
      'time': '3:00 pm',
      'location': 'Wanda Square ES',
      'isCompleted': true, // Exemplo de tarefa concluída
      'participants': [
        'assets/images/avatar.png', // Verde Médio
        'assets/images/avatar.png', // Verde Limão
      ],
      'category': 'Meetings',
    },
    {
      'name': 'Interview',
      'time': '4:00 pm',
      'location': 'Remember to bring laptop',
      'isCompleted': false,
      'participants': [
        'assets/images/avatar.png', // Verde Menta
        'assets/images/avatar.png', // Verde Oliva
      ],
      'category': 'Interviews',
    },
  ];

  String _selectedFilter = 'Undone'; // Filtro selecionado inicialmente

  // Função para construir os avatares sobrepostos
  Widget _buildParticipantsAvatars(List<String> participantUrls) {
    List<Widget> avatars = [];
    for (int i = 0; i < participantUrls.length; i++) {
      // Use NetworkImage para URLs reais ou AssetImage para assets locais
      avatars.add(
        Padding(
          padding: EdgeInsets.only(left: i * 15.0), // Ajusta o deslocamento para sobrepor
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white, // Borda branca
            child: CircleAvatar(
              radius: 11,
              // Usando um placeholder com a cor de fundo desejada
              backgroundImage: AssetImage(participantUrls[i]),
              onBackgroundImageError: (exception, stackTrace) {
                // Em caso de erro ao carregar a imagem, pode mostrar um ícone de pessoa
                print('Erro ao carregar avatar: $exception');
              },
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: (participantUrls.length * 25.0).clamp(0, 70).toDouble(), // Limita a largura para poucos avatares
      child: Stack(children: avatars.reversed.toList()), // Inverte para o primeiro avatar ficar na frente
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtra as tarefas com base no filtro selecionado
    List<Map<String, dynamic>> filteredTasks = _tasks.where((task) {
      if (_selectedFilter == 'Undone') {
        return !task['isCompleted'];
      } else if (_selectedFilter == 'All') {
        return true;
      } else {
        return task['category'] == _selectedFilter;
      }
    }).toList();

    return Scaffold(
      // Removendo o AppBar padrão para criar um cabeçalho personalizado
      body: SafeArea( // Garante que o conteúdo não se sobreponha à barra de status
        child: Column(
          children: [
            // --- Seção do cabeçalho "Today" ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800], // Verde escuro para o título
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateTime.now().day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][DateTime.now().month - 1]} ${DateTime.now().year}, ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][DateTime.now().weekday - 1]}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.calendar_today, color: Colors.green[600]), // Ícone de calendário verde
                ],
              ),
            ),
            // --- Campo de Busca ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[50], // Fundo levemente verde para a busca
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.green.shade100), // Borda sutil
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.green[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.green[600]),
                    border: InputBorder.none, // Remove a borda padrão do TextField
                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                ),
              ),
            ),
            // --- Filtros/Categorias ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Undone', Colors.green),
                    const SizedBox(width: 8),
                    _buildFilterChip('Meetings', Colors.green),
                    const SizedBox(width: 8),
                    _buildFilterChip('Consummation', Colors.green),
                    const SizedBox(width: 8),
                    _buildFilterChip('Design', Colors.green), // Exemplo de outra categoria
                    const SizedBox(width: 8),
                    _buildFilterChip('All', Colors.green), // Um filtro para mostrar todas as tarefas
                  ],
                ),
              ),
            ),
            // --- Lista de Tarefas (ocupa o restante do espaço) ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  final String taskName = task['name'];
                  final String taskTime = task['time'];
                  final String taskLocation = task['location'];
                  final bool isCompleted = task['isCompleted'];
                  final List<String> participants = List<String>.from(task['participants']);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4, // Uma sombra mais pronunciada
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bordas mais arredondadas
                    ),
                    color: Colors.white, // Fundo branco para os cards
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ícone de status da tarefa (bola ou check)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Simula a mudança de status. Em uma app real, isso atualizaria seus dados.
                                    _tasks = _tasks.map((t) {
                                      if (t['name'] == taskName && t['time'] == taskTime) { // Identificador simples para o exemplo
                                        return {...t, 'isCompleted': !t['isCompleted']};
                                      }
                                      return t;
                                    }).toList();
                                  });
                                  print('Tarefa "${taskName}" clicada para mudar status!');
                                },
                                child: Icon(
                                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                                  color: isCompleted ? Colors.green : Colors.grey[400],
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      taskName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                        color: isCompleted ? Colors.grey[600] : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      taskLocation,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Hora da tarefa
                              Text(
                                taskTime,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          if (participants.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end, // Alinha avatares à direita
                              children: [
                                _buildParticipantsAvatars(participants),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // --- Botão "Add new task" ---
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você vai colocar a navegação para a tela de adicionar tarefa
                  print('Botão "Add new task" clicado!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Cor de fundo verde escura
                  foregroundColor: Colors.white, // Cor do texto/ícone
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0), // Bordas bem arredondadas
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  minimumSize: const Size(double.infinity, 50), // Ocupa a largura total
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Centraliza o conteúdo
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text(
                      'Add new task',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para os chips de filtro
  Widget _buildFilterChip(String label, MaterialColor color) {
    bool isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color[600], // Verde mais escuro quando selecionado
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : color[800], // Texto branco se selecionado, verde escuro caso contrário
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: color[50], // Fundo verde claro para chips não selecionados
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bordas arredondadas
        side: BorderSide(color: isSelected ? color[600]! : color[200]!), // Borda mais forte se selecionado
      ),
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }
}