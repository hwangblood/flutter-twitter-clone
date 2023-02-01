import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fpdart/fpdart.dart';

import 'package:twitter_clone/core/core.dart';

abstract class _AuthApi {
  FutureEither<models.Account> signup({
    required String email,
    required String password,
  });
}

class AuthApi implements _AuthApi {
  AuthApi({
    required Account account,
  }) : _account = account;

  final Account _account;

  @override
  FutureEither<models.Account> signup(
      {required String email, required String password}) async {
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
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
