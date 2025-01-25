class Task {
  final int? id;
  final String title;
  final String status;
  final DateTime? deadline;

  Task({
    this.id,
    required this.title,
    this.status = 'Pendente',
    this.deadline,
  });

  // Método toMap para salvar a tarefa no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'deadline': deadline?.toIso8601String(),
    };
  }

  // Método fromMap para carregar a tarefa do banco de dados
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      status: map['status'],
      deadline:
          map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }

  // Adicionando o método copyWith para criar uma cópia com possíveis alterações
  Task copyWith({
    int? id,
    String? title,
    String? status,
    DateTime? deadline,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
    );
  }
}
