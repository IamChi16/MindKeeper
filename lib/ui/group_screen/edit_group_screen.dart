// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:reminder_app/models/group_model.dart';
import 'package:reminder_app/ui/group_screen/widget/group_widget.dart';

import '../../app/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class EditGroupScreen extends StatefulWidget {
  Group group;
  EditGroupScreen({super.key,required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late TextEditingController name;
  late TextEditingController description;

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
            width: 100,
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
}