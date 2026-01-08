import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_batch_qc_history_ds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_batch_qc_history_state.dart';

class ManagerBatchQcHistoryCubit extends Cubit<ManagerBatchQcHistoryState> {
  final ManagerBatchQcHistoryFirestoreDs ds;

  ManagerBatchQcHistoryCubit(this.ds) : super(ManagerBatchQcHistoryInitial());

  Future<void> load(String batchId) async {
    emit(ManagerBatchQcHistoryLoading());
    try {
      final data = await ds.fetchQcHistoryForBatch(batchId);
      emit(ManagerBatchQcHistoryLoaded(data));
    } catch (e) {
      emit(ManagerBatchQcHistoryError("Failed to load QC history"));
    }
  }
}
