import 'package:flutter/material.dart';

import '../services/auth/auth_methods.dart';
import '../utils/managers/log_in_title_widget.dart';
import '../utils/managers/route_manager.dart';
import '../utils/managers/string_manager.dart';
import '../utils/managers/message_manager.dart';

import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text_button_widget.dart';
import '../widgets/custom_textfield_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: AppStringManager.blank);
    _passwordController = TextEditingController(text: AppStringManager.blank);
    _confirmPasswordController =
        TextEditingController(text: AppStringManager.blank);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void handleSignUp() async {
    toggleLoading();
    final String message = await AuthMethods().signUpWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    toggleLoading();
    if (!mounted) return;
    if (message != NetworkMessageManager.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    if (message == NetworkMessageManager.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStringManager.checkYourInbox),
        ),
      );
      Navigator.pushReplacementNamed(context, Routes.signIn);
    }
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
              const LogInTitleWidget(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    AppStringManager.signUp,
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
                controller: _passwordController,
                isObscure: true,
              ),
              CustomTextfieldWidget(
                placeholder: AppStringManager.confirmPassword,
                controller: _confirmPasswordController,
                isObscure: true,
              ),
              CustomButtonWidget(
                isLoading: _isLoading,
                placeholder: AppStringManager.signUp,
                onTap: handleSignUp,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStringManager.alreadyHaveAnAccount,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomTextButtonWidget(
                      placeholder: AppStringManager.signIn,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.signIn);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
