import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String getNameFromEmail(String email) {
  return email.split('@').first;
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final pickedFiles = await picker.pickMultiImage();
  if (pickedFiles.isNotEmpty) {
    for (var file in pickedFiles) {
      images.add(File(file.path));
    }
  }

  return images;
}
