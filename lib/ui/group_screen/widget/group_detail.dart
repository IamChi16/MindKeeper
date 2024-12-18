import 'package:flutter/material.dart';
import 'package:reminder_app/app/app_export.dart';
import 'package:reminder_app/widgets/reusable_text.dart';

class GroupDetail extends StatelessWidget {
  final TabController tabController;

  const GroupDetail({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            color: appTheme.indigo30001,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          labelPadding: EdgeInsets.zero,
          isScrollable: false,
          labelStyle: appStyle(24, appTheme.blue90001, FontWeight.bold),
          unselectedLabelColor: appTheme.whiteA700,
          tabs: [
          Tab(
            child: SizedBox(
              width: 375.w * 0.5,
              child: Center(
                child: ReusableText(
                    text: "Todo List",
                    style: appStyle(16, appTheme.blackA700, FontWeight.normal)),
              ),
            ),
          ),
          Tab(
            child: SizedBox(
              width: 375.w * 0.5,
              child: Center(
                child: ReusableText(
                    text: "Members",
                    style: appStyle(16, appTheme.blackA700, FontWeight.normal)),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
