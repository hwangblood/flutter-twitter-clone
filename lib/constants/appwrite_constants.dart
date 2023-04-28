class AppwriteConstants {
  static const String endPoint = 'http://70ab7a0f.r2.vip.cpolar.cn/v1';
  static const String projectId = '63d964ad74bde4f422c9';
  static const String databaseId = '63da1b3f7dd2898dcc37';

  static const String usersCollection = '63db81ba88368ab0b089';
  static const String tweetsCollection = '63dfbcafbc0d1eae2bff';

  static const String imagesBucket = '63e0f940a5278221121e';

  static const tweetCreateEvent = 'databases.*.collections'
      '.${AppwriteConstants.tweetsCollection}.documents.*.create';

  // http://localhost/v1/storage/buckets/63e0f940a5278221121e/files/63e0fb272d21215acf11/view?project=63d964ad74bde4f422c9&mode=admin

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
