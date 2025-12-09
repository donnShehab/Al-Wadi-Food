import 'package:alwadi_food/presentation/auth/domain/entites/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ProductionState extends Equatable {
  const ProductionState();

  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية قبل أي عملية
class ProductionInitial extends ProductionState {
  const ProductionInitial();
}

/// الحالة عند انتظار استجابة من Repository
class ProductionLoading extends ProductionState {
  const ProductionLoading();
}

/// الحالة عند تحميل قائمة الـ Batches بنجاح
class ProductionBatchesLoaded extends ProductionState {
  final List<ProductionBatchEntity> batches;

  const ProductionBatchesLoaded(this.batches);

  @override
  List<Object?> get props => [batches];
}

/// الحالة عند تحميل Batch واحد بنجاح
class ProductionBatchLoaded extends ProductionState {
  final ProductionBatchEntity batch;

  const ProductionBatchLoaded(this.batch);

  @override
  List<Object?> get props => [batch];
}

/// الحالة عند نجاح عملية مثل إنشاء Batch أو تحديث الحالة
class ProductionSuccess extends ProductionState {
  final String message;

  const ProductionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// الحالة عند حدوث خطأ
class ProductionError extends ProductionState {
  final String message;

  const ProductionError(this.message);

  @override
  List<Object?> get props => [message];
}
