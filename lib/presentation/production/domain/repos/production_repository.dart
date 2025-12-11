import 'dart:io';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class ProductionRepository {
  // create new batch and upload images to storage
  Future<Either<String, ProductionBatchEntity>> createBatch(
    ProductionBatchEntity batch,
    List<File> images,
  );
  // get batch by id
  Future<Either<String, ProductionBatchEntity>> getBatchById(String batchId);
  // get all batches
  Future<Either<String, List<ProductionBatchEntity>>> getAllBatches();
  // get batch by status like 'in-progress', 'completed'
  Future<Either<String, List<ProductionBatchEntity>>> getBatchesByStatus(
    String status,
  );
  // update batch status
  Future<Either<String, void>> updateBatchStatus(String batchId, String status);
  // update all batch
  Future<Either<String, void>> updateBatch(ProductionBatchEntity batch);
  // Returning a stream of all payments, allowing the user interface to be updated in real time when a change occurs in the database.
  Stream<List<ProductionBatchEntity>> getBatchesStream();
  // Return a flow of payments based on a specific condition.
  Stream<List<ProductionBatchEntity>> getBatchesByStatusStream(String status);
}
