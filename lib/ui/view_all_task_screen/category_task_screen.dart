import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_export.dart';
import '../../models/category_model.dart';
import '../../services/task_service.dart';
import '../../widgets/counter_notifier.dart';
import '../../widgets/tasklistwidget.dart';
import '../../widgets/custom_search_view.dart';
import '../task_screen/add_task_screen.dart';


// Update the CategoryScreen class to accept a Category object
class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}
bool show = true;
class _CategoryScreenState extends State<CategoryScreen> {
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
            ),
          ),
          title: Text(
            widget.category.name,
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
          taskStream: _taskService.getTasksByCategory(widget.category.id),
          emptyMessage: 'No tasks in this category!',
        ),
      ),
    );
  }
}