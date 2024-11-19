import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reminder_app/app/app_export.dart';
import 'package:reminder_app/widgets/custom_container.dart';
import 'package:reminder_app/widgets/custom_elevated_button.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../services/database_service.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final name = TextEditingController();
  final description = TextEditingController();
  File? image;
  UploadTask? uploadTask;

  bool inSync = false;
  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

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
            onPressed: () {
              if (image != null) {
                final imageFile = Image.file(image!);
                _databaseService.createGroup(
                    name.text, description.text, imageFile);
              } else {}
              Navigator.pop(context);
            },
            width: 100,
            textStyle: theme.textTheme.bodyLarge,
            buttonStyle: CustomButton.none,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    CustomContainer(
                      backgroundColor: appTheme.blackA700,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              final picture = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (picture != null) {
                                image = File(picture.path);
                                setState(() {});
                              }
                            },
                            child: image == null
                                ? const Icon(Icons.image_outlined,
                                    size: 90, color: Colors.grey)
                                : ClipOval(
                                    child: Image.file(image!,
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.cover)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              autofocus: true,
                              controller: name,
                              decoration: InputDecoration(
                                hintText: "Group name",
                                hintStyle: TextStyle(color: appTheme.gray400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      color: appTheme.blackA700,
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: description,
                        decoration: InputDecoration(
                          hintText: "Description",
                          hintStyle: TextStyle(color: appTheme.gray400),
                        ),
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
                            onPressed: () {},
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
                )),
          ],
        ),
      ),
    );
  }
  // Future<void> _pickImageAndSaveGroup() async {
  //   final pickedFile = await image.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     final imageFile = File(pickedFile.path);
  //     _databaseService.addGroup(name.text, description.text, imageFile);
  //     Navigator.pop(context);
  //   } else {
  //     // Handle the case when no image is selected
  //   }
  // }
}
