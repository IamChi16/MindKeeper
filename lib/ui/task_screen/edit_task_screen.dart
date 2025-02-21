import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mind_keeper/models/tasks_model.dart';
import 'package:mind_keeper/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/app_export.dart';
import '../../models/subtask_model.dart';
import '../../services/category_service.dart';
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
  final TaskService _databaseService = TaskService();
  final CategoryService _categor = CategoryService();
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  late TextEditingController title;
  late TextEditingController description;
  late TextEditingController subtaskTitle;
  final DateFormat _format = DateFormat('EEE, d MMMM');
  late DateTime selectedDate = _format.parse(widget.task.duedate);
  DateTime? pickedDate;
  late TimeOfDay selectedTime = TimeOfDay(
    hour: int.parse(widget.task.time.split(":")[0]),
    minute: int.parse(widget.task.time.split(":")[1]),
  );
  late String selectedPriority = widget.task.priority;
  late String selectedCategory = widget.task.category;
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

  void _showCategoryDialog(BuildContext context, Task? task) async {
    final categories = await _categor.getCategories();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appTheme.blackA700,
          title: Text('Select Category',
              style: TextStyle(color: appTheme.whiteA700)),
          content: SingleChildScrollView(
            child: ListBody(
              children: categories.map((category) {
                return ListTile(
                  leading: Icon(
                    Icons.bookmark_rounded,
                    color: category.color,
                  ),
                  title: Text(
                    category.name,
                    style: TextStyle(color: appTheme.whiteA700),
                  ),
                  onTap: () {
                    setState(() {
                      selectedCategory = category.id;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
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
                    selectedTime,
                    selectedCategory);
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_month_rounded,
                              color: pickedDate == null
                                  ? appTheme.gray50001
                                  : appTheme.red500),
                          onPressed: () async {
                            pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
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
                        IconButton(
                            onPressed: () async {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
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
                            _showCategoryDialog(context, widget.task);
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
        //sửa lai loi giao dien khi hien thi keyboard
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
                      side: BorderSide(
                        width: 2,
                        color: appTheme.indigo30001,
                      ),
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

  // Future<void> _scheduleNotification(int reminderBeforeMinutes) async {
  //   // final DateTime scheduledDate = DateTime(
  //   //   selectedDate.year,
  //   //   selectedDate.month,
  //   //   selectedDate.day,
  //   //   selectedTime.hour,
  //   //   selectedTime.minute,
  //   // );
  //
  //   await _notificationService.scheduleNotification(
  //       title: widget.task.title,
  //       body: widget.task.description,
  //       day: selectedDate.day,
  //       hour: selectedTime.hour,
  //       minute: selectedTime.minute,
  //       reminderBeforeMinutes: reminderBeforeMinutes,
  //       taskId: widget.task.id
  //   );
  //
  //   if (mounted) {
  //     // final DateTime notificationDate = scheduledDate.subtract(
  //     //   Duration(minutes: reminderBeforeMinutes),
  //     // );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           "Notification scheduled successfully for ${DateFormat('EEE, d MMM yyyy HH:mm').format(selectedDate.add(Duration(minutes: reminderBeforeMinutes)))}",
  //         ),
  //         backgroundColor: Colors.greenAccent,
  //       ),
  //     );
  //   }
  // }

  Future<void> _cancelNotification() async {
    await _notificationService.cancelNotification(widget.task.id); // Gọi dịch vụ để hủy thông báo
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder canceled successfully'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  int? reminderBeforeMinutes = 5; // null mặc định là không có nhắc nhở

  Widget _buildNotiReminder() {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DropdownButton<int?>(
                value: reminderBeforeMinutes,
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text('None', style: TextStyle(color: appTheme.gray500)),
                  ),
                  ...[1, 5, 10, 30, 60].map((int value) {
                    return DropdownMenuItem<int?>(
                      value: value,
                      child: Text('$value minutes before',style: TextStyle(color: appTheme.gray500)),
                    );
                  }).toList(),
                ],
                onChanged: (newValue) {
                  setState(() {
                    reminderBeforeMinutes = newValue;
                    if (reminderBeforeMinutes != null) {
                      _notificationService.scheduleNotification(
                          title: widget.task.title,
                          body: widget.task.description,
                          day: selectedDate.day,
                          hour: selectedTime.hour,
                          minute: selectedTime.minute,
                          reminderBeforeMinutes: reminderBeforeMinutes!,
                          taskId: widget.task.id);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reminder set successfully'),
                            backgroundColor: Colors.greenAccent,
                          ),
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reminder set failed'),
                            backgroundColor: Colors.greenAccent,
                          ),);
                      }
                    } else {
                      _cancelNotification();
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

