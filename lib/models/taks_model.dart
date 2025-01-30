class Task {
  final int? id;
  final String title;
  final String description; // Novo campo
  final String status;
  final DateTime? startDate;
  final DateTime? deadline;

  Task({
    this.id,
    required this.title,
    this.description = '', // Valor padrão
    required this.status,
    this.startDate,
    this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description, // Adicionado
      'status': status,
      'startDate': startDate != null ? startDate!.toIso8601String() : null,
      'deadline': deadline != null ? deadline!.toIso8601String() : null,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String, // Adicionado
      status: map['status'] as String,
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      deadline:
          map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? startDate,
    DateTime? deadline,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description, // Adicionado
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
    );
  }
}
