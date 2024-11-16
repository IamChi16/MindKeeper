import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/theme/custom_button.dart';
import 'package:reminder_app/ui/login_screen/login_screen.dart';
import 'package:reminder_app/widgets/custom_elevated_button.dart';
import 'package:reminder_app/widgets/reusable_text.dart';

import '../../services/auth_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final auth = AuthService();

  late Timer timer;
  @override
  void initState() {
    super.initState();
    auth.sendEmailVerificationLink();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ReusableText(
                  text:  "We have sent a verification link to your email address. Please verify your email address to continue.",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                  
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: "Resend Verification Email",
                  buttonStyle: CustomButton.fillPrimary,
                  width: 200,
                  height: 100,
                  onPressed: () async {
                    await auth.sendEmailVerificationLink();
                  },
                ),
              ],
            ),
          )),
    );
  }
}
