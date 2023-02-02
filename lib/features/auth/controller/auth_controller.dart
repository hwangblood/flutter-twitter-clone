import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/home/home.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authAPI: ref.watch(authAPIProvider));
});

final currentUserAccountProvider = FutureProvider<models.Account?>((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  AuthController({
    required AuthAPI authAPI,
  })  : _authAPI = authAPI,
        super(false); // state = isLoading

  final AuthAPI _authAPI;

  Future<models.Account?> currentUser() => _authAPI.currentUserAccount();

  void signup({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await _authAPI.signup(email: email, password: password);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Account created! Please login.');
        Navigator.canPop(context);
      },
    );
  }

  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.pushReplacement(context, HomeView.route());
      },
    );
  }
}
