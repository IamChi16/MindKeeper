// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reminder_app/ui/chart_screen/chart_screen.dart';
import 'package:reminder_app/ui/group_screen/group_screen.dart';
import 'package:reminder_app/ui/task_screen/add_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/completed_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/pending_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/today_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/tomorrow_task_screen.dart';
import 'package:reminder_app/widgets/custom_elevated_button.dart';
import 'package:reminder_app/widgets/custom_search_view.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import '../../app/app_export.dart';
import '../../models/category_model.dart';
import '../../widgets/category_widget.dart';
import '../profile_setting_screen/profile_setting.dart';
import '../view_all_task_screen/calendar_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

bool show = true;

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController search = TextEditingController();
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  String? _photoBase64;
  late String uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authService.user.listen((user) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    _loadUserProfile();
  }

  _loadUserProfile() async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String? photoId = user.data()?['photoId'];

    if (photoId != null) {
      var imageDoc = await FirebaseFirestore.instance
          .collection('images')
          .doc(photoId)
          .get();
      setState(() {
        _photoBase64 = imageDoc.data()?['image'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => const ProfileSetting()))
                                .then((value) {
                              if (value == true) {
                                _loadUserProfile();
                              }
                            });
                          },
                          child: _photoBase64 != null
                              ? CircleAvatar(
                                  radius: 22.5,
                                  backgroundImage: MemoryImage(
                                    base64Decode(_photoBase64!),
                                  ),
                                )
                              : const Icon(Icons.account_circle_rounded,
                                  size: 45, color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        StreamBuilder(
                          stream: _authService.user,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ReusableText(
                                text: snapshot.data?.displayName ?? 'User',
                                style: appStyle(
                                    16, appTheme.whiteA700, FontWeight.bold),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const GroupScreen()));
                            },
                            child: Icon(Icons.groups_2,
                                color: appTheme.whiteA700, size: 25)),
                        const SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ChartScreen()));
                            },
                            child: Icon(Icons.bar_chart,
                                color: appTheme.whiteA700, size: 25)),
                        const SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.notifications,
                                color: appTheme.yellowA400, size: 25)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomSearchView(
                controller: search,
                hintText: "Search",
                hintStyle: appStyle(14, appTheme.gray50001, FontWeight.normal),
                onChanged: (value) {},
                width: 350,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddTaskScreen()));
          },
          backgroundColor: appTheme.indigo30001,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Icon(Icons.add, color: appTheme.whiteA700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 30),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildToday(),
            SizedBox(height: 35.h),
            _buildTomorrow(),
            SizedBox(height: 35.h),
            _buildPlanned(),
            SizedBox(height: 35.h),
            _buildCompleted(),
            SizedBox(height: 35.h),
            _buildCalendarView(),
            //warning task
            SizedBox(height: 70.h),
            //group task
            //category
            _buildCategory(),
            SizedBox(height: 20.h),
            _categoryView(),
          ],
        ),
      ),
    );
  }

  _buildToday() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomElevatedButton(
          alignment: Alignment.topLeft,
          width: 110,
          text: "Today",
          textStyle: appStyle(16, appTheme.blueGray100, FontWeight.bold),
          buttonStyle: CustomButton.none,
          leftIcon: Icon(
            Icons.sunny,
            color: appTheme.red100,
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TodayTask()));
          },
        ),
        StreamBuilder(
          stream: Stream.fromFuture(_databaseService.countTodayPendingTasks()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                '${snapshot.data}',
                style: appStyle(13, appTheme.blueGray100, FontWeight.normal),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  _buildTomorrow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomElevatedButton(
          alignment: Alignment.topLeft,
          width: 150,
          text: "Tomorrow",
          textStyle: appStyle(16, appTheme.blueGray100, FontWeight.bold),
          buttonStyle: CustomButton.none,
          leftIcon: Icon(
            Icons.cloud,
            color: appTheme.indigo20001,
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TomorrowTask()));
          },
        ),
        StreamBuilder(
          stream:
              Stream.fromFuture(_databaseService.countTomorrowPendingTasks()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                '${snapshot.data}',
                style: appStyle(13, appTheme.blueGray100, FontWeight.normal),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  _buildPlanned() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomElevatedButton(
          width: 130,
          text: "Pending",
          textStyle: appStyle(16, appTheme.blueGray100, FontWeight.bold),
          buttonStyle: CustomButton.none,
          leftIcon: Icon(
            Icons.today,
            color: appTheme.yellowA400,
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PendingTask()));
          },
        ),
        StreamBuilder(
          stream: Stream.fromFuture(_databaseService.countPendingTasks()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                '${snapshot.data}',
                style: appStyle(13, appTheme.blueGray100, FontWeight.normal),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  _buildCompleted() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomElevatedButton(
          alignment: Alignment.topLeft,
          width: 160,
          text: "Completed",
          textStyle: appStyle(16, appTheme.blueGray100, FontWeight.bold),
          buttonStyle: CustomButton.none,
          leftIcon: Icon(
            Icons.done_all_rounded,
            color: appTheme.teal300,
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CompletedTask()));
          },
        ),
      ],
    );
  }

  _buildCalendarView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomElevatedButton(
            alignment: Alignment.topLeft,
            width: 140,
            text: "Calendar",
            textStyle: appStyle(16, appTheme.blueGray100, FontWeight.bold),
            buttonStyle: CustomButton.none,
            leftIcon: Icon(
              Icons.calendar_month_rounded,
              color: appTheme.teal3001,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CalendarView()));
            }),
      ],
    );
  }

  _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: "Category",
            style: appStyle(16, appTheme.blueGray100, FontWeight.bold),
          ),
          SizedBox(
            width: 25,
            height: 25,
            child: IconButton(
              onPressed: () {
                _openCategoryDialog(context);
              },
              icon: Icon(
                Icons.add,
                color: appTheme.indigo20001,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCategoryDialog(BuildContext context, {Category? category}) {
    showDialog(
      context: context,
      builder: (context) {
        return CategoryDialog(
          category: category,
          onSave: (newCategory) async {
            if (category == null) {
              // Add a new category
              await DatabaseService().addCategory(
                newCategory.name,
                newCategory.color,
              );
            } else {
              // Update an existing category
              await DatabaseService().updateCategory(
                newCategory.id,
                newCategory.name,
                newCategory.color,
              );
            }
          },
        );
      },
    );
  }

  _categoryView() {
    return NotificationListener<UserScrollNotification>(
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
      child: StreamBuilder(
          stream: _databaseService.categories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Category> categories = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.35,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                              onPressed: (context) {
                                _openCategoryDialog(context,
                                    category: categories[index]);
                              },
                              icon: Icons.edit,
                              foregroundColor: appTheme.indigo20001,
                              backgroundColor: Colors.transparent),
                          SlidableAction(
                            onPressed: (context) {
                              _showDeleteConfirmationDialog(
                                  context, categories[index]);
                            },
                            icon: Icons.delete,
                            foregroundColor: appTheme.red500,
                            backgroundColor: Colors.transparent,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.bookmark_rounded,
                          color: categories[index].color,
                        ),
                        title: Text(categories[index].name,
                            style: appStyle(
                                16, appTheme.whiteA700, FontWeight.normal)),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Category cate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appTheme.blackA700,
          title: const Center(
            child: Text('Are you sure you want to delete this category?',
                textAlign: TextAlign.center),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          content: Text(
            'The category will be permanently deleted and cannot restore.',
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
                await _databaseService.deleteCategory(cate.id);
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
