part of 'employee_tickets_cubit.dart';

abstract class EmployeeTicketsState extends Equatable {
  const EmployeeTicketsState();

  @override
  List<Object?> get props => [];
}

class EmployeeTicketsInitial extends EmployeeTicketsState {
  const EmployeeTicketsInitial();
}

class EmployeeTicketsLoading extends EmployeeTicketsState {
  const EmployeeTicketsLoading();
}

class EmployeeTicketsSuccess extends EmployeeTicketsState {
  final EmployeeTicketsData data;

  const EmployeeTicketsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeeTicketsError extends EmployeeTicketsState {
  final String message;

  const EmployeeTicketsError(this.message);

  @override
  List<Object?> get props => [message];
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
