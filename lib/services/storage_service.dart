// lib/services/storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks.json');
  }

  Future<List<Map<String, dynamic>>> loadTasks() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return List<Map<String, dynamic>>.from(jsonList);
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final file = await _localFile;
    await file.writeAsString(json.encode(tasks));
  }
}