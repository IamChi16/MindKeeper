import 'package:flutter/material.dart';
import 'package:reminder_app/ui/home_screen/home_screen.dart';
import '../../ui/auth/wrapper.dart';
import '../../ui/profile_setting_screen/account_details.dart';
import '../../ui/profile_setting_screen/profile_setting.dart';
import '../../ui/view_all_task_screen/pending_task_screen.dart';
import '/ui/intro_screen/intro_screen.dart';
import '/ui/onboading_screen/onboading.dart';
import '/ui/onboading_screen/onboading1.dart';
import '/ui/onboading_screen/onboading2.dart';
import '/ui/start_screen/start_screen.dart';
import '/ui/login_screen/login_screen.dart';
import '/ui/register_screen/register_screen.dart';

class AppRoutes {
  static const String introScreen = '/intro_screen';
  static const String onboading = '/onboading_screen';
  static const String onboading1 = '/onboading1_screen';
  static const String onboading2 = '/onboading2_screen';
  static const String startScreen = '/start_screen';
  static const String wrapper = '/wrapper';
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String registerScreen = '/register_screen';
  static const String appNavigation = '/app_navigation';
  static const String pendingTask = '/pending_task_screen';
  static const String profileSetting = '/profile_setting';
  static const String taskScreen = '/task_screen';
  static const String accountDetails = '/account_details';

  static const String initialRoute = '/initialRoute';


  static Map<String, WidgetBuilder> routes = {
    introScreen: (context) => const IntroScreen(),
    onboading: (context) => const Onboading(),
    onboading1: (context) => const OnboadingOne(),
    onboading2: (context) => const OnboadingTwo(),
    startScreen: (context) => const StartScreen(),
    wrapper: (context) => const Wrapper(),
    loginScreen: (context) => const LoginScreen(),
    registerScreen: (context) => const RegisterScreen(),
    homeScreen: (context) => const HomeScreen(),

    //task screens
    pendingTask: (context) => const PendingTask(),

    //app screens
    profileSetting: (context) => const ProfileSetting(),
    accountDetails: (context) => const AccountDetails(),
    
    initialRoute: (context) => const StartScreen()
  };
}