// import 'dart:io';
// import 'package:alwadi_food/core/constants/app_constants.dart';
// import 'package:alwadi_food/presentation/auth/data/models/qc_result_model.dart';
// import 'package:alwadi_food/presentation/auth/data/services/firestore_service.dart';
// import 'package:alwadi_food/presentation/auth/data/services/storage_service.dart';
// import 'package:alwadi_food/presentation/auth/domain/entites/qc_result_entity.dart';
// import 'package:alwadi_food/presentation/auth/domain/repos/qc_repository.dart';
// import 'package:flutter/foundation.dart';

// class QCRepositoryImpl implements QCRepository {
//   final FirestoreService _firestoreService;
//   final StorageService _storageService;

//   QCRepositoryImpl(this._firestoreService, this._storageService);

//   @override
//   Future<QCResultEntity> createQCResult(
//     QCResultEntity qcResult,
//     List<File> images,
//   ) async {
//     try {
//       final imageUrls = images.isEmpty
//           ? <String>[]
//           : await _storageService.uploadFiles(
//               '${AppConstants.qcImagesPath}/${qcResult.inspectionId}',
//               images,
//             );
//       final qcModel = QCResultModel.fromEntity(
//         qcResult,
//       ).copyWith(images: imageUrls);
//       await _firestoreService.createDocument(
//         AppConstants.qcResultsCollection,
//         qcResult.inspectionId,
//         qcModel.toJson(),
//       );
//       return qcModel;
//     } catch (e) {
//       debugPrint('QCRepositoryImpl.createQCResult error: $e');
//       rethrow;
//     }
//   }

//   @override
//   Future<QCResultEntity> getQCResultById(String inspectionId) async {
//     try {
//       final doc = await _firestoreService.getDocument(
//         AppConstants.qcResultsCollection,
//         inspectionId,
//       );
//       if (!doc.exists) {
//         throw Exception('QC Result not found');
//       }
//       return QCResultModel.fromJson(doc.data() as Map<String, dynamic>);
//     } catch (e) {
//       debugPrint('QCRepositoryImpl.getQCResultById error: $e');
//       rethrow;
//     }
//   }

//   @override
//   Future<List<QCResultEntity>> getQCResultsByBatchId(String batchId) async {
//     try {
//       final snapshot = await _firestoreService.queryCollection(
//         AppConstants.qcResultsCollection,
//         filters: [QueryFilter(field: 'batchId', isEqualTo: batchId)],
//         orderBy: 'createdAt',
//         descending: true,
//       );
//       return snapshot.docs
//           .map(
//             (doc) => QCResultModel.fromJson(doc.data() as Map<String, dynamic>),
//           )
//           .toList();
//     } catch (e) {
//       debugPrint('QCRepositoryImpl.getQCResultsByBatchId error: $e');
//       rethrow;
//     }
//   }

//   @override
//   Future<List<QCResultEntity>> getAllQCResults() async {
//     try {
//       final snapshot = await _firestoreService.queryCollection(
//         AppConstants.qcResultsCollection,
//         orderBy: 'createdAt',
//         descending: true,
//       );
//       return snapshot.docs
//           .map(
//             (doc) => QCResultModel.fromJson(doc.data() as Map<String, dynamic>),
//           )
//           .toList();
//     } catch (e) {
//       debugPrint('QCRepositoryImpl.getAllQCResults error: $e');
//       rethrow;
//     }
//   }

//   @override
//   Stream<List<QCResultEntity>> getQCResultsStream() {
//     try {
//       return _firestoreService
//           .queryCollectionStream(
//             AppConstants.qcResultsCollection,
//             orderBy: 'createdAt',
//             descending: true,
//           )
//           .map(
//             (snapshot) => snapshot.docs
//                 .map(
//                   (doc) => QCResultModel.fromJson(
//                     doc.data() as Map<String, dynamic>,
//                   ),
//                 )
//                 .toList(),
//           );
//     } catch (e) {
//       debugPrint('QCRepositoryImpl.getQCResultsStream error: $e');
//       rethrow;
//     }
//   }

//   @override
//   Stream<List<QCResultEntity>> getQCResultsByBatchIdStream(String batchId) {
//     try {
//       return _firestoreService
//           .queryCollectionStream(
//             AppConstants.qcResultsCollection,
//             filters: [QueryFilter(field: 'batchId', isEqualTo: batchId)],
//             orderBy: 'createdAt',
//             descending: true,
//           )
//           .map(
//             (snapshot) => snapshot.docs
//                 .map(
//                   (doc) => QCResultModel.fromJson(
//                     doc.data() as Map<String, dynamic>,
//                   ),
//                 )
//                 .toList(),
//           );
//     } catch (e) {
//       debugPrint('QCRepositoryImpl.getQCResultsByBatchIdStream error: $e');
//       rethrow;
//     }
//   }
// }
