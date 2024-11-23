import 'package:reminder_app/models/tasks_model.dart';

class SharedTasks extends Task {
  final String assignedTo;
  final int? order;

  SharedTasks({
    required this.assignedTo,
    required this.order,
    required super.id,
    required super.title,
    required super.description,
    required super.priority,
    required super.isCompleted,
    required super.time,
    required super.duedate,
    super.file,
  });
}