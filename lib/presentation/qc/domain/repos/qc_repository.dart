import 'dart:io';
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:dart_either/dart_either.dart';
import '../entites/qc_result_entity.dart';

abstract class QCRepository {
  Future<Either<Failure, QCResultEntity>> createQCResult(
    QCResultEntity qcResult,
    List<File> images,
  );

  Future<Either<Failure, QCResultEntity>> getQCResultById(String inspectionId);

  Future<Either<Failure, List<QCResultEntity>>> getQCResultsByBatchId(
    String batchId,
  );

  Future<Either<Failure, List<QCResultEntity>>> getAllQCResults();
}
