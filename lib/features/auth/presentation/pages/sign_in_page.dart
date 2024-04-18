import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get_it/get_it.dart';
import 'package:pedalpulse/core/routes/routes.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_text_button_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/sign_in_title_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/social_auth_divider_widget.dart';
import 'package:pedalpulse/widgets/custom_button_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_textfield_widget.dart';

import '../../core/constants/auth_string.dart';
import '../../domain/entities/auth_entity.dart';
import '../providers/auth_provider.dart';

class SignInPage extends HookWidget {
  SignInPage({Key? key}) : super(key: key);

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
                _buildSignInForm(context),
                const Spacer(),
                _buildSignUpButton(context),
                _buildSocialSignInSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    final TextEditingController emailController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final TextEditingController passwordController =
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
              AuthString.signInWithEmail,
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
        CustomButtonWidget(
          placeholder: AuthString.signIn,
          onTap: () => _onSignIn(
            context,
            email: emailController.text,
            password: passwordController.text,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CustomTextButtonWidget(
              placeholder: AuthString.forgotPassword,
              onTap: () {
                Navigator.pushNamed(context, Routes.forgotPassword);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AuthString.dontHaveAnAccount),
          CustomTextButtonWidget(
              placeholder: AuthString.signUpWithEmail,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.signUp);
              }),
        ],
      ),
    );
  }

  Widget _buildSocialSignInSection(BuildContext context) {
    return Column(
      children: [
        const SocialAuthDividerWidget(),
        Platform.isIOS
            ? SignInButton(
                Buttons.Apple,
                onPressed: () {
                  authProvider.signInWithApple(context: context);
                },
              )
            : Container(),
        SignInButton(
          Buttons.Google,
          onPressed: () {
            authProvider.signInWithGoogle(context: context);
          },
        ),
      ],
    );
  }

  void _onSignIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AuthString.fillInAllFields),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final AuthEntity authEntity = AuthEntity(
      email: email,
      password: password,
    );

    await authProvider.signInWithEmailAndPassword(
      authEntity: authEntity,
      context: context,
    );
  }
}
