import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:pedalpulse/core/routes/routes.dart';
import 'package:pedalpulse/features/auth/core/constants/auth_string.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_text_button_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_textfield_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/sign_in_title_widget.dart';
import 'package:pedalpulse/widgets/custom_button_widget.dart';

import '../../domain/entities/auth_entity.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends HookWidget {
  SignUpPage({Key? key}) : super(key: key);

  final AuthProvider authProvider = GetIt.instance<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          height: height,
          child: SafeArea(
            child: Column(
              children: [
                _buildSignUpForm(context),
                const Spacer(),
                _buildSignInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    final TextEditingController emailController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final TextEditingController passwordController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final TextEditingController confirmPasswordController =
        useTextEditingController.fromValue(TextEditingValue.empty);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SignInTitleWidget(),
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              AuthString.signUpWithEmail,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        CustomTextfieldWidget(
          placeholder: AuthString.email,
          controller: emailController,
        ),
        CustomTextfieldWidget(
          placeholder: AuthString.password,
          controller: passwordController,
          isObscure: true,
        ),
        CustomTextfieldWidget(
          placeholder: AuthString.confirmPassword,
          controller: confirmPasswordController,
          isObscure: true,
        ),
        CustomButtonWidget(
          placeholder: AuthString.signUp,
          onTap: () => _onSignUp(
            context,
            emailController.text,
            passwordController.text,
            confirmPasswordController.text,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AuthString.alreadyHaveAnAccount),
          CustomTextButtonWidget(
            placeholder: AuthString.signIn,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.signIn);
            },
          ),
        ],
      ),
    );
  }

  void _onSignUp(BuildContext context, String email, String password,
      String confirmPassword) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AuthString.passwordsDoNotMatch),
        ),
      );
      return;
    }

    final AuthEntity authEntity = AuthEntity(
      email: email,
      password: password,
    );

    final result =
        await authProvider.signUpWithEmailAndPassword(authEntity: authEntity);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.toString()),
          duration: const Duration(seconds: 5),
        ),
      ),
      (success) => Navigator.pushReplacementNamed(context, Routes.signIn),
    );
  }
}
