import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/core.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authAPI: ref.watch(authAPIProvider));
});

class AuthController extends StateNotifier<bool> {
  AuthController({
    required AuthAPI authAPI,
  })  : _authAPI = authAPI,
        super(false);

  final AuthAPI _authAPI;

  // state = isLoading

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
      (r) => print(r.email),
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
      (r) => print(r.userId),
    );
  }
}
