part of 'tickets_cubit.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object?> get props => [];
}

class TicketsInitial extends TicketsState {
  const TicketsInitial();
}

class TicketsLoading extends TicketsState {
  const TicketsLoading();
}

class TicketsSuccess extends TicketsState {
  final bool isAdminView;
  final AdminTicketsData? adminData;
  final EmployeeTicketsData? employeeData;

  const TicketsSuccess.admin(this.adminData)
      : isAdminView = true,
        employeeData = null;

  const TicketsSuccess.employee(this.employeeData)
      : isAdminView = false,
        adminData = null;

  @override
  List<Object?> get props => [isAdminView, adminData, employeeData];
}

class TicketsError extends TicketsState {
  final String message;

  const TicketsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Data classes for both views
class AdminTicketsData extends Equatable {
  final List<Map<String, dynamic>> allTickets;
  final List<Map<String, dynamic>> filteredTickets;
  final int totalCount;
  final int openCount;
  final int inProgressCount;
  final int resolvedCount;
  final int criticalCount;

  const AdminTicketsData({
    required this.allTickets,
    required this.filteredTickets,
    required this.totalCount,
    required this.openCount,
    required this.inProgressCount,
    required this.resolvedCount,
    required this.criticalCount,
  });

  @override
  List<Object?> get props => [
        allTickets,
        filteredTickets,
        totalCount,
        openCount,
        inProgressCount,
        resolvedCount,
        criticalCount,
      ];
}

class EmployeeTicketsData extends Equatable {
  final List<Map<String, dynamic>> tickets;
  final List<int> filterCounts;
  final int selectedFilterIndex;

  const EmployeeTicketsData({
    required this.tickets,
    required this.filterCounts,
    required this.selectedFilterIndex,
  });

  @override
  List<Object?> get props => [tickets, filterCounts, selectedFilterIndex];
}
