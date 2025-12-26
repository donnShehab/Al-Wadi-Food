import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload single file
  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('StorageService.uploadFile error: $e');
      rethrow;
    }
  }

  // ✅ NEW: Upload bytes (PDF / reports)
  Future<String> uploadBytes(String path, Uint8List bytes) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putData(
        bytes,
        SettableMetadata(contentType: "application/pdf"),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('StorageService.uploadBytes error: $e');
      rethrow;
    }
  }

  // Upload multiple files
  Future<List<String>> uploadFiles(String basePath, List<File> files) async {
    try {
      final urls = <String>[];
      for (var i = 0; i < files.length; i++) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final url = await uploadFile('$basePath/$fileName', files[i]);
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
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      debugPrint('StorageService.deleteFile error: $e');
      rethrow;
    }
  }

  // Delete multiple files
  Future<void> deleteFiles(List<String> urls) async {
    try {
      for (var url in urls) {
        await deleteFile(url);
      }
    } catch (e) {
      debugPrint('StorageService.deleteFiles error: $e');
      rethrow;
    }
  }
}
