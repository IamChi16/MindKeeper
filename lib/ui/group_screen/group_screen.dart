import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reminder_app/models/group_model.dart';
import '../../app/app_export.dart';
import '../../services/database_service.dart';
import '../../widgets/appstyle.dart';
import '../../widgets/reusable_text.dart';
import 'add_group_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

bool show = true;

class _GroupScreenState extends State<GroupScreen> {
  final DatabaseService _databaseService = DatabaseService();
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
                    return AddGroupScreen();
                  }));
                },
                icon: Icon(
                  Icons.add,
                  color: appTheme.gray50001,
                  size: 25,
                ))
          ],
        ),
        body: Column(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: "My Group",
                      style:
                          appStyle(18, appTheme.whiteA700, FontWeight.normal),
                    ),
                    SizedBox(height: 15.h),
                    _groupView(),
                    ReusableText(
                      text: "Intended groups",
                      style:
                          appStyle(18, appTheme.whiteA700, FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]));
  }

  _groupView() {
    return StreamBuilder(
        stream: _databaseService.groups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Group> groupList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                Group group = groupList[index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GroupDetailsScreen(
                    //       groupName: group['name']!,
                    //       groupDescription: group['description']!,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Card(
                    color: appTheme.blackA700,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        group.name,
                        style:
                            appStyle(16, appTheme.whiteA700, FontWeight.w600),
                      ),
                      subtitle: Text(
                        group.description,
                        style:
                            appStyle(14, appTheme.gray400, FontWeight.normal),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: appTheme.whiteA700),
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }
}
