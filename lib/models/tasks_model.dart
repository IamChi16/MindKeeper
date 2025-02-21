import 'dart:io';

class Task {
  String id;
  String title;
  String description;
  String priority;
  String time;
  String duedate;
  String category;
  bool isCompleted;
  File? file;

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.time,
      required this.duedate,
      required this.isCompleted, this.category = '',
      this.file});

}
