import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../app/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class Onboading extends StatefulWidget {
  const Onboading({super.key});

  @override
  State<Onboading> createState() => _OnboadingState();
}

class _OnboadingState extends State<Onboading> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: PageView(
      controller: pageController,
      children: [
        SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 60,
                  right: 24,
                ),
                child: Column(
                  children: [
                    _buildSkipImageSection(context),
                    SizedBox(
                      height: 10.h,
                      child: AnimatedSmoothIndicator(
                        activeIndex: 0,
                        count: 3,
                        effect: ScrollingDotsEffect(
                          spacing: 8.08,
                          activeDotColor: appTheme.whiteA700.withOpacity(0.87),
                          dotColor: appTheme.gray40001,
                          dotHeight: 4.h,
                          dotWidth: 26.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 100.h),
                    Text(
                      "Manage your tasks",
                      style: theme.textTheme.headlineLarge,
                    ),
                    SizedBox(height: 48.h),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 14.h),),
                    SizedBox(
                      width: double.maxFinite, 
                      child: Text(
                        "You can easily manage all of your daily tasks in MindKeeper for free",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          height: 1.50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 190),
                    _buildNavigationButtons(context),
                    SizedBox(height: 40.h)
                  ],
                ),
              ),
            )),
      ],
    )));
  }

  //Section Widget
  Widget _buildSkipImageSection(BuildContext context) {
    return SizedBox(
        height: 700.h,
        width: double.maxFinite,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CustomElevatedButton(
                width: 100.h,
                text: "Skip".toUpperCase(),
                buttonStyle: CustomButton.none,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.startScreen);
                },
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgOnboarding,
              fit: BoxFit.contain,
              width: 550.h,
              margin: const EdgeInsets.only(top: 30),
            )
          ],
        ));
  }

  //Section Widget
  Widget _buildNavigationButtons(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomElevatedButton(
            width: 150.h,
            height: 90.h,
            text: "Back".toUpperCase(),
            buttonStyle: CustomButton.none,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.onboading);
            },
          ),
          CustomElevatedButton(
            width: 150.h,
            height: 90.h,
            text: "Next".toUpperCase(),
            buttonStyle: CustomButton.fillPrimary,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.onboading1);
            },
          ),
        ],
      ),
    );
  }
}
