// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:reminder_app/ui/auth/verification_screen.dart';
import '../../app/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  bool isLoading = false;
  final _auth = AuthService();

  final _email = TextEditingController();

  final _password = TextEditingController();

  final _confirmPassword = TextEditingController();

  final PageController pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
    confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              iconSize: 20,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.startScreen);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: appTheme.whiteA700,
              )),
        ),
        body: PageView(
          controller: pageController,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 30),
                  child: Column(
                    children: [
                      SizedBox(height: 18.h),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Register",
                          style: theme.textTheme.headlineLarge,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildEmailSection(context),
                      SizedBox(height: 24.h),
                      _buildPasswordSection(context),
                      SizedBox(height: 24.h),
                      _buildConfirmPasswordSection(context),
                      SizedBox(height: 98.h),
                      _buildRegisterButton(context),
                      SizedBox(height: 26.h),
                      _buildDividerSection(context),
                      SizedBox(height: 22.h),
                      _buildGoogleRegisterButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildConfirmationSection(context),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextForm(
      controller: _email,
      inputType: TextInputType.emailAddress,
      focusNode: emailFocusNode,
      prefix: Icon(
        Icons.email,
        color: emailFocusNode.hasFocus
            ? theme.colorScheme.primary
            : const Color(0xffc5c5c5),
      ),
      hintText: "Enter your email",
      inputAction: TextInputAction.next,
      textStyle: CustomText.bodyLargeWhiteA7001,
      contentPadding: EdgeInsets.fromLTRB(12.h, 14, 12.h, 10.h),
    );
  }

  Widget _buildEmailSection(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 20.h),
            _buildEmailField(context),
          ],
        ));
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextForm(
      focusNode: passwordFocusNode,
      obscureText: true,
      prefix: Icon(
        Icons.lock,
        color: passwordFocusNode.hasFocus
            ? theme.colorScheme.primary
            : const Color(0xffc5c5c5),
      ),
      controller: _password,
      hintText: "Enter your password",
      contentPadding: EdgeInsets.fromLTRB(12.h, 14, 12.h, 10.h),
    );
  }

  Widget _buildPasswordSection(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Password",
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 20.h),
            _buildPasswordField(context),
          ],
        ));
  }

  Widget _buildConfirmPasswordInput(BuildContext context) {
    return CustomTextForm(
      focusNode: confirmPasswordFocusNode,
      prefix: Icon(
        Icons.password,
        color: confirmPasswordFocusNode.hasFocus
            ? theme.colorScheme.primary
            : const Color(0xffc5c5c5),
      ),
      controller: _confirmPassword,
      hintText: "Confirm your password",
      inputAction: TextInputAction.done,
      obscureText: true,
      contentPadding: EdgeInsets.fromLTRB(12.h, 14, 12.h, 10.h),
    );
  }

  Widget _buildConfirmPasswordSection(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Confirm Password",
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 20.h),
            _buildConfirmPasswordInput(context),
          ],
        ));
  }

  Widget _buildRegisterButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Sign Up",
      height: 48,
      onPressed: _signUp,
      buttonStyle: CustomButton.fillPrimary,
    );
  }

  Widget _buildDividerSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          const Expanded(
            child: Divider(),
          ),
          Text(
            "or",
            style: CustomText.bodyLargeGray500,
          ),
          const Expanded(
            child: Divider(),
          )
        ],
      ),
    );
  }

  Widget _buildGoogleRegisterButton(BuildContext context) {
    return CustomOutlinedButton(
      text: "Register with Google",
      height: 48,
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        await _auth.loginWithGoogle();
        setState(() {
          isLoading = false;
        });
      },
      leftIcon: Container(
        margin: EdgeInsets.only(right: 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogle,
          width: 24.h,
          height: 24.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildConfirmationSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: CustomText.bodyMediumWhiteA7002,
                children: [
                  TextSpan(
                    text: "Sign in",
                    style: CustomText.bodyMediumWhiteA7002.copyWith(
                      color: theme.colorScheme
                          .primary, // Change color to indicate it's clickable
                      decoration: TextDecoration
                          .underline, // Underline to indicate it's clickable
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, AppRoutes.loginScreen);
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  onTapArrowLeftone(BuildContext context) {
    Navigator.pop(context);
  }
  _signUp() async {
    String res = await _auth.createUser(
        email: _email.text,
        password: _password.text,
        confirmPassword: _confirmPassword.text);
    if (res == "Success") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const VerificationScreen()));
    }
  }
}
