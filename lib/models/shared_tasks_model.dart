import 'package:reminder_app/models/tasks_model.dart';

class SharedTasks extends Task {
  final String assignedTo;
  final int? order;

  SharedTasks({
    required this.assignedTo,
    required this.order,
    required String id,
    required String title,
    required String description,
    required String priority,
    required bool isCompleted,
    required String time,
    required String duedate,
  }) : super(
          id: id,
          title: title,
          description: description,
          priority: priority,
          isCompleted: isCompleted,
          time: time,
          duedate: duedate,
        );
}