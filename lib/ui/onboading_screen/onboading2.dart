import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../app/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class OnboadingTwo extends StatefulWidget{
  const OnboadingTwo({super.key});

  @override
  State<OnboadingTwo> createState() => _OnboadingTwoState();
}

class _OnboadingTwoState extends State<OnboadingTwo> {
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
                    top: 50,
                    right: 24,
                  ),
                  child: Column(
                    children: [
                      _buildSkipImageSection(context),
                      SizedBox(
                        height: 4.h,
                        child: AnimatedSmoothIndicator(
                          activeIndex: 0,
                          count: 3,
                          effect: ScrollingDotsEffect(
                            spacing: 8.08,
                            activeDotColor:
                                appTheme.whiteA700.withOpacity(0.87),
                            dotColor: appTheme.gray40001,
                            dotHeight: 4.h,
                            dotWidth: 26.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 100.h),
                      Text(
                        "Organize your day",
                        style: theme.textTheme.headlineLarge,
                      ),
                      SizedBox(height: 48.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "You can organize your daily tasks by adding your tasks and setting the time for each task.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            height: 1.50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 190),
                      _buildActionRow(context),
                      SizedBox(height: 40.h)
                    ],
                  ),
                ),
              ),
            )
          ]
          
        ),
      ),
    );
  }

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
            const Padding(padding: EdgeInsets.only(top: 20)),
            CustomImageView(
              imagePath: ImageConstant.imgOnboarding2,
              fit: BoxFit.contain,
              width: 500.h,
            )
          ],
        ));
  }

  Widget _buildActionRow(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomElevatedButton(
            width: 100.h,
            height: 90.h,
            text: "Back".toUpperCase(),
            buttonStyle: CustomButton.none,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.onboading1);
            },
          ),
          CustomElevatedButton(
            margin: EdgeInsets.only(right: 5.h),
            width: 250.h,
            height: 90.h,
            text: "Get Started".toUpperCase(),
            buttonStyle: CustomButton.fillPrimary,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.wrapper);
            },
          ),
        ],
      ),
    );
  }
}

