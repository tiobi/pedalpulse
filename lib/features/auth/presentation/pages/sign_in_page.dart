import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/log_in_title_widget.dart';
import 'package:pedalpulse/widgets/custom_button_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_textfield_widget.dart';
import 'package:provider/provider.dart';

import '../../../../utils/managers/route_manager.dart';
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
        child: SizedBox(
          height: height,
          child: Column(
            children: [
              const LogInTitleWidget(),
              _buildSignInForm(context),
            ],
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
      children: [
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

    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
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
          duration: const Duration(seconds: 2),
        ),
      ),
      (success) => Navigator.pushReplacementNamed(
        context,
        Routes.mobileLayout,
      ),
    );
  }
}
