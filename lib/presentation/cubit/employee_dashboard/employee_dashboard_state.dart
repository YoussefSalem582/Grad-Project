part of 'employee_dashboard_cubit.dart';

abstract class EmployeeDashboardState extends Equatable {
  const EmployeeDashboardState();

  @override
  List<Object?> get props => [];
}

class EmployeeDashboardInitial extends EmployeeDashboardState {
  const EmployeeDashboardInitial();
}

class EmployeeDashboardLoading extends EmployeeDashboardState {
  const EmployeeDashboardLoading();
}

class EmployeeDashboardSuccess extends EmployeeDashboardState {
  final EmployeeDashboardData data;

  const EmployeeDashboardSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeeDashboardError extends EmployeeDashboardState {
  final String message;

  const EmployeeDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeeDashboardData extends Equatable {
  final int ticketsResolved;
  final int activeTickets;
  final double customerSatisfaction;
  final int efficiencyScore;
  final List<Map<String, dynamic>> recentTickets;
  final List<Map<String, dynamic>> quickStats;

  const EmployeeDashboardData({
    required this.ticketsResolved,
    required this.activeTickets,
    required this.customerSatisfaction,
    required this.efficiencyScore,
    required this.recentTickets,
    required this.quickStats,
  });

  @override
  List<Object?> get props => [
    ticketsResolved,
    activeTickets,
    customerSatisfaction,
    efficiencyScore,
    recentTickets,
    quickStats,
  ];
}
