import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:twitter_clone/core/core.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class _AuthAPI {
  FutureEither<models.User> signup({
    required String email,
    required String password,
  });

  FutureEither<models.Session> login({
    required String email,
    required String password,
  });

  Future<models.User?> currentUserAccount();
}

class AuthAPI implements _AuthAPI {
  AuthAPI({
    required Account account,
  }) : _account = account;

  final Account _account;

  @override
  Future<models.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<models.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Something unexpected error occured.', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<models.User> signup({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Something unexpected error occured.', stackTrace),
      );
    } catch (e, stackTrace) {
      print('error $e');
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
