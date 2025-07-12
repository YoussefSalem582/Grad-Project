import '../models/ticket.dart';

/// Repository interface for ticket operations
abstract class TicketRepository {
  /// Get all tickets
  Future<List<Ticket>> getAllTickets();

  /// Get tickets by filter
  Future<List<Ticket>> getTicketsByFilter(TicketFilter filter);

  /// Get ticket by ID
  Future<Ticket?> getTicketById(String id);

  /// Create a new ticket
  Future<Ticket> createTicket(Ticket ticket);

  /// Update an existing ticket
  Future<Ticket> updateTicket(Ticket ticket);

  /// Delete a ticket
  Future<void> deleteTicket(String id);

  /// Assign ticket to user
  Future<Ticket> assignTicket(String ticketId, String assigneeId);

  /// Update ticket status
  Future<Ticket> updateTicketStatus(String ticketId, TicketStatus status);

  /// Update ticket priority
  Future<Ticket> updateTicketPriority(String ticketId, TicketPriority priority);

  /// Get tickets assigned to specific user
  Future<List<Ticket>> getTicketsAssignedTo(String assigneeId);

  /// Get tickets created by specific user
  Future<List<Ticket>> getTicketsCreatedBy(String userId);

  /// Search tickets
  Future<List<Ticket>> searchTickets(String query);

  /// Get ticket statistics
  Future<TicketStatistics> getTicketStatistics();
}

/// Statistics for tickets
class TicketStatistics {
  final int totalCount;
  final int openCount;
  final int inProgressCount;
  final int resolvedCount;
  final int closedCount;
  final int highPriorityCount;
  final int criticalPriorityCount;
  final int overdueCount;
  final Map<String, int> categoryCount;
  final Map<String, int> assigneeCount;

  const TicketStatistics({
    required this.totalCount,
    required this.openCount,
    required this.inProgressCount,
    required this.resolvedCount,
    required this.closedCount,
    required this.highPriorityCount,
    required this.criticalPriorityCount,
    required this.overdueCount,
    required this.categoryCount,
    required this.assigneeCount,
  });

  factory TicketStatistics.fromTickets(List<Ticket> tickets) {
    final categoryCount = <String, int>{};
    final assigneeCount = <String, int>{};

    for (final ticket in tickets) {
      // Count by category
      categoryCount[ticket.category] = (categoryCount[ticket.category] ?? 0) + 1;

      // Count by assignee
      if (ticket.assignee != null) {
        final assigneeName = ticket.assignee!.name;
        assigneeCount[assigneeName] = (assigneeCount[assigneeName] ?? 0) + 1;
      }
    }

    return TicketStatistics(
      totalCount: tickets.length,
      openCount: tickets.where((t) => t.status == TicketStatus.open).length,
      inProgressCount: tickets.where((t) => t.status == TicketStatus.inProgress).length,
      resolvedCount: tickets.where((t) => t.status == TicketStatus.resolved).length,
      closedCount: tickets.where((t) => t.status == TicketStatus.closed).length,
      highPriorityCount: tickets.where((t) => t.priority == TicketPriority.high).length,
      criticalPriorityCount: tickets.where((t) => t.priority == TicketPriority.critical).length,
      overdueCount: tickets.where((t) => t.isOverdue).length,
      categoryCount: categoryCount,
      assigneeCount: assigneeCount,
    );
  }
}
