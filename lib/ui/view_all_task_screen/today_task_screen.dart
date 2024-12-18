import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_export.dart';
import '../../services/task_service.dart';
import '../../widgets/counter_notifier.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/tasklistwidget.dart';
import '../task_screen/add_task_screen.dart';

class TodayTask extends StatefulWidget {
  const TodayTask({super.key});

  @override
  State<TodayTask> createState() => _TodayTaskState();
}

bool show = true;

class _TodayTaskState extends State<TodayTask> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final TaskService _taskService = TaskService();
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterNotifier(),
      // builder: (context, child) {
      //   return FloatingActionButton(onPressed: () {
      //     context.read<CounterNotifier>().increment();
      //   },);
      // },
      child: Scaffold(
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
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  show = !show;
                });
              },
              icon: Icon(
                Icons.filter_alt_outlined,
                color: appTheme.whiteA700,
              ),
            ),
          ],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              children: [
                const SizedBox(height: 15),
                CustomSearchView(
                  controller: search,
                  hintText: "Search",
                  hintStyle:
                      appStyle(14, appTheme.gray50001, FontWeight.normal),
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddTaskScreen()));
            },
            backgroundColor: appTheme.indigo30001,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Icon(Icons.add, color: appTheme.whiteA700),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: TaskListWidget(
          taskStream: _taskService.todaytasks,
          emptyMessage: 'No pending tasks!',
        ),
      ),
    );
  }
}
