import 'dart:developer';
import 'dart:io';
import 'package:alwadi_food/presentation/auth/data/services/firestore_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/storage_service.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/production/data/models/production_batch_model.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:dart_either/dart_either.dart';

class ProductionRepositoryImpl implements ProductionRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  ProductionRepositoryImpl(this._firestoreService, this._storageService);

  @override
  Future<Either<String, ProductionBatchEntity>> createBatch(
    ProductionBatchEntity batch,
    List<File> images,
  ) async {
    try {
      final imageUrls = await _storageService.uploadFiles(
        '${AppConstants.batchImagesPath}/${batch.batchId}',
        images,
      );
      final batchModel = ProductionBatchModel.fromEntity(
        batch,
      ).copyWith(images: imageUrls);
      await _firestoreService.createDocument(
        AppConstants.batchesCollection,
        batch.batchId,
        batchModel.toJson(),
      );
      return Right(batchModel);
    } catch (e) {
      log('createBatch error: $e');
      return Left('Failed to create batch: $e');
    }
  }

@override
  Future<Either<String, void>> deleteBatch(String batchId) async {
    try {
      await _firestoreService.deleteDocument(
        AppConstants.batchesCollection,
        batchId,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete batch');
    }
  }

  @override
  Future<Either<String, ProductionBatchEntity>> getBatchById(
    String batchId,
  ) async {
    try {
      final doc = await _firestoreService.getDocument(
        AppConstants.batchesCollection,
        batchId,
      );
      if (!doc.exists) return Left('Batch not found');
      return Right(
        ProductionBatchModel.fromJson(doc.data() as Map<String, dynamic>),
      );
    } catch (e) {
      debugPrint('getBatchById error: $e');
      return Left('Failed to load batch: $e');
    }
  }

  @override
  Future<Either<String, List<ProductionBatchEntity>>> getAllBatches() async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.batchesCollection,
        orderBy: 'createdAt',
        descending: true,
      );
      final batches = snapshot.docs
          .map(
            (doc) => ProductionBatchModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      return Right(batches);
    } catch (e) {
      debugPrint('getAllBatches error: $e');
      return Left('Failed to load batches: $e');
    }
  }

  @override
  Future<Either<String, List<ProductionBatchEntity>>> getBatchesByStatus(
    String status,
  ) async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.batchesCollection,
        filters: [QueryFilter(field: 'status', isEqualTo: status)],
        orderBy: 'createdAt',
        descending: true,
      );
      final batches = snapshot.docs
          .map(
            (doc) => ProductionBatchModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      return Right(batches);
    } catch (e) {
      debugPrint('getBatchesByStatus error: $e');
      return Left('Failed to load batches by status: $e');
    }
  }

  @override
  Future<Either<String, void>> updateBatchStatus(
    String batchId,
    String status,
  ) async {
    try {
      await _firestoreService.updateDocument(
        AppConstants.batchesCollection,
        batchId,
        {'status': status, 'updatedAt': DateTime.now()},
      );
      return const Right(null);
    } catch (e) {
      debugPrint('updateBatchStatus error: $e');
      return Left('Failed to update batch status: $e');
    }
  }

  @override
  Future<Either<String, void>> updateBatch(ProductionBatchEntity batch) async {
    try {
      final batchModel = ProductionBatchModel.fromEntity(batch);
      await _firestoreService.updateDocument(
        AppConstants.batchesCollection,
        batch.batchId,
        batchModel.toJson(),
      );
      return const Right(null);
    } catch (e) {
      debugPrint('updateBatch error: $e');
      return Left('Failed to update batch: $e');
    }
  }

  @override
  Stream<List<ProductionBatchEntity>> getBatchesStream() {
    return _firestoreService
        .queryCollectionStream(
          AppConstants.batchesCollection,
          orderBy: 'createdAt',
          descending: true,
        )
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProductionBatchModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<ProductionBatchEntity>> getBatchesByStatusStream(String status) {
    return _firestoreService
        .queryCollectionStream(
          AppConstants.batchesCollection,
          filters: [QueryFilter(field: 'status', isEqualTo: status)],
          orderBy: 'createdAt',
          descending: true,
        )
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProductionBatchModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
  
  @override
  Future<int> getTotalBatchesCount() async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.batchesCollection,
      );
      return snapshot.docs.length;
    } catch (e) {
      debugPrint('getTotalBatchesCount error: $e');
      return 0;
    }
  }

  @override
  Future<int> getPassedQCount() async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.batchesCollection,
        filters: [
          QueryFilter(field: 'status', isEqualTo: AppConstants.statusPassed),
        ],
      );
      return snapshot.docs.length;
    } catch (e) {
      debugPrint('getPassedQCount error: $e');
      return 0;
    }
  }

  @override
  Future<int> getIssuesCount() async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.batchesCollection,
        filters: [
          QueryFilter(field: 'status', isEqualTo: AppConstants.statusFailed),
        ],
      );
      return snapshot.docs.length;
    } catch (e) {
      debugPrint('getIssuesCount error: $e');
      return 0;
    }
  }
}
