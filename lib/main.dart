import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_keeper/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '/app/app_export.dart';

import 'ui/auth/wrapper.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await requestNotificationPermission();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setLanguageCode('vi');
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
  ]).then((value) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    // Permission granted, you can show notifications
    print('Notification permission granted');
  } else if (status.isDenied) {
    // Permission denied, handle accordingly (e.g., show a message)
    print('Notification permission denied');
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied, open app settings
    print('Notification permission permanently denied');
    openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orienation, deviceType) {
      return MaterialApp(
        title: 'mind_keeper',
        theme: ThemeHelper().themeData(),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
        home: const Wrapper(),
      );
    });
  }
}
