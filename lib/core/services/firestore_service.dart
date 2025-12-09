// import 'package:alwadi_food/core/services/database_service.dart';
// import 'package:alwadi_food/feature/auth/data/models/user_model.dart';
// import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService implements DatabaseService {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   @override
//   Future<void> addData({
//     required String path,
//     required Map<String, dynamic> data,
//     String? documentId,
//   }) async {
//     if (documentId != null) {
//       firestore.collection(path).doc(documentId);
//     } else {
//       await firestore.collection(path).add(data);
//     }
//   }

//   @override
//   Future<Map<String, dynamic>> getData({
//     required String path,
//     required String documentId,
//   }) async {
//     var data = await firestore.collection(path).doc(documentId).get();
//     return data.data() as Map<String, dynamic>;
//   }

//   Future<bool> checkIfDataExists({
//     required String path,
//     required String documentId,
//   }) async {
//     var data = await firestore.collection(path).doc(documentId).get();
//     return data.exists;
//   }
// }
