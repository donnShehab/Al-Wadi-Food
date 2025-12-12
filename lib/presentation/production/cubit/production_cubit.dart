import 'dart:io';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductionCubit extends Cubit<ProductionState> {
  final ProductionRepository _productionRepository;
  final AuthRepository _authRepository;

  ProductionCubit(this._productionRepository, this._authRepository)
    : super(const ProductionInitial());

  /// إنشاء Batch جديد مع رفع الصور
  Future<void> createBatch(
    ProductionBatchEntity batch,
    List<File> images,
  ) async {
    emit(const ProductionLoading());
    final result = await _productionRepository.createBatch(batch, images);
    result.fold(
      ifLeft: (error) => emit(ProductionError(error)),
      ifRight: (batch) =>
          emit(const ProductionSuccess('Batch created successfully')),
    );
  }

  /// جلب كل الـ Batches
  Future<void> loadAllBatches() async {
    emit(const ProductionLoading());
    final result = await _productionRepository.getAllBatches();
    result.fold(
      ifLeft: (error) => emit(ProductionError(error)),
      ifRight: (batches) => emit(ProductionBatchesLoaded(batches)),
    );
  }

  /// جلب Batches حسب Status
  Future<void> loadBatchesByStatus(String status) async {
    emit(const ProductionLoading());
    final result = await _productionRepository.getBatchesByStatus(status);
    result.fold(
      ifLeft: (error) => emit(ProductionError(error)),
      ifRight: (batches) => emit(ProductionBatchesLoaded(batches)),
    );
  }

  /// جلب Batch واحد حسب الـ ID
  Future<void> loadBatchById(String batchId) async {
    emit(const ProductionLoading());
    final result = await _productionRepository.getBatchById(batchId);
    result.fold(
      ifLeft: (error) => emit(ProductionError(error)),
      ifRight: (batch) => emit(ProductionBatchLoaded(batch)),
    );
  }

  /// إرسال Batch إلى QC
  Future<void> sendToQC(String batchId) async {
    emit(const ProductionLoading());
    final result = await _productionRepository.updateBatchStatus(
      batchId,
      'waiting_qc',
    );
    result.fold(
      ifLeft: (error) => emit(ProductionError(error)),
      ifRight: (_) => emit(const ProductionSuccess('Batch sent to QC')),
    );
  }

  /// الاستماع للتحديثات الحية لجميع الـ Batches
  void listenToBatchesStream() {
    _productionRepository.getBatchesStream().listen(
      (batches) => emit(ProductionBatchesLoaded(batches)),
      onError: (e) {
        debugPrint('ProductionCubit.listenToBatchesStream error: $e');
        emit(ProductionError(e.toString()));
      },
    );
  }

  /// الاستماع للتحديثات الحية للـ Batches حسب Status
  void listenToBatchesByStatusStream(String status) {
    _productionRepository
        .getBatchesByStatusStream(status)
        .listen(
          (batches) => emit(ProductionBatchesLoaded(batches)),
          onError: (e) {
            debugPrint(
              'ProductionCubit.listenToBatchesByStatusStream error: $e',
            );
            emit(ProductionError(e.toString()));
          },
        );
  }


}
