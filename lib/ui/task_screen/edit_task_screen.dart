import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/tasks_model.dart';
import 'package:reminder_app/widgets/appstyle.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import '../../app/app_export.dart';
import '../../models/subtask_model.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/priority_widget.dart';

class EditTask extends StatefulWidget {
  Task task;
  EditTask({required this.task, super.key});

  @override
  State<EditTask> createState() => _Edit_TaskState();
}

class _Edit_TaskState extends State<EditTask> {
  final DatabaseService _databaseService = DatabaseService();
  User? user = FirebaseAuth.instance.currentUser;
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
    title = TextEditingController(text: widget.task.title);
    description = TextEditingController(text: widget.task.description);
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
              Icons.arrow_back_ios_rounded,
              color: appTheme.whiteA700,
            )),
        title: Text(
          "Edit Task",
          style: appStyle(20, appTheme.whiteA700, FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          CustomElevatedButton(
            text: "Save",
            onPressed: () async {
              if (title.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Title cannot be empty')),
                );
                return;
              }
              _databaseService.updateTask(
                widget.task.id,
                title.text,
                title.text,
                widget.task.priority,
                selectedDate,
              );

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
                  _buildSubTask(),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.calendar_today_rounded,
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
                        style:
                            appStyle(16, appTheme.gray50001, FontWeight.normal),
                      ),
                      IconButton(
                        onPressed: () {
                          _showPriorityDialog(context, widget.task);
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
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark_outlined,
                          color: appTheme.gray50001,
                        ),
                      ),
                    ],
                  ),
                  _buildAttachFile(),
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
    String taskId = widget.task.id;
    return Container(
      color: appTheme.blackA700,
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.add_rounded, color: appTheme.gray50001),
          hintText: "Sub Task",
          contentPadding: EdgeInsets.fromLTRB(20.h, 20.h, 12.h, 20.h),
        ),
        controller: subtaskTitle,
        maxLines: 1,
        onChanged: (value) {
          _databaseService.addSubTask(taskId, subtaskTitle.text);
          setState(() {
            _buildSubTaskList();
          });
        },
      ),
    );
  }

  _buildSubTaskList() {
    return StreamBuilder(
      stream: _databaseService.getSubTasks(widget.task.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SubTask> subTasks = snapshot.data!;
          return ListView.builder(
            itemCount: subTasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(subTasks[index].title),
                leading: Checkbox(
                  value: subTasks[index].isCompleted,
                  onChanged: (value) {
                    _databaseService.updateSubTask(
                      widget.task.id,
                      subTasks[index].id,
                      subTasks[index].title,
                    );
                  },
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  _buildAttachFile() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.file_present_rounded,
            color: appTheme.gray50001,
          ),
        ),
        ReusableText(
          text: "Attach Files",
          style: appStyle(16, appTheme.gray50001, FontWeight.normal),
        ),
      ],
    );
  }
}
