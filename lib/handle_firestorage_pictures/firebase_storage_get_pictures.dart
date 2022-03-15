import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageGetPictures {
  final String folderName;

  final FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseStorageGetPictures({required this.folderName});

  Future<ListResult> listFiles() async {
    ListResult results = await storage.ref(folderName).listAll();
    results.items.forEach((Reference ref) {
      log(ref.toString());
    });
    return results;
  }

  Future<String> downloarUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('$folderName/$imageName').getDownloadURL();
    return downloadUrl;
  }

  Future<String> downloarUrlOfItem({required String imageName,required String folderPhotoName }) async {
    String downloadUrl =
        await storage.ref('$folderPhotoName/$imageName').getDownloadURL();
    return downloadUrl;
  }
}
