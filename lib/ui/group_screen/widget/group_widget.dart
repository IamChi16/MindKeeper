import 'package:flutter/material.dart';

import '../../../app/app_export.dart';
import '../../../models/group_model.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/reusable_text.dart';

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

class _GroupWidgetState extends State<GroupWidget> {
  bool inSync = false;
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
                          autofocus: true,
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
                          maxLines: 6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomContainer(
                        backgroundColor: appTheme.blackA700,
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _showMembersDialog(context);
                              },
                              icon: const Icon(Icons.person_add_alt_1_outlined,
                                  size: 30, color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            ReusableText(
                              text: "Add members",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: appTheme.gray50001,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }

  void _showMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appTheme.blackA700,
          title: const Text(
            'Add members',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  hintStyle: TextStyle(color: appTheme.gray400),
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: "Add",
                onPressed: () {
                  // Add member
                },
                width: 100,
                textStyle: theme.textTheme.bodyLarge,
                buttonStyle: CustomButton.none,
              )
            ],
          ),
        );
      },
    );
  }
}
