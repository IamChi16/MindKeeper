import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/services/auth_service.dart';
import '../../app/app_export.dart';
import '../../widgets/appstyle.dart';
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
  final name = TextEditingController();
  String currentUsername = "";

  late String uid;

  @override
  void initState() {
    super.initState();
    _authService.user.listen((user) {
      setState(() {
        currentUsername = user?.displayName ?? "";
      });
    });
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
              Navigator.pop(context);
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
                  Navigator.pushNamed(context, AppRoutes.loginScreen);
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
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.accountDetails);
      },
      child: Container(
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
                CircleAvatar(
                  radius: 16,
                  backgroundColor: appTheme.whiteA700,
                  child: Icon(Icons.camera_alt, color: appTheme.gray50001),
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
