// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reminder_app/app/app_export.dart';
import 'package:reminder_app/widgets/custom_container.dart';
import 'package:reminder_app/widgets/custom_elevated_button.dart';
import 'package:reminder_app/widgets/reusable_text.dart';
import '../../models/group_model.dart';
import '../../services/database_service.dart';
import '../../services/image_service.dart';

class AddGroupScreen extends StatefulWidget {
  Group? group;
  AddGroupScreen({super.key, this.group});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final ImageService _imageService = ImageService();
  final name = TextEditingController();
  final description = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? _photoBase64;

  bool inSync = false;
  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadGroupPhoto();
  }

  Future<void> _loadGroupPhoto() async {
    if (widget.group?.id != null) {
      var group = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.group!.id)
          .get();

      String? photoId = group.data()?['photoId'];

      if (photoId != null) {
        var imageDoc = await FirebaseFirestore.instance
            .collection('images')
            .doc(photoId)
            .get();

        final base64Image = imageDoc.data()?['image'];
        if (base64Image != null) {
          setState(() {
            _photoBase64 = base64Image;
            _imageFile = null;
          });
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadAndSaveImage();
    }
  }

  Future<void> _uploadAndSaveImage() async {

    try {
      String imageId = await _imageService.uploadImage(_imageFile!);
      await _databaseService.saveImageUrl(widget.group!.id, imageId);
      var imageDoc = await FirebaseFirestore.instance
          .collection('images')
          .doc(imageId)
          .get();
      setState(() {
        _photoBase64 = imageDoc.data()?['image'];
      });
    } catch (e) {
      print('Failed to upload and save image: $e');
    }
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
                String? imageId;
                if (_imageFile != null) {
                  imageId = await _imageService.uploadImage(_imageFile!);
                }
                await _databaseService.createGroup(
                  name.text,
                  description.text,
                  imageId: imageId,
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
                              await _pickImage();
                            },
                            child: _imageFile != null
                                ? ClipOval(
                                    child: Image.file(
                                      _imageFile!,
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.image_outlined,
                                    size: 90, color: Colors.grey),
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
}
