import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../app/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form.dart';
import '../auth/forgot_password.dart';
import '../auth/wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool isLoading = false;
  bool _isPasswordVisible = false;

  final auth = AuthService();

  final _email = TextEditingController();

  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: PageView(controller: pageController, children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Column(
              children: [
                SizedBox(height: 18.h),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Login",
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildEmailSection(context),
                SizedBox(height: 30.h),
                _buildPasswordSection(context),
                SizedBox(height: 30.h),
                _buildForgetPasswordButton(context),
                SizedBox(height: 80.h),
                _buildLoginButton(context),
                SizedBox(height: 26.h),
                _buildDividerSection(context),
                SizedBox(height: 22.h),
                _buildGoogleLoginButton(context),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: _buildConfirmationSection(context),
      ),
    );
  }

  Widget _buildEmailField(TextEditingController emailController,
      FocusNode emailFocusNode, String hintText, IconData icons) {
    return CustomTextForm(
      controller: emailController,
      focusNode: emailFocusNode,
      prefix: Icon(
        Icons.email,
        color: emailFocusNode.hasFocus
            ? theme.colorScheme.primary
            : const Color(0xffc5c5c5),
      ),
      hintText: "Enter your email",
      inputType: TextInputType.emailAddress,
      contentPadding: EdgeInsets.fromLTRB(12.h, 20.h, 12.h, 10.h),
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
            _buildEmailField(
                _email, emailFocusNode, 'Enter your email', Icons.email),
          ],
        ));
  }

  Widget _buildPasswordField(
      TextEditingController passwordController, FocusNode passwordFocusNode) {
     return CustomTextForm(
      controller: passwordController,
      focusNode: passwordFocusNode,
      inputAction: TextInputAction.done,
      prefix: Icon(
        Icons.lock,
        color: passwordFocusNode.hasFocus
            ? theme.colorScheme.primary
            : const Color(0xffc5c5c5),
      ),
      hintText: "Enter your password",
      obscureText: !_isPasswordVisible, // Update based on visibility state
      contentPadding: EdgeInsets.fromLTRB(12.h, 20.h, 12.h, 10.h),
      suffix: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: passwordFocusNode.hasFocus
              ? theme.colorScheme.primary
              : const Color(0xffc5c5c5),
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
          });
        },
      ),
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
            _buildPasswordField(_password, passwordFocusNode),
          ],
        ));
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Login",
      height: 48,
      textStyle: CustomText.bodyLargeWhiteA7001,
      onPressed: () {
        _logIn();
      },
      buttonStyle: CustomButton.fillPrimary,
    );
  }

  Widget _buildForgetPasswordButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomElevatedButton(
            margin: EdgeInsets.only(right: 5.h),
            width: 250.h,
            text: "Forget password?",
            textStyle: CustomText.bodyMediumWhiteA7002.copyWith(
              decoration: TextDecoration.underline,
            ),
            buttonStyle: CustomButton.none,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPassword(),
                  ));
            },
          ),
        ],
      ),
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

  Widget _buildGoogleLoginButton(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : CustomOutlinedButton(
            text: "Login with Google",
            height: 48,
            leftIcon: Container(
                margin: EdgeInsets.only(right: 10.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgGoogle,
                  width: 24.h,
                  height: 24.h,
                  fit: BoxFit.contain,
                )),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await auth.loginWithGoogle();
              setState(() {
                isLoading = false;
              });
            },
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
                text: "Don't have an account? ",
                style: CustomText.bodyMediumWhiteA7002,
                children: [
                  TextSpan(
                    text: "Register",
                    style: CustomText.bodyMediumWhiteA7002.copyWith(
                      color: theme.colorScheme
                          .primary, // Change color to indicate it's clickable
                      decoration: TextDecoration
                          .underline, // Underline to indicate it's clickable
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, AppRoutes.registerScreen);
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

  _logIn() async {
    String res =
        await auth.loginUser(email: _email.text, password: _password.text);
    if (res == "Success") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Wrapper()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res),
      ));
    }
  }
}
