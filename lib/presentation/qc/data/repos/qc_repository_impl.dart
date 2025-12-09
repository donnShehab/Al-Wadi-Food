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
      final imageUrls = images.isEmpty
          ? <String>[]
          : await _storageService.uploadFiles(
              '${AppConstants.qcImagesPath}/${qcResult.inspectionId}',
              images,
            );

      final qcModel = QCResultModel.fromEntity(
        qcResult,
      ).copyWith(images: imageUrls);

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
      if (!doc.exists) return Left(ServerFailure(message: 'QC Result not found'));
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
