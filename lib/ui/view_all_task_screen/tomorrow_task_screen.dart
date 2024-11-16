import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reminder_app/models/tasks_model.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/services/database_service.dart';
import '../../app/app_export.dart';
import '../../widgets/appstyle.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/reusable_text.dart';

class TomorrowTask extends StatefulWidget {
  const TomorrowTask({super.key});

  @override
  State<TomorrowTask> createState() => _TomorrowTaskState();
}

bool show = true;

class _TomorrowTaskState extends State<TomorrowTask> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController search = TextEditingController();
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: appTheme.whiteA700,
            )),
        title: Text(
          "Today",
          style: appStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
              const SizedBox(height: 15),
              CustomSearchView(
                controller: search,
                hintText: "Search",
                hintStyle: appStyle(14, appTheme.gray50001, FontWeight.normal),
                onChanged: (value) {},
                width: 350,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            _showTaskDialog(context);
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => const AddTaskScreen()));
          },
          backgroundColor: appTheme.indigo30001,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Icon(Icons.add, color: appTheme.whiteA700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: NotificationListener<UserScrollNotification>(
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
            stream: _databaseService.tomorrowtasks,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Task> taskList = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      Task tasks = taskList[index];
                      return Slidable(
                        key: ValueKey(tasks.id),
                        endActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.transparent,
                              foregroundColor: appTheme.whiteA700,
                              onPressed: (context) {
                                _showPriorityDialog(context, tasks);
                              },
                              icon: Icons.flag_rounded,
                              label: 'Priority',
                            ),
                            SlidableAction(
                              backgroundColor: Colors.transparent,
                              foregroundColor: appTheme.red500,
                              onPressed: (context) async {
                                _showDeleteConfirmationDialog(context, tasks);
                              },
                              icon: Icons.delete_rounded,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        startActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.transparent,
                              foregroundColor: appTheme.yellowA900,
                              onPressed: (context) {
                                _showTaskDialog(context, task: tasks);
                              },
                              icon: Icons.edit_rounded,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 25, left: 25, right: 25),
                          padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
                          decoration: BoxDecoration(
                            color: appTheme.indigo30001.withOpacity(0.16),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
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
                                          text: tasks.title,
                                          style: appStyle(
                                              16,
                                              appTheme.whiteA700,
                                              FontWeight.w600)),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.flag_rounded,
                                        size: 20,
                                        color: tasks.priority == 'high'
                                            ? appTheme.red500
                                            : tasks.priority == 'medium'
                                                ? appTheme.yellowA900
                                                : tasks.priority == 'low'
                                                    ? appTheme.teal300
                                                    : appTheme.indigoA100,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ReusableText(
                                              text: tasks.description,
                                              style: appStyle(
                                                  15,
                                                  appTheme.whiteA700,
                                                  FontWeight.normal)),
                                          const SizedBox(width: 15),
                                          Icon(Icons.calendar_month_rounded,
                                              color: tasks.priority == 'high'
                                                  ? appTheme.red500
                                                  : tasks.priority == 'medium'
                                                      ? appTheme.yellowA900
                                                      : tasks.priority == 'low'
                                                          ? appTheme.teal300
                                                          : appTheme.indigoA100,
                                              size: 20),
                                          Text(tasks.duedate,
                                              style: appStyle(
                                                  12,
                                                  appTheme.whiteA700,
                                                  FontWeight.normal)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: BorderSide(
                                      width: 2,
                                        color: tasks.priority == 'high'
                                            ? appTheme.red500
                                            : tasks.priority == 'medium'
                                                ? appTheme.yellowA900
                                                : tasks.priority == 'low'
                                                    ? appTheme.teal300
                                                    : appTheme.indigoA100),
                                    value: tasks.isCompleted,
                                    onChanged: (value) {
                                      setState(() {
                                        tasks.isCompleted = !isDone;
                                      });
                                      DatabaseService().updateTaskStatus(
                                          tasks.id, tasks.isCompleted);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  void _showTaskDialog(BuildContext context, {Task? task}) {
    final TextEditingController title =
        TextEditingController(text: task?.title);
    final TextEditingController descriptionController = TextEditingController(
      text: task?.description,
    );
    DateTime selectedDate = DateTime.now();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appTheme.blackA700,
          title: Text(task == null ? 'Add Task' : 'Edit Task',
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
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
                style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
                maxLines: 6,
              ),
              const SizedBox(height: 10),
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
                  await DatabaseService().addTodoTask(title.text,
                      descriptionController.text, 'default', selectedDate);
                } else {
                  if (title.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty')),
                  );
                  return;
                }
                  await DatabaseService().updateTask(
                    task.id,
                    title.text,
                    descriptionController.text,
                    task.priority,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(
                task == null ? 'Add' : 'Save',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  //delete confirmation dialog
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

  void _showPriorityDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appTheme.blackA700,
          title: Text('Select priority',
              style: TextStyle(
                fontSize: 22,
                color: appTheme.whiteA700,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.center, // Fit content vertically
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await _databaseService.updateTaskPriority(
                                task.id, 'high');
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: appTheme.red500,
                            child: Icon(Icons.flag_rounded,
                                color: appTheme.whiteA700),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("High",
                            style: TextStyle(color: appTheme.whiteA700)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await _databaseService.updateTaskPriority(
                                task.id, 'medium');
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: appTheme.yellowA900,
                            child: Icon(Icons.flag_rounded,
                                color: appTheme.whiteA700),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("Medium",
                            style: TextStyle(color: appTheme.whiteA700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Add spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await _databaseService.updateTaskPriority(
                                task.id, 'low');
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: appTheme.teal300,
                            child: Icon(Icons.flag_rounded,
                                color: appTheme.whiteA700),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("Low",
                            style: TextStyle(color: appTheme.whiteA700)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await _databaseService.updateTaskPriority(
                                task.id, 'default');
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: appTheme.indigoA100,
                            child: Icon(Icons.flag_rounded,
                                color: appTheme.whiteA700),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("Default",
                            style: TextStyle(color: appTheme.whiteA700)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}