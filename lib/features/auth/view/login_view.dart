import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appBar = WidgetConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          // controller: controller,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // textfield 1
              AuthField(
                controller: emailController,
                hintText: 'Email',
              ),
              const SizedBox(height: 25),
              // textfield 2
              AuthField(
                controller: passwordController,
                hintText: 'Password',
              ),
              const SizedBox(height: 40),
              // text button
              Align(
                alignment: Alignment.topRight,
                child: RoundedSmallButton(
                  onTap: () {},
                  label: 'Done',
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account?',
                  children: [
                    TextSpan(
                      text: ' Sign up',
                      style: const TextStyle(
                        color: Pallete.blueColor,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // navigate to sign up
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.clear();
  }
}
