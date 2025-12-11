import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get collection reference
  CollectionReference collection(String path) => _firestore.collection(path);

  // Create new document in collection
  Future<void> createDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } catch (e) {
      debugPrint('FirestoreService.createDocument error: $e');
      rethrow;
    }
  }

  // set document in collection
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } catch (e) {
      debugPrint('FirestoreService.setDocument error: $e');
      rethrow;
    }
  }

  // Update document in collection
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      debugPrint('FirestoreService.updateDocument error: $e');
      rethrow;
    }
  }

  // Delete document from collection
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      debugPrint('FirestoreService.deleteDocument error: $e');
      rethrow;
    }
  }

  // Get one document by ID
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      debugPrint('FirestoreService.getDocument error: $e');
      rethrow;
    }
  }

  // Get collection stream From the query results for real-time updates
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    try {
      return _firestore.collection(collection).snapshots();
    } catch (e) {
      debugPrint('FirestoreService.getCollectionStream error: $e');
      rethrow;
    }
  }

  // Get document stream From the document for real-time updates
  Stream<DocumentSnapshot> getDocumentStream(String collection, String docId) {
    try {
      return _firestore.collection(collection).doc(docId).snapshots();
    } catch (e) {
      debugPrint('FirestoreService.getDocumentStream error: $e');
      rethrow;
    }
  }

  // Performing a complex query on a collection (filtering, sorting, specifying a number)
  Future<QuerySnapshot> queryCollection(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      if (filters != null) {
        for (var filter in filters) {
          query = query.where(
            filter.field,
            isEqualTo: filter.isEqualTo,
            isNotEqualTo: filter.isNotEqualTo,
            isGreaterThan: filter.isGreaterThan,
            isLessThan: filter.isLessThan,
            arrayContains: filter.arrayContains,
          );
        }
      }
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      if (limit != null) {
        query = query.limit(limit);
      }
      return await query.get();
    } catch (e) {
      debugPrint('FirestoreService.queryCollection error: $e');
      rethrow;
    }
  }

  // Query collection stream
  Stream<QuerySnapshot> queryCollectionStream(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    try {
      Query query = _firestore.collection(collection);
      if (filters != null) {
        for (var filter in filters) {
          query = query.where(
            filter.field,
            isEqualTo: filter.isEqualTo,
            isNotEqualTo: filter.isNotEqualTo,
            isGreaterThan: filter.isGreaterThan,
            isLessThan: filter.isLessThan,
            arrayContains: filter.arrayContains,
          );
        }
      }
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      if (limit != null) {
        query = query.limit(limit);
      }
      return query.snapshots();
    } catch (e) {
      debugPrint('FirestoreService.queryCollectionStream error: $e');
      rethrow;
    }
  }
}

class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isNotEqualTo;
  final dynamic isGreaterThan;
  final dynamic isLessThan;
  final dynamic arrayContains;

  QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isGreaterThan,
    this.isLessThan,
    this.arrayContains,
  });
}
