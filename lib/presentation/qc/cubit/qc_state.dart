import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:equatable/equatable.dart';

sealed class QCState extends Equatable {
  const QCState();

  @override
  List<Object?> get props => [];
}

class QCInitial extends QCState {
  const QCInitial();
}

class QCLoading extends QCState {
  const QCLoading();
}

class QCPendingBatchesLoaded extends QCState {
  final List<ProductionBatchEntity> batches;
  const QCPendingBatchesLoaded(this.batches);

  @override
  List<Object?> get props => [batches];
}

class QCResultsLoaded extends QCState {
  final List<QCResultEntity> results;
  const QCResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class QCSuccess extends QCState {
  final String message;
  const QCSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class QCError extends QCState {
  final String message;
  const QCError(this.message);

  @override
  List<Object?> get props => [message];
}
