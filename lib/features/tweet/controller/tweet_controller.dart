import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/models.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final tweetImagePreviewProvider =
    FutureProvider.family((ref, String imageId) async {
  final storageProvider = ref.watch(appwriteStorageProvider);
  return storageProvider.getFilePreview(
    bucketId: AppwriteConstants.imagesBucket,
    fileId: imageId,
    quality: 25,
  );
});

final getLatestTweetProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<TweetModel>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => TweetModel.fromMap(tweet.data)).toList();
  }

  Future<void> likeTweet(TweetModel tweetModel, UserModel currentUser) async {
    List<String> likes = tweetModel.likes;

    if (likes.contains(currentUser.uid)) {
      likes.remove(currentUser.uid);
    } else {
      likes.add(currentUser.uid);
    }
    tweetModel = tweetModel.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweetModel);

    // TODO: show snackbar when have a failure
    res.fold((l) => print(l), (r) => null);
  }

  Future<void> reshareTweet(
    BuildContext context,
    TweetModel tweetModel,
    UserModel currentUser,
  ) async {
    tweetModel = tweetModel.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweetModel.reshareCount + 1,
    );

    final res = await _tweetAPI.updateReshareCount(tweetModel);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        // share the new tweet with the current user
        tweetModel = tweetModel.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          tweetedAt: DateTime.now(),
        );
        final res2 = await _tweetAPI.shareTweet(tweetModel);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, 'Retweeted!'),
        );
      },
    );
  }

  void shareTweet({
    required BuildContext context,
    required String text,
    required List<File> images,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text.');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(context: context, text: text, images: images);
    } else {
      _shareTextTweet(context: context, text: text);
    }
  }

  Future<void> _shareImageTweet({
    required BuildContext context,
    required String text,
    required List<File> images,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;

    final imageIds = await _storageAPI.uploadImagesToId(images);
    TweetModel tweet = TweetModel(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      imageIds: imageIds,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
    );

    final res = await _tweetAPI.shareTweet(tweet);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
    state = false;
  }

  Future<void> _shareTextTweet({
    required BuildContext context,
    required String text,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;

    TweetModel tweet = TweetModel(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      imageIds: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
    );

    final res = await _tweetAPI.shareTweet(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
    state = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('http://') ||
          word.startsWith('https://') ||
          word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
