import 'package:flutter/material.dart';
import 'package:reminder_app/widgets/custom_container.dart';
import '../../app/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/appstyle.dart';
import '../../widgets/reusable_text.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final AuthService _authService = AuthService();
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
            Container(
              child: CustomContainer(
                width: double.maxFinite,
                height: 100,
                backgroundColor: appTheme.blackA700,
                child: _buildProfileSetting(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildProfileSetting() {
    return InkWell(
      onTap: () {
        setState(() {Navigator.pushNamed(context, AppRoutes.accountDetails);});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: appTheme.whiteA700,
                  child: Icon(Icons.camera_alt, color: appTheme.gray50001),
                ),
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
