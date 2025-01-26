import 'category.dart';

class Task {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;
  DateTime? expiresAt;
  TaskCategory category;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
    this.expiresAt,
    this.category = TaskCategory.other,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'category': category.name, // Ensure category name is saved
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    isCompleted: json['isCompleted'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    category: TaskCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => TaskCategory.other,
    ),
  );
}