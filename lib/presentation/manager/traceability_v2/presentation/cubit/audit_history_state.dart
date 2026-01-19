part of 'audit_history_cubit.dart';


abstract class AuditHistoryState {}

class AuditHistoryInitial extends AuditHistoryState {}

class AuditHistoryLoading extends AuditHistoryState {}

class AuditHistoryLoaded extends AuditHistoryState {
  final List<TraceAuditEntity> audits;
  AuditHistoryLoaded(this.audits);
}

class AuditHistoryError extends AuditHistoryState {
  final String message;
  AuditHistoryError(this.message);
}
