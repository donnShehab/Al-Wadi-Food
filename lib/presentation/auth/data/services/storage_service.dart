import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload single file
  Future<String> uploadFile(String path, File file) async {
    try {
      // create a ref to the location u want storge the file
      // no impl upload file he Determines the destination

      final ref = _storage.ref().child(path);
      // upload the file
      final uploadTask = await ref.putFile(file);
      // get download url for the uploaded file which will be stored in firestore
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('StorageService.uploadFile error: $e');
      rethrow;
    }
  }

  // *DRY --> Dont Repeat Yourself
  // Upload multiple files
  // upload each file and return list of urls
  // basePath --> folder path in storage
  // files ---> list of files to upload
  Future<List<String>> uploadFiles(String basePath, List<File> files) async {
    try {
      final urls = <String>[];
      // for each file upload and get url
      for (var i = 0; i < files.length; i++) {
        // create unique id for each file
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        // upload file and get url
        final url = await uploadFile('$basePath/$fileName', files[i]);
        // add url to list
        urls.add(url);
      }
      return urls;
    } catch (e) {
      debugPrint('StorageService.uploadFiles error: $e');
      rethrow;
    }
  }

  // Delete file
  Future<void> deleteFile(String url) async {
    try {
      // refFromURL --> gets reference from the full url of the file
      final ref = _storage.refFromURL(url);
      // delete the file
      await ref.delete();
    } catch (e) {
      debugPrint('StorageService.deleteFile error: $e');
      rethrow;
    }
  }

  // Delete multiple files

  Future<void> deleteFiles(List<String> urls) async {
    try {
      // for each url delete the file
      for (var url in urls) {
        // delete the file by url
        await deleteFile(url);
      }
    } catch (e) {
      debugPrint('StorageService.deleteFiles error: $e');
      rethrow;
    }
  }
}
