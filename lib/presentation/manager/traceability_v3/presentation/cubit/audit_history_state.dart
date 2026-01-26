import 'package:equatable/equatable.dart';
import '../../domain/models/recall_audit_model.dart';

abstract class AuditHistoryState extends Equatable {
  const AuditHistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial idle state
class AuditHistoryInitial extends AuditHistoryState {}

/// Loading audits from repository
class AuditHistoryLoading extends AuditHistoryState {}

/// Successfully loaded audits
class AuditHistoryLoaded extends AuditHistoryState {
  final List<RecallAuditModel> audits;

  const AuditHistoryLoaded(this.audits);

  @override
  List<Object?> get props => [audits];
}

/// Error while loading audits
class AuditHistoryError extends AuditHistoryState {
  final String message;

  const AuditHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
