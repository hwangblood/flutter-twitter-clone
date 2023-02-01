import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallete.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
  static route() => MaterialPageRoute(
        builder: (context) => const SignupView(),
      );
}

class _SignupViewState extends State<SignupView> {
  final appBar = WidgetConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.clear();
  }

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
                  text: 'Already have an account?',
                  children: [
                    TextSpan(
                      text: ' Login',
                      style: const TextStyle(
                        color: Pallete.blueColor,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            LoginView.route(),
                          );
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
}
