import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'qc_batch_review_state.dart';

class QCBatchReviewCubit extends Cubit<QCBatchReviewState> {
  final ProductionRepository _productionRepository;

  QCBatchReviewCubit(this._productionRepository)
    : super(QCBatchReviewInitial());

  Future<void> loadBatch(String batchId) async {
    emit(QCBatchReviewLoading());

    final result = await _productionRepository.getBatchById(batchId);

    result.fold(
      ifLeft: (failure) => emit(QCBatchReviewError(failure)),
      ifRight: (batch) => emit(QCBatchReviewLoaded(batch)),
    );
  }
}
