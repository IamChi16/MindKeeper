// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/app_export.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/reusable_text.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountDetails> {
  final AuthService _authService = AuthService();
  final ImageService _imageService = ImageService();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? _photoBase64;
  bool _isLoading = false;
  final name = TextEditingController();
  String currentUsername = "";

  late String uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    _loadUserProfile();
    _authService.user.listen((user) {
      setState(() {
        currentUsername = user?.displayName ?? "";
      });
    });
  }

  Future<void> _loadUserProfile() async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String? photoId = user.data()?['photoId'];

    if (photoId != null) {
      var imageDoc = await FirebaseFirestore.instance
          .collection('images')
          .doc(photoId)
          .get();
      setState(() {
        _photoBase64 = imageDoc.data()?['image'];
      });
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
    setState(() {
      _isLoading = true;
    });
    try {
      String imageId = await _imageService.uploadImage(_imageFile!);
      await _authService.saveImageUrl(uid, imageId);
      var imageDoc = await FirebaseFirestore.instance
          .collection('images')
          .doc(imageId)
          .get();
      setState(() {
        _photoBase64 = imageDoc.data()?['image'];
      });
    } catch (e) {
      print('Failed to upload and save image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.blackA700,
        automaticallyImplyLeading: false,
        leading: IconButton(
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: appTheme.gray50001,
            )),
        title: Text(
          "Account Details",
          style: appStyle(20, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                height: (70 * 4).toDouble(),
                child: CustomContainer(
                  backgroundColor: appTheme.blackA700,
                  child: SizedBox(
                    child: Column(
                      children: [
                        _buildAvatarSetting(),
                        _buildUsernameSetting(),
                        _buildAccountSetting(),
                        _buildPasswordSetting(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                height: 50,
                text: "Log Out",
                textStyle: TextStyle(
                  color: appTheme.redA200,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.startScreen);
                },
                buttonStyle: CustomButton.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAvatarSetting() {
    return InkWell(
      onTap: () async {
        try {
          await _pickImage();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Profile picture updated successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error uploading profile picture')),
          );
        }
      },
      child: _isLoading
          ? const CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              constraints: const BoxConstraints(
                minHeight: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                    text: "Avatar",
                    style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
                  ),
                  Row(
                    children: [
                      ClipOval(
                        child: _photoBase64 != null
                            ? Image.memory(
                                base64Decode(_photoBase64!),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.account_circle_rounded,
                                size: 45, color: Colors.grey),
                      ),
                      const SizedBox(width: 15),
                      Icon(Icons.arrow_forward_ios,
                          color: appTheme.whiteA700, size: 16),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  _buildUsernameSetting() {
    return InkWell(
      onTap: () {
        _changeUsername(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints: const BoxConstraints(minHeight: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: "Username",
              style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
            ),
            Row(
              children: [
                StreamBuilder(
                  stream: _authService.user,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ReusableText(
                        text: currentUsername,
                        style:
                            appStyle(14, appTheme.gray400, FontWeight.normal),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios,
                    color: appTheme.whiteA700, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildAccountSetting() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.accountDetails);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints: const BoxConstraints(minHeight: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: "Email account",
              style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
            ),
            Row(
              children: [
                StreamBuilder(
                    stream: _authService.user,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ReusableText(
                          text: snapshot.data!.email ?? '',
                          style:
                              appStyle(14, appTheme.gray400, FontWeight.normal),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                Icon(Icons.arrow_forward_ios,
                    color: appTheme.whiteA700, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildPasswordSetting() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.accountDetails);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints: const BoxConstraints(minHeight: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: "Change Password",
              style: appStyle(16, appTheme.whiteA700, FontWeight.normal),
            ),
            Icon(Icons.arrow_forward_ios, color: appTheme.whiteA700, size: 16),
          ],
        ),
      ),
    );
  }

  void _changeUsername(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: TextField(
            controller: name,
            decoration: const InputDecoration(hintText: 'Enter new username'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newUsername = name.text;

                setState(() {
                  currentUsername = newUsername;
                });

                _authService.changeUsername(newUsername);

                Navigator.pop(context); // Close dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    //Navigator.pushNamed(context, AppRoutes.changePasswordScreen);
  }
}
