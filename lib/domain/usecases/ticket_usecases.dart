import '../../core/usecases/usecase.dart';
import '../../core/errors/failures.dart';
import '../models/ticket.dart';
import '../repositories/ticket_repository.dart';

/// No parameters class for use cases without parameters
class NoParams {
  const NoParams();
}

/// Use case for loading tickets with filtering
class LoadTicketsUseCase implements UseCase<List<Ticket>, LoadTicketsParams> {
  final TicketRepository repository;

  LoadTicketsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Ticket>>> call(LoadTicketsParams params) async {
    try {
      final tickets = await repository.getTicketsByFilter(params.filter);
      
      // Apply additional business logic
      final sortedTickets = _sortTickets(tickets, params.sortBy);
      final paginatedTickets = _paginateTickets(sortedTickets, params.page, params.pageSize);
      
      return Right(paginatedTickets);
    } catch (e) {
      return Left(TicketFailure(e.toString()));
    }
  }

  List<Ticket> _sortTickets(List<Ticket> tickets, TicketSortBy sortBy) {
    switch (sortBy) {
      case TicketSortBy.createdDate:
        return tickets..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case TicketSortBy.updatedDate:
        return tickets..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case TicketSortBy.priority:
        return tickets..sort((a, b) => b.priority.index.compareTo(a.priority.index));
      case TicketSortBy.status:
        return tickets..sort((a, b) => a.status.index.compareTo(b.status.index));
      case TicketSortBy.title:
        return tickets..sort((a, b) => a.title.compareTo(b.title));
    }
  }

  List<Ticket> _paginateTickets(List<Ticket> tickets, int page, int pageSize) {
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, tickets.length);
    
    if (startIndex >= tickets.length) return [];
    
    return tickets.sublist(startIndex, endIndex);
  }
}

class LoadTicketsParams {
  final TicketFilter filter;
  final TicketSortBy sortBy;
  final int page;
  final int pageSize;

  const LoadTicketsParams({
    required this.filter,
    this.sortBy = TicketSortBy.createdDate,
    this.page = 0,
    this.pageSize = 20,
  });
}

enum TicketSortBy {
  createdDate,
  updatedDate,
  priority,
  status,
  title,
}

/// Use case for creating a ticket
class CreateTicketUseCase implements UseCase<Ticket, CreateTicketParams> {
  final TicketRepository repository;

  CreateTicketUseCase(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(CreateTicketParams params) async {
    try {
      // Validate ticket data
      final validationResult = _validateTicket(params.ticket);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Create ticket with generated ID and timestamps
      final ticket = params.ticket.copyWith(
        id: _generateTicketId(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdTicket = await repository.createTicket(ticket);
      return Right(createdTicket);
    } catch (e) {
      return Left(TicketFailure(e.toString()));
    }
  }

  String? _validateTicket(Ticket ticket) {
    if (ticket.title.trim().isEmpty) {
      return 'Ticket title cannot be empty';
    }
    if (ticket.description.trim().isEmpty) {
      return 'Ticket description cannot be empty';
    }
    if (ticket.customerName.trim().isEmpty) {
      return 'Customer name cannot be empty';
    }
    return null;
  }

  String _generateTicketId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'TK-${timestamp.toString().substring(8)}';
  }
}

class CreateTicketParams {
  final Ticket ticket;

  const CreateTicketParams({required this.ticket});
}

/// Use case for updating ticket status
class UpdateTicketStatusUseCase implements UseCase<Ticket, UpdateTicketStatusParams> {
  final TicketRepository repository;

  UpdateTicketStatusUseCase(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(UpdateTicketStatusParams params) async {
    try {
      // Get current ticket
      final currentTicket = await repository.getTicketById(params.ticketId);
      if (currentTicket == null) {
        return Left(NotFoundFailure('Ticket not found'));
      }

      // Validate status transition
      final validationResult = _validateStatusTransition(
        currentTicket.status,
        params.newStatus,
      );
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Update ticket
      final updatedTicket = await repository.updateTicketStatus(
        params.ticketId,
        params.newStatus,
      );

      return Right(updatedTicket);
    } catch (e) {
      return Left(TicketFailure(e.toString()));
    }
  }

  String? _validateStatusTransition(TicketStatus from, TicketStatus to) {
    // Business rules for status transitions
    if (from == TicketStatus.closed && to != TicketStatus.open) {
      return 'Closed tickets can only be reopened';
    }
    if (from == TicketStatus.resolved && to == TicketStatus.open) {
      return 'Resolved tickets cannot be directly reopened. Contact admin.';
    }
    return null;
  }
}

class UpdateTicketStatusParams {
  final String ticketId;
  final TicketStatus newStatus;

  const UpdateTicketStatusParams({
    required this.ticketId,
    required this.newStatus,
  });
}

/// Use case for assigning tickets
class AssignTicketUseCase implements UseCase<Ticket, AssignTicketParams> {
  final TicketRepository repository;

  AssignTicketUseCase(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(AssignTicketParams params) async {
    try {
      final updatedTicket = await repository.assignTicket(
        params.ticketId,
        params.assigneeId,
      );
      return Right(updatedTicket);
    } catch (e) {
      return Left(TicketFailure(e.toString()));
    }
  }
}

class AssignTicketParams {
  final String ticketId;
  final String assigneeId;

  const AssignTicketParams({
    required this.ticketId,
    required this.assigneeId,
  });
}

/// Use case for getting ticket statistics
class GetTicketStatisticsUseCase implements UseCase<TicketStatistics, NoParams> {
  final TicketRepository repository;

  GetTicketStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, TicketStatistics>> call(NoParams params) async {
    try {
      final statistics = await repository.getTicketStatistics();
      return Right(statistics);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

/// Custom failure classes for tickets
class TicketFailure extends Failure {
  const TicketFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
