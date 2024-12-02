// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../app/app_export.dart';
import '../../../models/tasks_model.dart';
import '../../../widgets/priority_widget.dart';
import '../../../widgets/reusable_text.dart';
import '../../task_screen/edit_task_screen.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String priority) onPriorityChange;
  final Function() onDelete;
  final Function(bool isCompleted) onTaskStatusChange;
  String selectedPriority = 'default';

  TaskItem({
    super.key,
    required this.task,
    required this.onPriorityChange,
    required this.onDelete,
    required this.onTaskStatusChange,
  });

  Future<void> _showPriorityDialog(BuildContext context, Task? task) async {
    await showDialog(
      context: context,
      builder: (context) {
        return PriorityDialog(
          onPrioritySelected: (priority) {
            selectedPriority = priority;
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        extentRatio: 0.45,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.transparent,
            foregroundColor: appTheme.whiteA700,
            onPressed: (context) async {
              await _showPriorityDialog(context, task);
              onPriorityChange(selectedPriority);
            },
            icon: Icons.flag_rounded,
            label: 'Priority',
          ),
          SlidableAction(
            backgroundColor: Colors.transparent,
            foregroundColor: appTheme.red500,
            onPressed: (context) {
              onDelete();
            },
            icon: Icons.delete_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditTask(task: task);
          }));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: appTheme.indigo30001.withOpacity(0.16),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ReusableText(
                        text: task.title,
                        style: appStyle(
                          16,
                          appTheme.whiteA700,
                          FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.flag_rounded,
                        size: 20,
                        color: _getPriorityColor(task.priority),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ReusableText(
                        text: task.description,
                        style: appStyle(
                          15,
                          appTheme.whiteA700,
                          FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Icon(
                        Icons.calendar_month_rounded,
                        color: _getPriorityColor(task.priority),
                        size: 20,
                      ),
                      Text(
                        task.duedate,
                        style: appStyle(
                          12,
                          appTheme.whiteA700,
                          FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  width: 2,
                  color: _getPriorityColor(task.priority),
                ),
                value: task.isCompleted,
                onChanged: (value) {
                  if (value != null) {
                    onTaskStatusChange(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return appTheme.red500;
      case 'medium':
        return appTheme.yellowA900;
      case 'low':
        return appTheme.teal300;
      default:
        return appTheme.indigoA100;
    }
  }
}
