// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/widgets/custom_elevated_button.dart';
import '/widgets/reusable_text.dart';
import '../../app/app_export.dart';
import '/widgets/custom_text_form.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableText(
              text: "Enter email to reset password",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: appTheme.indigoA200),
            ),
            const SizedBox(height: 20),
            CustomTextForm(
              hintText: "Enter email",
              label: "Email",
              textStyle: TextStyle(fontSize: 18, color: appTheme.blackA700),
              hintStyle: TextStyle(fontSize: 18, color: appTheme.gray50001),
              controller: _email,
              fillColor: theme.colorScheme.surface,
              borderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: appTheme.indigoA100),
              ),
              contentPadding: EdgeInsets.fromLTRB(12.h, 35.h, 12.h, 10.h),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              text: "Send Email",
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appTheme.indigoA200),
              height: 50,
              width: 200,
              buttonStyle: CustomButton.roundPrimary,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () async {
                await _auth.sendPasswordResetLink(_email.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "An email for password reset has sent to your email"),
                ));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
