import 'package:flutter/material.dart';

import '../../app/app_export.dart';
import '../../widgets/appstyle.dart';
import '../../widgets/reusable_text.dart';
import 'add_group_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.blackA700,
        leading: IconButton(
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: appTheme.gray50001,
            )),
        title: Text(
          "Group",
          style: appStyle(20, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded, color: appTheme.gray50001),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddGroupScreen();
                }));
              },
              icon: Icon(
                Icons.add,
                color: appTheme.gray50001,
                size: 25,
              ))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20.h),
                child: SizedBox(
                    height: 50,
                    child: ReusableText(
                      text: "My Group",
                      style:
                          appStyle(18, appTheme.whiteA700, FontWeight.normal),
                    )),
              ),
              
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20.h),
                child: SizedBox(
                    height: 50,
                    child: ReusableText(
                      text: "Intended groups",
                      style:
                          appStyle(18, appTheme.whiteA700, FontWeight.normal),
                    )),
              ),
            ],
          )
        ],
      )),
    );
  }
}
