import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/ui/profile_setting_screen/account_details.dart';
import 'package:reminder_app/widgets/custom_container.dart';
import '../../app/app_export.dart';
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
              Navigator.pop(context, true);
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
            const SizedBox(height: 20),
            CustomContainer(
              width: double.maxFinite,
              backgroundColor: appTheme.blackA700,
              child: Column(
                children: [
                  _buildSettingItem(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildProfileSetting() {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const AccountDetails()))
              .then((value) {
            if (value == true) {
              _loadUserProfile();
            }
          });
        });
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
                              style: appStyle(
                                  16, appTheme.whiteA700, FontWeight.bold),
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
            ],
          )),
    );
  }

  _buildSettingItem() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                  text: "Theme",
                  style: TextStyle(
                      fontSize: 20,
                      color: appTheme.whiteA700,
                      fontWeight: FontWeight.normal)),
              Switch(
                value: ThemeHelper().themeData().brightness == Brightness.dark,
                onChanged: (value) {
                  ThemeHelper().changeTheme(value ? 'darkCode' : 'lightCode');
                  setState(() {});
                },
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                  text: "Language",
                  style: TextStyle(
                      fontSize: 20,
                      color: appTheme.whiteA700,
                      fontWeight: FontWeight.normal)),
              Switch(
                value: ThemeHelper().themeData().brightness == Brightness.dark,
                onChanged: (value) {
                  setState(() {});
                },
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ReusableText(
                text: "This week",
                style: TextStyle(
                    fontSize: 20,
                    color: appTheme.whiteA700,
                    fontWeight: FontWeight.normal)),
            Switch(
              value: ThemeHelper().themeData().brightness == Brightness.dark,
              onChanged: (value) {
                setState(() {});
              },
            )
          ]),
        ],
      ),
    );
  }
}
