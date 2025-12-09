import 'package:alwadi_food/presentation/auth/domain/entites/production_batch_entity.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:equatable/equatable.dart';

sealed class TraceabilityState extends Equatable {
  const TraceabilityState();

  @override
  List<Object?> get props => [];
}

class TraceabilityInitial extends TraceabilityState {
  const TraceabilityInitial();
}

class TraceabilityLoading extends TraceabilityState {
  const TraceabilityLoading();
}

class TraceabilityLoaded extends TraceabilityState {
  final ProductionBatchEntity batch;
  final List<QCResultEntity> qcResults;

  const TraceabilityLoaded(this.batch, this.qcResults);

  @override
  List<Object?> get props => [batch, qcResults];
}

class TraceabilityError extends TraceabilityState {
  final String message;

  const TraceabilityError(this.message);

  @override
  List<Object?> get props => [message];
}
