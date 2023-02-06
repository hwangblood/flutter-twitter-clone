enum TweetType {
  text('text'),
  image('image');

  final String type;

  const TweetType(this.type);
}

// 'text'.toTweetType() , return a TweetType.text
// 'image'.toTweetType() , return a TweetType.image
extension ConvertTweet on String {
  TweetType toTweetType() {
    switch (this) {
      case 'text':
        return TweetType.text;
      case 'image':
        return TweetType.image;
      default:
        return TweetType.text;
    }
  }
}
