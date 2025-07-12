import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/ticket.dart';
import '../../../domain/usecases/ticket_usecases.dart';
import '../../../core/usecases/usecase.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final LoadTicketsUseCase _loadTicketsUseCase;
  final CreateTicketUseCase _createTicketUseCase;
  final UpdateTicketStatusUseCase _updateTicketStatusUseCase;
  final AssignTicketUseCase _assignTicketUseCase;
  final GetTicketStatisticsUseCase _getTicketStatisticsUseCase;

  TicketsCubit({
    required LoadTicketsUseCase loadTicketsUseCase,
    required CreateTicketUseCase createTicketUseCase,
    required UpdateTicketStatusUseCase updateTicketStatusUseCase,
    required AssignTicketUseCase assignTicketUseCase,
    required GetTicketStatisticsUseCase getTicketStatisticsUseCase,
  })  : _loadTicketsUseCase = loadTicketsUseCase,
        _createTicketUseCase = createTicketUseCase,
        _updateTicketStatusUseCase = updateTicketStatusUseCase,
        _assignTicketUseCase = assignTicketUseCase,
        _getTicketStatisticsUseCase = getTicketStatisticsUseCase,
        super(const TicketsInitial());

  // Current filter state
  TicketFilter _currentFilter = TicketFilter.empty();
  TicketSortBy _currentSortBy = TicketSortBy.createdDate;
  bool _isAdminView = false;

  // For legacy compatibility
  int _selectedFilterIndex = 0;

  // Getters for backward compatibility
  String get selectedFilter => _currentFilter.status?.displayName ?? 'all';
  String get selectedPriority => _currentFilter.priority?.displayName ?? 'all';
  String get searchQuery => _currentFilter.searchQuery;
  int get selectedFilterIndex => _selectedFilterIndex;

  /// Load tickets with current filter
  Future<void> loadAllTickets({bool isAdminView = false}) async {
    _isAdminView = isAdminView;
    emit(const TicketsLoading());

    try {
      // Adjust filter based on view type
      final filter = isAdminView 
          ? _currentFilter 
          : _currentFilter.copyWith(source: TicketSource.employee);

      final params = LoadTicketsParams(
        filter: filter,
        sortBy: _currentSortBy,
      );

      final result = await _loadTicketsUseCase(params);

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (tickets) {
          if (isAdminView) {
            _emitAdminSuccess(tickets);
          } else {
            _emitEmployeeSuccess(tickets);
          }
        },
      );
    } catch (e) {
      emit(TicketsError('Failed to load tickets: $e'));
    }
  }

  /// Load tickets for employee view (backward compatibility)
  Future<void> loadTickets() async {
    await loadAllTickets(isAdminView: false);
  }

  /// Update filter and reload tickets
  Future<void> updateFilter(String filter, {bool isAdminView = true}) async {
    final status = filter == 'all' ? null : TicketStatus.fromString(filter);
    _currentFilter = _currentFilter.copyWith(status: status);
    await loadAllTickets(isAdminView: isAdminView);
  }

  /// Update priority filter and reload tickets
  Future<void> updatePriorityFilter(String priority, {bool isAdminView = true}) async {
    final priorityEnum = priority == 'all' ? null : TicketPriority.fromString(priority);
    _currentFilter = _currentFilter.copyWith(priority: priorityEnum);
    await loadAllTickets(isAdminView: isAdminView);
  }

  /// Update search query and reload tickets
  Future<void> updateSearchQuery(String query, {bool isAdminView = true}) async {
    _currentFilter = _currentFilter.copyWith(searchQuery: query);
    await loadAllTickets(isAdminView: isAdminView);
  }

  /// Update filter index (for backward compatibility)
  Future<void> updateFilterIndex(int index, {bool isAdminView = true}) async {
    _selectedFilterIndex = index;
    
    // Map index to actual filter
    String filterName;
    switch (index) {
      case 0:
        filterName = 'all';
        break;
      case 1:
        filterName = 'open';
        break;
      case 2:
        filterName = 'in_progress';
        break;
      case 3:
        filterName = 'resolved';
        break;
      case 4:
        filterName = 'closed';
        break;
      default:
        filterName = 'all';
    }
    
    await updateFilter(filterName, isAdminView: isAdminView);
  }

  /// Create a new ticket
  Future<void> createTicket(CreateTicketRequest request) async {
    emit(const TicketsLoading());

    try {
      final result = await _createTicketUseCase(request);

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (ticket) {
          // Reload tickets after creation
          loadAllTickets(isAdminView: _isAdminView);
        },
      );
    } catch (e) {
      emit(TicketsError('Failed to create ticket: $e'));
    }
  }

  /// Update ticket status
  Future<void> updateTicketStatus(String ticketId, TicketStatus status) async {
    emit(const TicketsLoading());

    try {
      final params = UpdateTicketStatusParams(
        ticketId: ticketId,
        status: status,
      );

      final result = await _updateTicketStatusUseCase(params);

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (_) {
          // Reload tickets after update
          loadAllTickets(isAdminView: _isAdminView);
        },
      );
    } catch (e) {
      emit(TicketsError('Failed to update ticket status: $e'));
    }
  }

  /// Assign ticket to an employee
  Future<void> assignTicket(String ticketId, String employeeId) async {
    emit(const TicketsLoading());

    try {
      final params = AssignTicketParams(
        ticketId: ticketId,
        employeeId: employeeId,
      );

      final result = await _assignTicketUseCase(params);

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (_) {
          // Reload tickets after assignment
          loadAllTickets(isAdminView: _isAdminView);
        },
      );
    } catch (e) {
      emit(TicketsError('Failed to assign ticket: $e'));
    }
  }

  /// Get ticket statistics
  Future<void> getTicketStatistics({bool isAdminView = true}) async {
    try {
      final filter = isAdminView 
          ? TicketFilter.empty() 
          : TicketFilter.empty().copyWith(source: TicketSource.employee);

      final result = await _getTicketStatisticsUseCase(filter);

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (statistics) {
          if (isAdminView) {
            _emitAdminStatistics(statistics);
          } else {
            _emitEmployeeStatistics(statistics);
          }
        },
      );
    } catch (e) {
      emit(TicketsError('Failed to load statistics: $e'));
    }
  }

  // Helper methods for emitting success states
  void _emitAdminSuccess(List<Ticket> tickets) {
    // Convert tickets to legacy format
    final allTickets = tickets.map((ticket) => ticket.toJson()).toList();
    final filteredTickets = _filterTickets(allTickets);

    final data = AdminTicketsData(
      allTickets: allTickets,
      filteredTickets: filteredTickets,
      totalCount: allTickets.length,
      openCount: allTickets.where((t) => t['status'] == 'Open').length,
      inProgressCount: allTickets.where((t) => t['status'] == 'In Progress').length,
      resolvedCount: allTickets.where((t) => t['status'] == 'Resolved').length,
      closedCount: allTickets.where((t) => t['status'] == 'Closed').length,
      highPriorityCount: allTickets.where((t) => t['priority'] == 'High').length,
      mediumPriorityCount: allTickets.where((t) => t['priority'] == 'Medium').length,
      lowPriorityCount: allTickets.where((t) => t['priority'] == 'Low').length,
      recentTickets: allTickets.take(5).toList(),
    );

    emit(TicketsSuccess.admin(data));
  }

  void _emitEmployeeSuccess(List<Ticket> tickets) {
    // Convert tickets to legacy format and filter for employee
    final allTickets = tickets
        .map((ticket) => ticket.toJson())
        .toList();

    final data = EmployeeTicketsData(
      assignedTickets: allTickets,
      recentTickets: allTickets.take(5).toList(),
      myTicketsCount: allTickets.length,
      pendingCount: allTickets.where((t) => t['status'] == 'Open').length,
      inProgressCount: allTickets.where((t) => t['status'] == 'In Progress').length,
      completedCount: allTickets.where((t) => t['status'] == 'Resolved').length,
    );

    emit(TicketsSuccess.employee(data));
  }

  void _emitAdminStatistics(TicketStatistics statistics) {
    final data = AdminTicketsData(
      allTickets: [],
      filteredTickets: [],
      totalCount: statistics.totalCount,
      openCount: statistics.openCount,
      inProgressCount: statistics.inProgressCount,
      resolvedCount: statistics.resolvedCount,
      closedCount: statistics.closedCount,
      highPriorityCount: statistics.highPriorityCount,
      mediumPriorityCount: statistics.mediumPriorityCount,
      lowPriorityCount: statistics.lowPriorityCount,
      recentTickets: [],
    );

    emit(TicketsSuccess.admin(data));
  }

  void _emitEmployeeStatistics(TicketStatistics statistics) {
    final data = EmployeeTicketsData(
      assignedTickets: [],
      recentTickets: [],
      myTicketsCount: statistics.totalCount,
      pendingCount: statistics.openCount,
      inProgressCount: statistics.inProgressCount,
      completedCount: statistics.resolvedCount,
    );

    emit(TicketsSuccess.employee(data));
  }

  // Helper method for filtering (backward compatibility)
  List<Map<String, dynamic>> _filterTickets(List<Map<String, dynamic>> tickets) {
    var filtered = tickets;

    // Apply status filter
    if (_currentFilter.status != null) {
      filtered = filtered
          .where((ticket) => ticket['status'] == _currentFilter.status!.displayName)
          .toList();
    }

    // Apply priority filter
    if (_currentFilter.priority != null) {
      filtered = filtered
          .where((ticket) => ticket['priority'] == _currentFilter.priority!.displayName)
          .toList();
    }

    // Apply search filter
    if (_currentFilter.searchQuery.isNotEmpty) {
      filtered = filtered.where((ticket) {
        final query = _currentFilter.searchQuery.toLowerCase();
        return ticket['title']?.toString().toLowerCase().contains(query) == true ||
               ticket['description']?.toString().toLowerCase().contains(query) == true ||
               ticket['customer']?.toString().toLowerCase().contains(query) == true ||
               ticket['id']?.toString().toLowerCase().contains(query) == true;
      }).toList();
    }

    return filtered;
  }
}
