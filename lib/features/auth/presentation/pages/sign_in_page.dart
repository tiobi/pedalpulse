import 'package:flutter/material.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/log_in_title_widget.dart';
import 'package:pedalpulse/widgets/custom_button_widget.dart';
import 'package:pedalpulse/widgets/custom_textfield_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: height,
          child: Column(
            children: [
              const LogInTitleWidget(),
              CustomTextfieldWidget(placeholder: 'email'),
              CustomTextfieldWidget(placeholder: 'password', isObscure: true),
              const CustomButtonWidget(placeholder: 'Sign In'),
            ],
          ),
        ),
      ),
    );
  }
}
