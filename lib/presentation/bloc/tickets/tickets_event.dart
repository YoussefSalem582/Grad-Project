part of 'tickets_bloc.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();

  @override
  List<Object?> get props => [];
}

/// Load all tickets for the specified view type
class LoadTicketsEvent extends TicketsEvent {
  final bool isAdminView;

  const LoadTicketsEvent({this.isAdminView = false});

  @override
  List<Object?> get props => [isAdminView];
}

/// Update filter for tickets (Admin view)
class UpdateFilterEvent extends TicketsEvent {
  final String filter;
  final bool isAdminView;

  const UpdateFilterEvent({required this.filter, this.isAdminView = true});

  @override
  List<Object?> get props => [filter, isAdminView];
}

/// Update priority filter for tickets (Admin view)
class UpdatePriorityFilterEvent extends TicketsEvent {
  final String priority;
  final bool isAdminView;

  const UpdatePriorityFilterEvent({
    required this.priority,
    this.isAdminView = true,
  });

  @override
  List<Object?> get props => [priority, isAdminView];
}

/// Update search query for tickets (Admin view)
class UpdateSearchQueryEvent extends TicketsEvent {
  final String query;
  final bool isAdminView;

  const UpdateSearchQueryEvent({required this.query, this.isAdminView = true});

  @override
  List<Object?> get props => [query, isAdminView];
}

/// Change filter for employee view (backward compatibility)
class ChangeFilterEvent extends TicketsEvent {
  final int filterIndex;

  const ChangeFilterEvent({required this.filterIndex});

  @override
  List<Object?> get props => [filterIndex];
}

/// Create a new ticket (Employee functionality)
class CreateTicketEvent extends TicketsEvent {
  final Map<String, dynamic> ticketData;

  const CreateTicketEvent({required this.ticketData});

  @override
  List<Object?> get props => [ticketData];
}

/// Assign ticket to admin/employee (Admin functionality)
class AssignTicketEvent extends TicketsEvent {
  final String ticketId;
  final String assignee;
  final bool isAdminView;

  const AssignTicketEvent({
    required this.ticketId,
    required this.assignee,
    this.isAdminView = true,
  });

  @override
  List<Object?> get props => [ticketId, assignee, isAdminView];
}

/// Update ticket status (Both views)
class UpdateTicketStatusEvent extends TicketsEvent {
  final String ticketId;
  final String status;
  final bool isAdminView;

  const UpdateTicketStatusEvent({
    required this.ticketId,
    required this.status,
    this.isAdminView = true,
  });

  @override
  List<Object?> get props => [ticketId, status, isAdminView];
}

/// Update ticket priority (Admin functionality)
class UpdateTicketPriorityEvent extends TicketsEvent {
  final String ticketId;
  final String priority;
  final bool isAdminView;

  const UpdateTicketPriorityEvent({
    required this.ticketId,
    required this.priority,
    this.isAdminView = true,
  });

  @override
  List<Object?> get props => [ticketId, priority, isAdminView];
}

/// Refresh tickets data (Both views)
class RefreshTicketsEvent extends TicketsEvent {
  final bool isAdminView;

  const RefreshTicketsEvent({this.isAdminView = true});

  @override
  List<Object?> get props => [isAdminView];
}
