import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/auth.dart';
import 'package:twitter_clone/theme/theme.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();

  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appBar = WidgetConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.clear();
  }

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
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
                        onTap: onLogin,
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
                                Navigator.push(
                                  context,
                                  SignupView.route(),
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
