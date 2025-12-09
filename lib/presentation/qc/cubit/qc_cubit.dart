import 'dart:io';
import 'package:alwadi_food/presentation/auth/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/qc_repository.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'qc_state.dart';

class QCCubit extends Cubit<QCState> {
  final QCRepository _qcRepository;
  final ProductionRepository _productionRepository;
  final AuthRepository _authRepository;

  QCCubit(this._qcRepository, this._productionRepository, this._authRepository)
    : super(const QCInitial());

  Future<void> createQCResult(
    QCResultEntity qcResult,
    List<File> images,
    String batchId,
    String newStatus,
  ) async {
    emit(const QCLoading());
    final result = await _qcRepository.createQCResult(qcResult, images);

    result.fold(
      ifLeft: 
      (failure) => emit(QCError(failure.message)),
      ifRight: 
       (_) async {
      await _productionRepository.updateBatchStatus(batchId, newStatus);
      emit(const QCSuccess('QC inspection completed'));
    });
  }

  Future<void> loadQCResultsByBatchId(String batchId) async {
    emit(const QCLoading());
    final result = await _qcRepository.getQCResultsByBatchId(batchId);

    result.fold(
      ifLeft: 
      (failure) => emit(QCError(failure.message)),
      ifRight: 
      (results) => emit(QCResultsLoaded(results)),
    );
  }
Future<void> loadPendingBatches() async {
    emit(const QCLoading());

    final result = await _productionRepository.getBatchesByStatus('pending');

    result.fold(
      ifLeft: (failure) => emit(QCError(failure)),
      ifRight: (batches) => emit(QCPendingBatchesLoaded(batches)),
    );
  }


  Future<void> loadAllQCResults() async {
    emit(const QCLoading());
    final result = await _qcRepository.getAllQCResults();

    result.fold(
      ifLeft: 
      (failure) => emit(QCError(failure.message)),
      ifRight: 
      
      (results) => emit(QCResultsLoaded(results)),
    );
  }
}
