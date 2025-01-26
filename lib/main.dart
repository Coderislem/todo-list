// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/storage_service.dart';
import 'models/task.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _storageService = StorageService();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasksJson = await _storageService.loadTasks();
    setState(() {
      tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
    });
  }

  Future<void> _saveTasks() async {
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await _storageService.saveTasks(tasksJson);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'قائمة المهام',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('قائمة المهام'),
            backgroundColor: Colors.teal,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list)),
                Tab(icon: Icon(Icons.category)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HomeScreen(
                tasks: tasks,
                onTasksChanged: (updatedTasks) async {
                  setState(() {
                    tasks = updatedTasks;
                  });
                  await _saveTasks();
                },
              ),
              CategoriesScreen(
                tasks: tasks,
                onTasksChanged: (updatedTasks) async {
                  setState(() {
                    tasks = updatedTasks;
                  });
                  await _saveTasks();
                },
              ),
            ],
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
      ],
      locale: const Locale('ar', ''),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}