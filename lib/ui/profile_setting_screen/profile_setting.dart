import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/widgets/custom_container.dart';
import '../../app/app_export.dart';
import '../../widgets/appstyle.dart';
import '../../widgets/reusable_text.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final AuthService _authService = AuthService();
  String? _photoBase64;
  late String uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authService.user.listen((user) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    _loadUserProfile();
  }

   _loadUserProfile() async {
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
          "Setting",
          style: appStyle(20, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CustomContainer(
              width: double.maxFinite,
              height: 100,
              backgroundColor: appTheme.blackA700,
              child: _buildProfileSetting(),
            ),
          ],
        ),
      ),
    );
  }

  _buildProfileSetting() {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, AppRoutes.accountDetails);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _photoBase64 != null
                    ? CircleAvatar(
                        radius: 22.5,
                        backgroundImage: MemoryImage(
                          base64Decode(_photoBase64!),
                        ),
                      )
                    : const Icon(Icons.account_circle_rounded,
                        size: 45, color: Colors.grey),
                const SizedBox(width: 10),
                StreamBuilder(
                  stream: _authService.user,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ReusableText(
                        text: snapshot.data?.displayName ?? 'User',
                        style:
                            appStyle(16, appTheme.whiteA700, FontWeight.bold),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: appTheme.whiteA700),
          ],
        ),
      ),
    );
  }
}
