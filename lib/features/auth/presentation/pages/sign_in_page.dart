import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get_it/get_it.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/sign_in_title_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/social_auth_divider_widget.dart';
import 'package:pedalpulse/widgets/custom_button_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_textfield_widget.dart';

import '../../core/constants/auth_string.dart';
import '../../domain/entities/auth_entity.dart';
import '../providers/auth_provider.dart';

class SignInPage extends HookWidget {
  const SignInPage({Key? key}) : super(key: key);

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
                _buildSocialSignIn(context),
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
      ],
    );
  }

  Widget _buildSocialSignIn(BuildContext context) {
    return Column(
      children: [
        const SocialAuthDividerWidget(),
        Platform.isIOS
            ? SignInButton(
                Buttons.Apple,
                onPressed: () {},
              )
            : Container(),
        SignInButton(
          Buttons.Google,
          onPressed: () {},
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
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final AuthProvider authProvider = GetIt.instance<AuthProvider>();
    final AuthEntity authEntity = AuthEntity(
      email: email,
      password: password,
    );

    final result =
        await authProvider.signInWithEmailAndPassword(authEntity: authEntity);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.toString()),
          duration: const Duration(seconds: 5),
        ),
      ),
      (success) => Navigator.pushReplacementNamed(context, '/home'),
    );
  }
}
