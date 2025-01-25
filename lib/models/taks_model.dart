class Task {
  int? id;
  String title;
  String status;

  Task({this.id, required this.title, this.status = 'Pendente'});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      status: json['status'],
    );
  }
}
