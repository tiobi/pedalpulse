// Dart and Flutter packages
import 'dart:io';
import 'package:flutter/material.dart';

// 3rd party packages
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

// Models and Providers
import '../providers/user_provider.dart';

import '../services/auth/auth_methods.dart';
import '../services/auth/social_auth_methods.dart';
import '../utils/managers/color_manager.dart';
import '../features/auth/presentation/widgets/sign_in_title_widget.dart';
import '../utils/managers/message_manager.dart';
import '../utils/managers/route_manager.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/custom_button_widget.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';
import '../core/common/widgets/custom_textfield_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: AppStringManager.blank);
    _passwordController = TextEditingController(text: AppStringManager.blank);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void onSignInWithEmail() async {
    toggleLoading();
    final String message = await AuthMethods().signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (message != NetworkMessageManager.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (message == NetworkMessageManager.success) {
      Provider.of<UserProvider>(context, listen: false).setUser();
      Navigator.pushReplacementNamed(context, Routes.mobileLayout);
    }
    toggleLoading();
  }

  void onGoogleSignIn() async {
    toggleLoading();
    final message = await SocialAuthMethods().signInWithGoogle();

    if (message == NetworkMessageManager.success) {
      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false).setUser();
        Navigator.pushReplacementNamed(
          context,
          Routes.mobileLayout,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );
        toggleLoading();
      }
    }
  }

  void navigateToForgotPasswordScreen() {
    Navigator.pushNamed(context, Routes.forgotPassword);
  }

  void navigateToSignUpScreen() {
    Navigator.pushNamed(context, Routes.signUp);
  }

  void onAppleSignIn() async {
    toggleLoading();
    final message = await SocialAuthMethods().signInWithApple();

    if (!mounted) return;
    if (message == NetworkMessageManager.success) {
      await Provider.of<UserProvider>(context, listen: false).setUser();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.mobileLayout,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SignInTitleWidget(),

              // Sign In with Email Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    AppStringManager.signInWithEmail,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              CustomTextfieldWidget(
                placeholder: AppStringManager.email,
                controller: _emailController,
              ),
              CustomTextfieldWidget(
                placeholder: AppStringManager.password,
                isObscure: true,
                controller: _passwordController,
              ),
              CustomButtonWidget(
                isLoading: _isLoading,
                placeholder: AppStringManager.signIn,
                onTap: onSignInWithEmail,
              ),

              // Forgot Password Section
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: CustomTextButtonWidget(
                    placeholder: AppStringManager.forgotPassword,
                    onTap: navigateToForgotPasswordScreen,
                  ),
                ),
              ),
              const Spacer(),

              // Sign Up Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStringManager.dontHaveAnAccount,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomTextButtonWidget(
                      placeholder: AppStringManager.signUpWithEmail,
                      onTap: navigateToSignUpScreen,
                    ),
                  ],
                ),
              ),

              // Social Sign In Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    const Divider(),
                    Center(
                      child: Container(
                        width: 50,
                        color: ColorManager.backgroundColorLight,
                        child: const Text(
                          AppStringManager.orUppercase,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Social Sign In Buttons
              // Hide Apple Sign In button on Android
              Platform.isIOS
                  ? SignInButton(
                      Buttons.Apple,
                      onPressed: onAppleSignIn,
                    )
                  : Container(),
              SignInButton(
                Buttons.Google,
                onPressed: onGoogleSignIn,
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
