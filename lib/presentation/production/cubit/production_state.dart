import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ProductionState extends Equatable {
  const ProductionState();

  @override
  List<Object?> get props => [];
}

class ProductionInitial extends ProductionState {
  const ProductionInitial();
}

class ProductionLoading extends ProductionState {
  const ProductionLoading();
}

class ProductionBatchesLoaded extends ProductionState {
  final List<ProductionBatchEntity> batches;

  const ProductionBatchesLoaded(this.batches);

  @override
  List<Object?> get props => [batches];
}

class ProductionBatchLoaded extends ProductionState {
  final ProductionBatchEntity batch;

  const ProductionBatchLoaded(this.batch);

  @override
  List<Object?> get props => [batch];
}

class ProductionSuccess extends ProductionState {
  final String message;

  const ProductionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductionError extends ProductionState {
  final String message;

  const ProductionError(this.message);

  @override
  List<Object?> get props => [message];
}
