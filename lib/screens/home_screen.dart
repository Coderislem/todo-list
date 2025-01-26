// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_dialog.dart';
import '../models/category.dart'; // Add this import

class HomeScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(List<Task>) onTasksChanged;
  final _uuid = const Uuid();

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.onTasksChanged,
  });

  void _toggleTask(String taskId) {
    final updatedTasks = tasks.map((task) {
      if (task.id == taskId) {
        return Task(
          id: task.id,
          title: task.title,
          isCompleted: !task.isCompleted,
          createdAt: task.createdAt,
          expiresAt: task.expiresAt,
        );
      }
      return task;
    }).toList();
    
    onTasksChanged(updatedTasks);
  }

  void _addTask(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );

    if (result != null) {
      final newTask = Task(
        id: _uuid.v4(),
        title: result['title'],
        expiresAt: result['expiresAt'],
        category: result['category'] as TaskCategory, // Ensure category is passed
      );
      onTasksChanged([...tasks, newTask]);
    }
  }

  void _deleteTask(String taskId) {
    final updatedTasks = tasks.where((task) => task.id != taskId).toList();
    onTasksChanged(updatedTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المهام', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade200,
              Colors.white,
            ],
          ),
        ),
        child: tasks.isEmpty 
          ? const Center(
              child: Text('لا توجد مهام حالياً',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(
                  task: task,
                  onToggle: _toggleTask,
                  onDelete: _deleteTask,
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}