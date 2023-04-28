import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImagesToUrl(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile(path: file.path),
      );
      imageLinks.add(AppwriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }

  Future<List<String>> uploadImagesToId(List<File> files) async {
    List<String> imageIds = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile(path: file.path),
      );
      imageIds.add(uploadedImage.$id);
    }
    return imageIds;
  }
}
