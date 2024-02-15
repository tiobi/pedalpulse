import 'package:flutter/material.dart';

import '../services/auth/auth_methods.dart';
import '../features/auth/presentation/widgets/log_in_title_widget.dart';
import '../utils/managers/message_manager.dart';
import '../utils/managers/route_manager.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/custom_button_widget.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';
import '../features/auth/presentation/widgets/custom_textfield_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: AppStringManager.blank);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void navigateToSignIn() {
    Navigator.pushReplacementNamed(context, Routes.signIn);
  }

  void handleResetPassword() async {
    toggleLoading();
    final String message = await AuthMethods().sendPasswordResetEmail(
      email: _emailController.text,
    );
    toggleLoading();

    if (message != NetworkMessageManager.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (message == NetworkMessageManager.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStringManager.resetEmailSent),
          duration: Duration(seconds: 2),
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
                    AppStringManager.resetPassword,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              CustomTextfieldWidget(
                  placeholder: AppStringManager.email,
                  controller: _emailController),
              CustomButtonWidget(
                placeholder: AppStringManager.resetPassword,
                isLoading: _isLoading,
                onTap: handleResetPassword,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStringManager.backTo,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomTextButtonWidget(
                      placeholder: AppStringManager.signIn,
                      onTap: navigateToSignIn,
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
