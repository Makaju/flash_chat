import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
      String filePath,
      String fileName,
      ) async {
    File file = File(filePath);
    try {
      await storage.ref('profile_pictures/$fileName.jpg').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      log(e.toString());
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result = await storage.ref('profile_picrures').listAll();
    for (var ref in result.items) {log('found file $ref'); }
    return result;
  }
  Future<String> downloadURL(String imageName) async {
    String downloadURL= await storage.ref('profile_pictures/$imageName').getDownloadURL();
    return downloadURL;
  }
  //for message
  Future<void> uploadMessageFile(
      String filePath,
      String fileName,
      ) async {
    File file = File(filePath);
    try {
      await storage.ref('message_images/$fileName.jpg').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      log(e.toString());
    }
  }
  Future<firebase_storage.ListResult> listFilesForMessage() async {
    firebase_storage.ListResult result = await storage.ref('profile_picrures').listAll();
    for (var ref in result.items) {log('found file $ref'); }
    return result;
  }
  Future<String> downloadURLForMessage(String imageName) async {
    String downloadURL= await storage.ref('message_images/$imageName').getDownloadURL();
    return downloadURL;
  }

}
