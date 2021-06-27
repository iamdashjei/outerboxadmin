import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseGoogleApi {
  static Future<String> uploadImage(String path, File file) async {
    final ref = FirebaseStorage.instance.ref(path);
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() {});

    return await ref.getDownloadURL();
  }

  static Future<String> uploadVideo(String path, File file) async {
    final ref = FirebaseStorage.instance.ref(path);
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() {});

    return await ref.getDownloadURL();
  }
}
