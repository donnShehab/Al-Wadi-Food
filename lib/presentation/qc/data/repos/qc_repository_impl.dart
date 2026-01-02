import 'dart:io';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/presentation/auth/data/services/firestore_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/storage_service.dart';
import 'package:dart_either/dart_either.dart';
import '../../domain/entites/qc_result_entity.dart';
import '../../domain/repos/qc_repository.dart';
import '../models/qc_result_model.dart';
import 'package:flutter/foundation.dart';

class QCRepositoryImpl implements QCRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  QCRepositoryImpl(this._firestoreService, this._storageService);
  @override
  Future<Either<Failure, QCResultEntity>> createQCResult(
    QCResultEntity qcResult,
    List<File> images,
  ) async {
    try {
      /// ✅ 1) Upload QC images
      final imageUrls = images.isEmpty
          ? <String>[]
          : await _storageService.uploadFiles(
              '${AppConstants.qcImagesPath}/${qcResult.inspectionId}',
              images,
            );

      /// ✅ 2) Fetch Batch to extract productType + line + batch images
      final batchDoc = await _firestoreService.getDocument(
        AppConstants.batchesCollection,
        qcResult.batchId,
      );

      final batchData = batchDoc.data() as Map<String, dynamic>?;

      /// ✅ FIX: Support productType OR product
      final productType =
          batchData?["productType"] ??
          batchData?["product"] ??
          "Unknown Product";

      final line = batchData?["line"] ?? qcResult.productionLine;

      final batchImages =
          (batchData?["images"] as List?)?.cast<String>() ?? <String>[];

      /// ✅ 3) Build QC model
      final qcModel = QCResultModel.fromEntity(qcResult).copyWith(
        images: imageUrls,
        productType: productType.toString(),
        line: line.toString(),
        batchImages: batchImages,
      );

      /// ✅ 4) Save
      await _firestoreService.createDocument(
        AppConstants.qcResultsCollection,
        qcResult.inspectionId,
        qcModel.toJson(),
      );

      return Right(qcModel);
    } catch (e) {
      debugPrint('QCRepositoryImpl.createQCResult error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<Failure, QCResultEntity>> getQCResultById(
    String inspectionId,
  ) async {
    try {
      final doc = await _firestoreService.getDocument(
        AppConstants.qcResultsCollection,
        inspectionId,
      );
      if (!doc.exists)
        return Left(ServerFailure(message: 'QC Result not found'));
      return Right(QCResultModel.fromJson(doc.data() as Map<String, dynamic>));
    } catch (e) {
      debugPrint('QCRepositoryImpl.getQCResultById error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QCResultEntity>>> getQCResultsByBatchId(
    String batchId,
  ) async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.qcResultsCollection,
        filters: [QueryFilter(field: 'batchId', isEqualTo: batchId)],
        orderBy: 'createdAt',
        descending: true,
      );
      final results = snapshot.docs
          .map(
            (doc) => QCResultModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      return Right(results);
    } catch (e) {
      debugPrint('QCRepositoryImpl.getQCResultsByBatchId error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QCResultEntity>>> getAllQCResults() async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.qcResultsCollection,
        orderBy: 'createdAt',
        descending: true,
      );
      final results = snapshot.docs
          .map(
            (doc) => QCResultModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      return Right(results);
    } catch (e) {
      debugPrint('QCRepositoryImpl.getAllQCResults error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
