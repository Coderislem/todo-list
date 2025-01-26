// lib/widgets/add_task_dialog.dart
import 'package:flutter/material.dart';
import '../models/category.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();
  DateTime? _selectedDateTime;
  TaskCategory _selectedCategory = TaskCategory.other;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2), // 2 years from now
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('إضافة مهمة جديدة', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'اكتب المهمة هنا',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            // Fixed: Changed rtl to RTL
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TaskCategory>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'الفئة',
              border: OutlineInputBorder(),
            ),
            items: TaskCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Icon(category.icon),
                    const SizedBox(width: 8),
                    Text(category.arabicName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _selectDateTime,
            icon: const Icon(Icons.access_time),
            label: Text(
              _selectedDateTime == null
                  ? 'تحديد موعد انتهاء المهمة'
                  : 'الموعد: ${DateFormat('yyyy/MM/dd HH:mm').format(_selectedDateTime!)}',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, {
                'title': _controller.text,
                'expiresAt': _selectedDateTime,
                'category': _selectedCategory,
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}