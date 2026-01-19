import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/trace_audit_entity.dart';
import '../../domain/repos/trace_audit_repository.dart';

part 'audit_history_state.dart';

class AuditHistoryCubit extends Cubit<AuditHistoryState> {
  final TraceAuditRepository repository;

  AuditHistoryCubit(this.repository) : super(AuditHistoryInitial());

  Future<void> loadAudits() async {
    emit(AuditHistoryLoading());

    try {
      final audits = await repository.fetchAudits();
      emit(AuditHistoryLoaded(audits));
    } catch (e) {
      emit(AuditHistoryError(e.toString()));
    }
  }
}
