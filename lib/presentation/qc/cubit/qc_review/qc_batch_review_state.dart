import 'package:equatable/equatable.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';

sealed class QCBatchReviewState extends Equatable {
  const QCBatchReviewState();

  @override
  List<Object?> get props => [];
}

class QCBatchReviewInitial extends QCBatchReviewState {}

class QCBatchReviewLoading extends QCBatchReviewState {}

class QCBatchReviewLoaded extends QCBatchReviewState {
  final ProductionBatchEntity batch;

  const QCBatchReviewLoaded(this.batch);

  @override
  List<Object?> get props => [batch];
}

class QCBatchReviewError extends QCBatchReviewState {
  final String message;

  const QCBatchReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
