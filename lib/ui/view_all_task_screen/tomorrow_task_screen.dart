import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_export.dart';
import '../../widgets/counter_notifier.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/tasklistwidget.dart';
import '../task_screen/add_task_screen.dart';

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
  String selectedPriority = 'default';
  bool isDone = false;

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
            "Tomorrow Task",
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
          taskStream: _databaseService.tomorrowtasks,
          emptyMessage: 'No pending tasks!',
        ),
      ),
    );
  }
}
