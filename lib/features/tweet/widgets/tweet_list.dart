import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/pallete.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    if (data.events
                        .contains(AppwriteConstants.tweetCreateEvent)) {
                      tweets.insert(
                        0,
                        TweetModel.fromMap(data.payload),
                      );
                    }
                    return ListView.separated(
                      itemCount: tweets.length,
                      itemBuilder: ((context, index) {
                        final tweet = tweets.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TweetCard(tweet: tweet),
                        );
                      }),
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: Pallete.greyColor,
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    // there shouldn't be a Loader
                    // when haven't latest tweet create, just display the
                    // already haved tweets
                    return ListView.separated(
                      itemCount: tweets.length,
                      itemBuilder: ((context, index) {
                        final tweet = tweets.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TweetCard(tweet: tweet),
                        );
                      }),
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: Pallete.greyColor,
                        );
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
