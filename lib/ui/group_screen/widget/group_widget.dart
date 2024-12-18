// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:reminder_app/ui/task_screen/add_task_screen.dart';
import 'package:reminder_app/widgets/reusable_text.dart';

import '../../../app/app_export.dart';
import '../../../models/group_model.dart';

import 'group_detail.dart';

class GroupWidget extends StatefulWidget {
  Group? group;
  final TextEditingController name;
  final TextEditingController description;
  GroupWidget({
    required this.name,
    required this.description,
    super.key,
  });

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget>
    with TickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: StreamBuilder<Group>(
              stream: widget.group != null
                  ? DatabaseService().getGroup(widget.group!.id)
                  : null,
              builder: (BuildContext context, AsyncSnapshot<Group> snapshot) {
                return Column(
                  children: [
                    Container(
                      color: appTheme.blackA700,
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: widget.name,
                        decoration: InputDecoration(
                          hintText: "Group Name",
                          hintStyle: TextStyle(color: appTheme.gray400),
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      color: appTheme.blackA700,
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: widget.description,
                        decoration: InputDecoration(
                          hintText: "Description",
                          hintStyle: TextStyle(color: appTheme.gray400),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            inSync = true;
                          });
                        },
                        maxLines: 3,
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
            height: 400, // Adjust height for content
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AddTaskScreen();
                  }));
                            }, icon: Icon(Icons.list_alt_rounded, color: appTheme.whiteA700,)),
                            ReusableText(text: "Add tasks", style: appStyle(16, appTheme.whiteA700, FontWeight.normal)),
                          ],
                        )
                      ],
                    ),
                    // child: ListView.builder(
                    //   padding: const EdgeInsets.all(10),
                    //   itemCount: 10,
                    //   itemBuilder: (context, index) {
                    //     return Card(
                    //       margin: const EdgeInsets.symmetric(vertical: 8),
                    //       child: ListTile(
                    //         title: Text(
                    //           'Task ${index + 1}',
                    //           style: TextStyle(color: appTheme.blackA700),
                    //         ),
                    //         subtitle: Text(
                    //           'Task description here...',
                    //           style: TextStyle(color: appTheme.gray400),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
                  // Tab for members
                  Container(
                    // child: ListView.builder(
                    //   padding: const EdgeInsets.all(10),
                    //   itemCount: 5, // Replace with actual members count
                    //   itemBuilder: (context, index) {
                    //     return Card(
                    //       margin: const EdgeInsets.symmetric(vertical: 8),
                    //       child: ListTile(
                    //         leading: CircleAvatar(
                    //           backgroundColor: appTheme.indigo30001,
                    //           child: Text(
                    //             'M${index + 1}',
                    //             style: const TextStyle(color: Colors.white),
                    //           ),
                    //         ),
                    //         title: Text(
                    //           'Member ${index + 1}',
                    //           style: TextStyle(color: appTheme.blackA700),
                    //         ),
                    //         subtitle: Text(
                    //           'Role or info here...',
                    //           style: TextStyle(color: appTheme.gray400),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
