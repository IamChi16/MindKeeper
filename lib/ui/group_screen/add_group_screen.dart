// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:flutter/material.dart';
import 'package:reminder_app/app/app_export.dart';
import 'package:reminder_app/ui/group_screen/widget/group_widget.dart';
import 'package:reminder_app/widgets/custom_elevated_button.dart';
import '../../models/group_model.dart';

class AddGroupScreen extends StatefulWidget {
  Group? group;
  AddGroupScreen({super.key, this.group});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final name = TextEditingController();
  final description = TextEditingController();

  bool inSync = false;
  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
        title: const Text(
          "Add new group",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
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
                await _databaseService.createGroup(
                  name.text,
                  description.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group created successfully!')),
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
      body: GroupWidget(name: name, description: description),
      
    );
  }
}
