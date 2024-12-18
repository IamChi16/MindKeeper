// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:reminder_app/ui/group_screen/widget/member_screen/member_list.dart';
import 'package:reminder_app/ui/task_screen/add_task_screen.dart';
import 'package:reminder_app/widgets/reusable_text.dart';

import '../../../app/app_export.dart';
import '../../../models/group_model.dart';

import 'group_chat_room.dart';
import 'group_detail.dart';
import 'member_screen/add_members.dart';

class GroupWidget extends StatefulWidget {
  Group group;
  GroupWidget({
    required this.group,
    super.key,
  });

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget>
    with TickerProviderStateMixin {
  final email = TextEditingController();
  bool inSync = false;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          ),
        ),
        title: Text(
          " ${widget.group.name}",
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //     //   return const AddMembersINGroup();
          //     // }));
          //   },
          //   icon: Icon(
          //     Icons.person_add_alt_1,
          //     color: appTheme.gray50001,
          //     size: 25,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MemberList(
                    groupId: widget.group.id, groupName: widget.group.name);
              }));
            },
            icon: Icon(Icons.more_vert, color: appTheme.gray50001),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: StreamBuilder<Group>(
                stream: DatabaseService().getGroup(widget.group.id),
                builder: (BuildContext context, AsyncSnapshot<Group> snapshot) {
                  return Column(
                    children: [
                      Container(
                        color: appTheme.blackA700,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data?.description ??
                                  'No description available',
                              style: TextStyle(
                                color: appTheme.whiteA700,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            GroupDetail(tabController: _tabController),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  100, // Adjust height
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab for tasks
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AddTaskScreen();
                              }));
                            },
                            icon: Icon(Icons.list_alt_rounded,
                                color: appTheme.whiteA700),
                          ),
                          ReusableText(
                            text: "Add tasks",
                            style: appStyle(
                                16, appTheme.whiteA700, FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Tab for chat room
                  GroupChatRoom(
                      groupChatId: widget.group.id,
                      groupName: widget.group.name),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
