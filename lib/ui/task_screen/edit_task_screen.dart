import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/tasks_model.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/app_export.dart';
import '../../models/subtask_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/priority_widget.dart';

class EditTask extends StatefulWidget {
  final Task task;
  const EditTask({required this.task, super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final NotificationService _notificationService = NotificationService();
  final DatabaseService _databaseService = DatabaseService();
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  late TextEditingController title;
  late TextEditingController description;
  late TextEditingController subtaskTitle;
  DateTime selectedDate = DateTime.now();
  DateTime? pickedDate;
  late TimeOfDay selectedTime = TimeOfDay(
    hour: int.parse(widget.task.time.split(":")[0]),
    minute: int.parse(widget.task.time.split(":")[1]),
  );
  late String selectedPriority = widget.task.priority;
  bool isDone = false;
  bool? isReminder = false;

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
    _loadReminderState();
  }

  Future<void> _loadReminderState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isReminder = prefs.getBool('isReminder') ?? false;
    });
  }

  Future<void> _saveReminderState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isReminder', value); // Lưu giá trị vào SharedPreferences
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
                  const SnackBar(content: Text('Title cannot be empty')),
                );
                return;
              }
              setState(() {
                inSync = true;
              });

              try {
                await _databaseService.updateTask(
                    widget.task.id,
                    title.text,
                    description.text,
                    selectedPriority,
                    selectedDate,
                    selectedTime);
                Navigator.pop(context);
              } catch (e) {
                debugPrint("Error: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to save task')),
                );
              } finally {
                setState(() {
                  inSync = false;
                });
              }
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                          onPressed: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.timer_rounded,
                            color: appTheme.gray50001,
                          )),
                    ],
                  ),
                  Row(
                    children: [
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
                      IconButton(
                        onPressed: () {
                          //_showCategoryDialog(context, widget.task);
                        },
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
                  SizedBox(height: 30.h),
                  _buildNotiReminder(),
                  SizedBox(height: 30.h),
                  _buildSubTaskList(),
                  _buildSubTask(),
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
          hintStyle: TextStyle(color: appTheme.gray500),
          contentPadding: EdgeInsets.fromLTRB(20.h, 20.h, 12.h, 20.h),
        ),
        controller: subtaskTitle,
        maxLines: 1,
        onSubmitted: (value) {
          _databaseService.addSubTask(taskId, subtaskTitle.text);
          setState(() {
            subtaskTitle.clear();
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subTasks.length,
            itemBuilder: (context, index) {
              SubTask subTask = subTasks[index];
              return Container(
                color: appTheme.blackA700,
                child: Slidable(
                  key: ValueKey(subTask.id),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.2, // 20% of screen width
                    children: [
                      SlidableAction(
                        backgroundColor: appTheme.red500,
                        icon: Icons.delete_rounded,
                        onPressed: (context) {
                          _databaseService.deleteSubTask(
                              widget.task.id, subTask.id);
                        },
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Sub Task",
                        border: InputBorder.none,
                      ),
                      controller: TextEditingController(text: subTask.title),
                      onChanged: (value) async {
                        setState(() {
                          subTask.title = value;
                        });
                        await _databaseService.updateSubTask(
                            widget.task.id, subTask.id, value);
                      },
                    ),
                    leading: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      value: subTask.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          subTask.isCompleted = !isDone;
                        });
                        _databaseService.updateSubTaskStatus(
                            widget.task.id, subTask.id, subTask.isCompleted);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  Future<void> _scheduleNotification() async {
    final DateTime scheduledDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduledDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scheduled date and time must be in the future'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    print('Scheduled notification at: $scheduledDate');
    await _notificationService.scheduleNotification(scheduledDate);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Notification scheduled successfully for ${DateFormat('EEE, d MMM yyyy HH:mm').format(scheduledDate.subtract(Duration(minutes: 5)))}"),
          backgroundColor: Colors.greenAccent,
        ),
      );
    }
  }

  _buildNotiReminder() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: appTheme.gray50001,
              ),
              const SizedBox(width: 10),
              Text(
                'Reminder',
                style: appStyle(16, appTheme.gray50001, FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Switch(
            value: isReminder ?? false,
            onChanged: (value) {
              setState(() {
                isReminder = value;
                _saveReminderState(isReminder!); // Lưu giá trị khi thay đổi
                if (isReminder == true) {
                  _scheduleNotification();
                } else {
                  _notificationService.cancelNotification();
                }
              });
            },
          ),
        ],
      ),
    );
  }
//   void _showCategoryDialog(BuildContext context, Task task) async {
//   final categories = await _databaseService.categories;
//   showDialog(
//     context: context,
//     builder: (context) {
//       return (
//         categories: categories,
//         onCategorySelected: (category) {
//           _databaseService.addTaskToCategory(category.id, task.id);
//           Navigator.of(context).pop();
//         },
//       );
//     },
//   );
// }
}
