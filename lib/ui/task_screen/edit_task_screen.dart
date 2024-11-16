import 'package:flutter/material.dart';
import 'package:reminder_app/models/tasks_model.dart';
import 'package:reminder_app/widgets/appstyle.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import '../../app/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class Edit_Task extends StatefulWidget {
  final Task _task;
  Edit_Task(this._task, {super.key});

  @override
  State<Edit_Task> createState() => _Edit_TaskState();
}

class _Edit_TaskState extends State<Edit_Task> {
  TextEditingController? title;
  TextEditingController? description;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool inSync = false;
  int indexx = 0;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget._task.title);
    description = TextEditingController(text: widget._task.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            iconSize: 20,
            onPressed: !inSync
                ? () {
                    Navigator.pop(context);
                  }
                : null,
            icon: Icon(
              Icons.close_rounded,
              color: appTheme.whiteA700,
            )),
        title: Text(
          "Add Task",
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          CustomElevatedButton(
            text: "Save",
            onPressed: () {
              //AuthService().AddTask(title.text, description.text, "default");
              Navigator.pop(context);
            },
            width: 100,
            textStyle: theme.textTheme.bodyLarge,
            buttonStyle: CustomButton.none,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(title!, _focusNode1),
            const SizedBox(
              height: 20,
            ),
            _buildDescription(description!, _focusNode2),
            const SizedBox(
              height: 20,
            ),
            _buildSubTask(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(TextEditingController title, FocusNode titleFocusNode) {
    return Container(
      color: appTheme.blackA700,
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Title",
          contentPadding: EdgeInsets.fromLTRB(20.h, 20.h, 12.h, 20.h),
        ),
        controller: title,
        focusNode: titleFocusNode,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildDescription(
      TextEditingController description, FocusNode descriptionFocusNode) {
    return Container(
      width: 300,
      color: appTheme.blackA700,
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Description",
          contentPadding: EdgeInsets.fromLTRB(20.h, 20.h, 12.h, 20.h),
        ),
        controller: description,
        focusNode: descriptionFocusNode,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  _buildSubTask() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.file_present_rounded),
        ),
        ReusableText(
          text: "Attach Files",
          style: appStyle(16, appTheme.gray50001, FontWeight.normal),
        ),
      ],
    );
  }
}
