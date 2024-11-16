import 'package:flutter/material.dart';
import '../../app/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            onTapArrowLeftone(context);
          },
        ),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
            child: Column(
              children: [
                Text(
                  "Welcome to MindKeeper",
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: 30.h),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.h),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Please login to your account or create new account to continue",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CustomText.bodyLargeWhiteA7002.copyWith(
                            height: 1.50,
                          ),
                        ),
                      ),
                      const Spacer(),
                      CustomElevatedButton(
                        text: "LOGIN",
                        height: 48,
                        margin: const EdgeInsets.only(bottom: 25),
                        buttonStyle: CustomButton.fillPrimary,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.loginScreen);
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomOutlinedButton(
                        text: "CREATE ACCOUNT",
                        height: 48,
                        buttonStyle: CustomButton.outlineIndigoA,
                        textStyle: CustomText.bodyLargeWhiteA7001,
                        margin: const EdgeInsets.only(bottom: 30),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.registerScreen);
                        },
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 26.h),
              ],
            ),
          )
        ],
      ),
    ));
  }

  onTapArrowLeftone(BuildContext context) {
    Navigator.pop(context);
  }
}
