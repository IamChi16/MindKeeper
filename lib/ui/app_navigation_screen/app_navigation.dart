import 'package:flutter/material.dart';
import '../../app/app_export.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Text(
                    "App Navigation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xFF000000),
                        fontSize: 20.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: Text(
                    "Check your app navigation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xFF000000),
                        fontSize: 16.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 5.h),
                Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: const Color(0xFF000000),
                )
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: Column(
                  children: [
                    _buildScreenTitle(
                      context,
                      screenTitle: "Intro Screen",
                      onTapScreenTitle: () =>
                          onTapScreenTitle(context, AppRoutes.introScreen),
                    ),
                    _buildScreenTitle(
                      context,
                      screenTitle: "Onboading Screen",
                      onTapScreenTitle: () =>
                          onTapScreenTitle(context, AppRoutes.onboading),
                    ),
                    _buildScreenTitle(
                      context,
                      screenTitle: "Onboading One Screen",
                      onTapScreenTitle: () =>
                          onTapScreenTitle(context, AppRoutes.onboading1),
                    ),
                    _buildScreenTitle(
                      context,
                      screenTitle: "Onboading Two Screen",
                      onTapScreenTitle: () =>
                          onTapScreenTitle(context, AppRoutes.onboading2),
                    ),
                    _buildScreenTitle(
                      context,
                      screenTitle: "Start Screen",
                      onTapScreenTitle: () =>
                          onTapScreenTitle(context, AppRoutes.startScreen),
                    ),
                    _buildScreenTitle(
                      context,
                      screenTitle: "Login Screen",
                      onTapScreenTitle: () =>
                          onTapScreenTitle(context, AppRoutes.loginScreen),
                    ),
                    // _buildScreenTitle(
                    //   context,
                    //   screenTitle: "Login Screen One",
                    //   onTapScreenTitle: () =>
                    //       onTapScreenTitle(context, AppRoutes.loginScreenOne),
                    // ),
                    // _buildScreenTitle(
                    //   context,
                    //   screenTitle: "Login Screen Two",
                    //   onTapScreenTitle: () =>
                    //       onTapScreenTitle(context, AppRoutes.loginScreenTwo),
                    // ),
                    _buildScreenTitle(
                      context,
                      screenTitle: "Register Screen",
                      onTapScreenTitle: () =>
                          onTapScreenTitle(context, AppRoutes.registerScreen),
                    ),
                   
                  ],
                )),
          )),
        ]),
      ),
    );
  }

  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xFF000000),
                    fontSize: 16.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(height:5.h),
            Divider(
              height: 1.h,
              thickness: 1.h,
              color: const Color(0xFF888888),
            )
          ],
        ),
      ),
    );
  }
  //Common click event
  void onTapScreenTitle(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}
