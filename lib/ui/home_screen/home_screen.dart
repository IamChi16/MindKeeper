import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder_app/ui/chart_screen/chart_screen.dart';
import 'package:reminder_app/ui/group_screen/group_screen.dart';
import 'package:reminder_app/ui/task_screen/add_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/completed_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/pending_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/today_task_screen.dart';
import 'package:reminder_app/ui/view_all_task_screen/tomorrow_task_screen.dart';
import 'package:reminder_app/widgets/appstyle.dart';
import 'package:reminder_app/widgets/custom_elevated_button.dart';
import 'package:reminder_app/widgets/custom_search_view.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import '../../app/app_export.dart';
import '../../services/auth_service.dart';
import '../profile_setting_screen/profile_setting.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

bool show = true;

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController search = TextEditingController();
  final AuthService _authService = AuthService();

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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileSetting()));
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: appTheme.whiteA700,
                            child: Icon(Icons.camera_alt,
                                color: appTheme.gray50001),
                          ),
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
            SizedBox(height: 35.h),
            //group task
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
        // SizedBox(
        //   width: 25,
        //   height: 25,
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Icon(Icons.add, color: appTheme.indigo20001, size: 20),
        //   ),
        // ),
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
        // SizedBox(
        //   width: 25,
        //   height: 25,
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Icon(Icons.add, color: appTheme.indigo20001, size: 20),
        //   ),
        // ),
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
        // SizedBox(
        //   width: 25,
        //   height: 25,
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Icon(Icons.add, color: appTheme.indigo20001, size: 20),
        //   ),
        // ),
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
        // SizedBox(
        //   width: 25,
        //   height: 25,
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Icon(Icons.add, color: appTheme.indigo20001, size: 20),
        //   ),
        // ),
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
        ),
        // SizedBox(
        //   width: 25,
        //   height: 25,
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Icon(Icons.add, color: appTheme.indigo20001, size: 20),
        //   ),
        // ),
      ],
    );
  }
}
