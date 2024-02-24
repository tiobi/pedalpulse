import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/sign_in_title_widget.dart';

import '../../../../core/routes/routes.dart';
import '../../../../widgets/custom_button_widget.dart';
import '../../core/constants/auth_string.dart';
import '../widgets/custom_text_button_widget.dart';
import '../widgets/custom_textfield_widget.dart';

class ForgotPasswordPage extends HookWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

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
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildForgotPasswordForm(context),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AuthString.backTo,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 5),
                      CustomTextButtonWidget(
                        placeholder: AuthString.signIn,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.signIn);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordForm(BuildContext context) {
    final TextEditingController emailController =
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
              AuthString.resetPassword,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        CustomTextfieldWidget(
            placeholder: 'Email', controller: emailController),
        CustomButtonWidget(
          placeholder: AuthString.resetPassword,
          isLoading: false,
          onTap: () {},
        ),
      ],
    );
  }
}
