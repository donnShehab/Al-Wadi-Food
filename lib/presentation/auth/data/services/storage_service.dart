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

  // ✅ Upload multiple files (returns list of URLs)
  Future<List<String>> uploadFiles(String basePath, List<File> files) async {
    try {
      final urls = <String>[];

      for (var i = 0; i < files.length; i++) {
        final file = files[i];

        // ✅ حاول نجيب extension الحقيقي
        final ext = _getFileExtension(file.path); // مثل jpg / png
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.$ext';

        final url = await uploadFile('$basePath/$fileName', file);
        urls.add(url);
      }

      return urls;
    } catch (e) {
      debugPrint('StorageService.uploadFiles error: $e');
      rethrow;
    }
  }

  // ✅ Upload PDF bytes
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

  // ✅ helper
  String _getFileExtension(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'png';
    if (lower.endsWith('.jpeg')) return 'jpeg';
    if (lower.endsWith('.jpg')) return 'jpg';
    if (lower.endsWith('.webp')) return 'webp';
    return 'jpg'; // default
  }
}
