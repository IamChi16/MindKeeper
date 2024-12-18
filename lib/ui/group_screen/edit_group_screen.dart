// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:reminder_app/models/group_model.dart';
import 'package:reminder_app/ui/group_screen/widget/group_widget.dart';

import '../../app/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class EditGroupScreen extends StatefulWidget {
  Group group;
  EditGroupScreen({super.key, required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late TextEditingController name;
  late TextEditingController description;
  late TextEditingController email;

  bool inSync = false;
  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.group.name);
    description = TextEditingController(text: widget.group.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.blackA700,
        leading: IconButton(
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.grey[500],
          ),
        ),
        title: Text(
          widget.group.name,
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showMembersDialog(context);
            },
            icon: const Icon(Icons.person_add_alt_1_outlined,
                size: 20, color: Colors.grey),
          ),
          CustomElevatedButton(
            text: "Save",
            onPressed: () async {
              if (name.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group name is required')),
                );
                return;
              }

              try {
                await _databaseService.updateGroup(
                  widget.group.id,
                  name.text,
                  description.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group updated successfully!')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error saving group')),
                );
              }
            },
            width: 50,
            textStyle: theme.textTheme.bodyLarge,
            buttonStyle: CustomButton.none,
          )
        ],
      ),
      body: GroupWidget(
        name: name,
        description: description,
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
                onPressed: () async{
                  await _databaseService.addMemberToGroup(context, widget.group!.id, email.text);
                  Navigator.pop(context);
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
