// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../app/app_export.dart';
import '../models/tasks_model.dart';
import '../ui/view_all_task_screen/widget/task_widget.dart';

class TaskListWidget extends StatefulWidget {
  final Stream<List<Task>> taskStream;
  final String emptyMessage;
  
  const TaskListWidget({
    super.key,
    required this.taskStream,
    this.emptyMessage = 'No tasks available.',
  });

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final DatabaseService _databaseService = DatabaseService();
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.reverse) {
          setState(() {
            show = false;
          });
        } else if (notification.direction == ScrollDirection.forward) {
          setState(() {
            show = true;
          });
        }
        return true;
      },
      child: StreamBuilder<List<Task>>(
        stream: widget.taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                widget.emptyMessage,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          } else {
            List<Task> taskList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                Task tasks = taskList[index];
                return TaskItem(
                  task: tasks,
                  onPriorityChange: (priority) async {
                    await _databaseService.updateTaskPriority(
                        tasks.id, priority);
                  },
                  onDelete: () async {
                    _showDeleteConfirmationDialog(context, tasks);
                  },
                  onTaskStatusChange: (isCompleted) async {
                    await _databaseService.updateTaskStatus(
                        tasks.id, isCompleted);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appTheme.blackA700,
          title: const Center(
            child: Text('Are you sure you want to delete this task?',
                textAlign: TextAlign.center),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          content: Text(
            'The task will be permanently deleted and cannot restore.',
            style: TextStyle(fontSize: 16, color: appTheme.whiteA700),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.indigo[300]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.red500,
                foregroundColor: appTheme.whiteA700,
              ),
              onPressed: () async {
                await _databaseService.deleteTask(task.id);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
