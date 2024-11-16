import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/models/tasks_model.dart';
import 'package:reminder_app/widgets/appstyle.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import '../../app/app_export.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/priority_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => AddTaskState();
}

class AddTaskState extends State<AddTaskScreen> {
  final DatabaseService _databaseService = DatabaseService();
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final title = TextEditingController();
  final description = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? pickedDate;
  String selectedPriority = 'default';
  Task? task;

  bool inSync = false;
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            iconSize: 20,
            onPressed: !inSync
                ? () {
                    Navigator.pop(context);
                  }
                : null,
            icon: Icon(
              Icons.close_rounded,
              color: appTheme.whiteA700,
            )),
        title: Text(
          "Add Task",
          style: appStyle(20, appTheme.whiteA700, FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          CustomElevatedButton(
            text: "Save",
            onPressed: () async {
              if (task == null) {
                if (title.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title cannot be empty')),
                  );
                  return;
                }
                await DatabaseService().addTodoTask(
                    title.text, title.text, selectedPriority, selectedDate);
              } else {
                await DatabaseService().updateTask(
                  task!.id,
                  title.text,
                  title.text,
                  task!.priority,
                );
              }
              Navigator.pop(context);
            },
            width: 100,
            textStyle: theme.textTheme.bodyLarge,
            buttonStyle: CustomButton.none,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildTitle(title, titleFocusNode),
                  SizedBox(height: 30.h),
                  _buildDescription(description, descriptionFocusNode),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.calendar_today,
                            color: pickedDate == null
                                ? appTheme.gray50001
                                : appTheme.red500),
                        onPressed: () async {
                            pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          setState(() {
                            if (pickedDate != null) {
                              selectedDate = pickedDate!;
                            }
                          });
                        },
                      ),
                      ReusableText(
                        text: DateFormat('EEE, d MMMM').format(selectedDate),
                        style: appStyle(16, appTheme.gray50001, FontWeight.normal),
                      ),
                      IconButton(
                        onPressed: () {
                          _showPriorityDialog(context, task);
                        },
                        icon: Icon(Icons.flag_rounded,
                            color:  selectedPriority == 'high'
                                              ? appTheme.red500
                                              : selectedPriority == 'medium'
                                                  ? appTheme.yellowA900
                                                  : selectedPriority == 'low'
                                                      ? appTheme.teal300
                                                      : appTheme.indigoA100),
                      ),
                    ],
                  ),
                  _buildSubTask(),
                  SizedBox(height: 30.h), 
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildTitle(TextEditingController title, FocusNode titleFocusNode) {
    return Container(
      color: appTheme.blackA700,
      padding: const EdgeInsets.all(10),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Title",
          contentPadding: EdgeInsets.fromLTRB(20.h, 20.h, 12.h, 20.h),
        ),
        controller: title,
        focusNode: titleFocusNode,
        autofocus: true,
      ),
    );
  }

  Widget _buildDescription(
      TextEditingController description, FocusNode descriptionFocusNode) {
    return Container(
      color: appTheme.blackA700,
      padding: const EdgeInsets.all(10),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Description",
          contentPadding: EdgeInsets.fromLTRB(20.h, 20.h, 12.h, 20.h),
        ),
        controller: description,
        focusNode: descriptionFocusNode,
        maxLines: 6,
      ),
    );
  }

  _buildSubTask() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.file_present_rounded),
        ),
        ReusableText(
          text: "Attach Files",
          style: appStyle(16, appTheme.gray50001, FontWeight.normal),
        ),
      ],
    );
  }
}
