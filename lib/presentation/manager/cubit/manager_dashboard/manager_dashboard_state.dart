import 'package:alwadi_food/presentation/manager/domain/entities/manager_dashboard_entity.dart';

abstract class ManagerDashboardState {}

class ManagerDashboardInitial extends ManagerDashboardState {}

class ManagerDashboardLoading extends ManagerDashboardState {}

class ManagerDashboardLoaded extends ManagerDashboardState {
  final ManagerDashboardEntity data;

  ManagerDashboardLoaded(this.data);
}

class ManagerDashboardError extends ManagerDashboardState {
  final String message;

  ManagerDashboardError(this.message);
}
