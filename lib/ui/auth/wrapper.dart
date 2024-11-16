import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/ui/login_screen/login_screen.dart';
import '../start_screen/start_screen.dart';

import '../home_screen/home_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Checking if connection is still active (to show a loading screen)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else {
              if (snapshot.data == null) {
                return const LoginScreen();
              } else {
                if (snapshot.data!.emailVerified) {
                  return const HomeScreen();
                }
                else {
                  return const StartScreen();
                }
              }
            }
          }),
    );
  }
}
