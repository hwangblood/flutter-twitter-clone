import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class _TweetAPI {
  FutureEither<models.Document> shareTweet(TweetModel tweetModel);

  Future<List<models.Document>> getTweets();
}

class TweetAPI implements _TweetAPI {
  TweetAPI({required Databases db}) : _db = db;

  final Databases _db;
  @override
  FutureEither<models.Document> shareTweet(TweetModel tweetModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweetModel.toMap(),
      );
      return right(document);
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
  Future<List<models.Document>> getTweets() async {
    final documentList = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
    );

    return documentList.documents;
  }
}
