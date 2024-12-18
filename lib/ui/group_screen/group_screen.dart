import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reminder_app/models/group_model.dart';
import 'package:reminder_app/services/group_service.dart';
import '../../app/app_export.dart';
import '../../widgets/reusable_text.dart';
import 'widget/group_widget.dart';

class GroupScreen extends StatefulWidget {
  
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

bool show = true;
List membersList = [];
class _GroupScreenState extends State<GroupScreen> {
  Group? group;
  final GroupService _groupService = GroupService();
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
                  _showGroupDialog(context, group: group);
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
        stream: _groupService.getGroups(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupWidget(
                                  group: group,
                                )));
                  },
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.4,
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _showGroupDialog(context, group: group);
                          },
                          icon: Icons.edit,
                          foregroundColor: appTheme.indigo30001,
                          backgroundColor: appTheme.blackA700,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            _groupService.deleteGroup(group.id);
                          },
                          icon: Icons.delete,
                          foregroundColor: appTheme.red500,
                          backgroundColor: appTheme.blackA700,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      color: appTheme.blackA700,
                      child: Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: appTheme.indigo30001,
                              child: Text(
                                group.name[0],
                                style: appStyle(16, appTheme.whiteA700,
                                    FontWeight.normal),
                              ),
                            ),
                            SizedBox(width: 20.h),
                            ReusableText(
                              text: group.name,
                              style: appStyle(16, appTheme.whiteA700,
                                  FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
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

  _showGroupDialog(BuildContext context, {Group? group}) {
    final TextEditingController _nameController =
        TextEditingController(text: group?.name);
    final TextEditingController _descriptionController = TextEditingController(
      text: group?.description,
    );
    final List<Map<String, dynamic>> membersList = [];

    //if group is not null then it is edit mode
    //else it is add mode
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appTheme.blackA700,
          title: Text(
            group == null ? "Add Group" : "Edit Group",
            style: appStyle(18, appTheme.whiteA700, FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.h),
              TextField(
                controller: _nameController,
                style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
                decoration: InputDecoration(
                  label: Text("Name",
                      style: appStyle(16, appTheme.gray400, FontWeight.normal)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: _descriptionController,
                style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  label: Text("Description",
                      style: appStyle(16, appTheme.gray400, FontWeight.normal)),
                ),
              ),       
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 40),
                backgroundColor: appTheme.indigo30001,
              ),
              onPressed: () {
                if (group == null) {
                  _groupService.addGroup(membersList,
                      _nameController.text, _descriptionController.text);
                } else {
                  _groupService.updateGroup(
                      group.id, _nameController.text, _descriptionController.text);
                }
                Navigator.pop(context);
              },
              child: Text(
                group == null ? "Add" :
                "Save",
                style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
              ),
            ),
          ],
        );
      },
    );
  }
}
