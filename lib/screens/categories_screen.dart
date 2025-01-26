import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/task.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(List<Task>) onTasksChanged;

  const CategoriesScreen({
    super.key, 
    required this.tasks,
    required this.onTasksChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: TaskCategory.values.length,
      itemBuilder: (context, index) {
        final category = TaskCategory.values[index];
        final categoryTasks = tasks.where((task) => task.category == category).toList();
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Icon(category.icon, color: Colors.teal),
            title: Text(
              category.arabicName,
              style: const TextStyle(fontSize: 16),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${categoryTasks.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}