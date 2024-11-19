import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/models/tasks_model.dart';
import 'package:reminder_app/widgets/appstyle.dart';
import 'package:intl/intl.dart';
import '../../app/app_export.dart';
import '../../services/database_service.dart';
import '../../widgets/priority_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => AddTaskState();
}

class AddTaskState extends State<AddTaskScreen> {
  final DatabaseService _databaseService = DatabaseService();
  User? user = FirebaseAuth.instance.currentUser;
  Task? task;
  late String uid;
  late TextEditingController title;
  late TextEditingController description;
  late TextEditingController subtaskTitle;
  DateTime selectedDate = DateTime.now();
  DateTime? pickedDate;
  String selectedPriority = 'default';

  bool inSync = false;
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    title = TextEditingController(text: task?.title);
    description = TextEditingController(text: task?.description);
    subtaskTitle = TextEditingController();
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    subtaskTitle.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void _showPriorityDialog(BuildContext context, Task? task) {
    showDialog(
      context: context,
      builder: (context) {
        return PriorityDialog(
          onPrioritySelected: (priority) {
            setState(() {
              selectedPriority = priority;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appTheme.blackA700,
      title: Text('Add Task',
          style: appStyle(22, appTheme.whiteA700, FontWeight.w600),
          textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(hintText: 'Title'),
            style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: description,
            decoration: const InputDecoration(hintText: 'Description'),
            style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
            maxLines: 6,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                  }
                },
              ),
              IconButton(
                onPressed: () {
                  _showPriorityDialog(context, task);
                },
                icon: Icon(Icons.flag_rounded,
                    color: selectedPriority == 'high'
                        ? appTheme.red500
                        : selectedPriority == 'medium'
                            ? appTheme.yellowA900
                            : selectedPriority == 'low'
                                ? appTheme.teal300
                                : appTheme.gray50001),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark_outlined,
                  color: appTheme.gray50001,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.file_present_rounded,
                  color: appTheme.gray50001,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.indigoA100,
            foregroundColor: appTheme.whiteA700,
          ),
          onPressed: () async {
            if (task == null) {
              if (title.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Title cannot be empty')),
                );
                return;
              }
              await DatabaseService().addTodoTask(
                  title.text, description.text, selectedPriority, selectedDate);
            }
            Navigator.pop(context);
          },
          child: const Text(
            'Add',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
