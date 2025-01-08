// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().toString(),
        title: title,
      ));
    });
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((task) => task.id == id);
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة المهام'),
          centerTitle: true,
        ),
        body: _tasks.isEmpty
            ? const Center(
                child: Text('لا توجد مهام حالياً'),
              )
            : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    task: _tasks[index],
                    onToggle: _toggleTask,
                    onDelete: _deleteTask,
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<String>(
              context: context,
              builder: (context) => const AddTaskDialog(),
            );
            if (result != null && result.isNotEmpty) {
              _addTask(result);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}