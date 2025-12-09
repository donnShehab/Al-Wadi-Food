import 'dart:io';
import 'package:alwadi_food/presentation/auth/domain/entites/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class ProductionRepository {
  Future<Either<String, ProductionBatchEntity>> createBatch(
    ProductionBatchEntity batch,
    List<File> images,
  );
  Future<Either<String, ProductionBatchEntity>> getBatchById(String batchId);
  Future<Either<String, List<ProductionBatchEntity>>> getAllBatches();
  Future<Either<String, List<ProductionBatchEntity>>> getBatchesByStatus(
    String status,
  );
  Future<Either<String, void>> updateBatchStatus(String batchId, String status);
  Future<Either<String, void>> updateBatch(ProductionBatchEntity batch);
  Stream<List<ProductionBatchEntity>> getBatchesStream();
  Stream<List<ProductionBatchEntity>> getBatchesByStatusStream(String status);
}
