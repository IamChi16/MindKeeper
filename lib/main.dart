import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz; 
import '/app/app_export.dart';

import 'ui/auth/wrapper.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().initialize();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setLanguageCode('vi');
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
  ]).then((value){
    runApp(const ProviderScope(child: MyApp()));
  });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orienation, deviceType){
      return MaterialApp(
        title: 'reminder_app',
        theme: ThemeHelper().themeData(),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
        home: const Wrapper(),
      );
    });
  }
}

