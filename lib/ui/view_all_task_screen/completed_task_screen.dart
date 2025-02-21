// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../app/app_export.dart';
import '../../models/tasks_model.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/reusable_text.dart';

class CompletedTask extends StatefulWidget {
  const CompletedTask({super.key});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

bool show = true;

class _CompletedTaskState extends State<CompletedTask> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController search = TextEditingController();
  bool isDone = true;

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
          "Completed Task",
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder<List<Task>>(
            stream: _databaseService.completedtasks,
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
                          motion: const DrawerMotion(),
                          children: [
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
                                    checkColor: appTheme.blackA700,
                                    fillColor: WidgetStateProperty.all<Color>(
                                        tasks.priority == 'high'
                                            ? appTheme.red500
                                            : tasks.priority == 'medium'
                                                ? appTheme.yellowA900
                                                : tasks.priority == 'low'
                                                    ? appTheme.teal300
                                                    : appTheme.indigoA100),
                                    side: const BorderSide(
                                      width: 2,
                                    ),
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
}
