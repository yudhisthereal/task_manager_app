class Task {
  final int? id; // SQLite auto-incremented ID
  final int userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;

  Task({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.isCompleted,
    this.dueDate
  });

  Task copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description ?? '',
      'isCompleted': isCompleted ? 1 : 0,
      'dueDate': dueDate?.toIso8601String() ?? ''
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: (map['isCompleted'] as int) == 1,
      dueDate: DateTime.parse(map['dueDate'] as String)
    );
  }
}