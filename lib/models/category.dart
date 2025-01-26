import 'package:flutter/material.dart';

enum TaskCategory {
  personal('شخصي', Icons.person),
  work('عمل', Icons.work),
  shopping('تسوق', Icons.shopping_cart),
  study('دراسة', Icons.school),
  other('أخرى', Icons.more_horiz);

  final String arabicName;
  final IconData icon;
  const TaskCategory(this.arabicName, this.icon);
}