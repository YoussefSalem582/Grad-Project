import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  TicketsBloc() : super(const TicketsInitial()) {
    // Register event handlers
    on<LoadTicketsEvent>(_onLoadTickets);
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<UpdatePriorityFilterEvent>(_onUpdatePriorityFilter);
    on<UpdateSearchQueryEvent>(_onUpdateSearchQuery);
    on<ChangeFilterEvent>(_onChangeFilter);
    on<CreateTicketEvent>(_onCreateTicket);
    on<AssignTicketEvent>(_onAssignTicket);
    on<UpdateTicketStatusEvent>(_onUpdateTicketStatus);
    on<UpdateTicketPriorityEvent>(_onUpdateTicketPriority);
    on<RefreshTicketsEvent>(_onRefreshTickets);
  }

  // Common filters
  String _selectedFilter = 'all';
  String _selectedPriority = 'all';
  String _searchQuery = '';
  int _selectedFilterIndex = 0; // For employee view compatibility

  // Getters
  String get selectedFilter => _selectedFilter;
  String get selectedPriority => _selectedPriority;
  String get searchQuery => _searchQuery;
  int get selectedFilterIndex => _selectedFilterIndex;

  /// Event handler: Load all tickets
  Future<void> _onLoadTickets(
    LoadTicketsEvent event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());

    try {
      // Simulate loading tickets data
      await Future.delayed(const Duration(milliseconds: 500));

      final allTickets = [..._getEmployeeTickets(), ..._getAdminTickets()];
      final filteredTickets = _filterTickets(allTickets, event.isAdminView);

      if (event.isAdminView) {
        // Admin view data structure
        final ticketsData = AdminTicketsData(
          allTickets: allTickets,
          filteredTickets: filteredTickets,
          totalCount: allTickets.length,
          openCount: allTickets.where((t) => t['status'] == 'Open').length,
          inProgressCount:
              allTickets.where((t) => t['status'] == 'In Progress').length,
          resolvedCount:
              allTickets.where((t) => t['status'] == 'Resolved').length,
          criticalCount:
              allTickets.where((t) => t['priority'] == 'Critical').length,
        );
        emit(TicketsSuccess.admin(ticketsData));
      } else {
        // Employee view data structure
        final employeeTickets =
            allTickets.where((t) => t['source'] == 'Employee Ticket').toList();
        final filteredEmployeeTickets = _filterEmployeeTickets(employeeTickets);

        final ticketsData = EmployeeTicketsData(
          tickets: filteredEmployeeTickets,
          filterCounts: [
            employeeTickets.length, // All
            employeeTickets.where((t) => t['status'] == 'Open').length, // Open
            employeeTickets
                .where((t) => t['status'] == 'In Progress')
                .length, // In Progress
            employeeTickets
                .where((t) => t['status'] == 'Resolved')
                .length, // Resolved
          ],
          selectedFilterIndex: _selectedFilterIndex,
        );
        emit(TicketsSuccess.employee(ticketsData));
      }
    } catch (e) {
      emit(TicketsError(e.toString()));
    }
  }

  /// Event handler: Update filter
  Future<void> _onUpdateFilter(
    UpdateFilterEvent event,
    Emitter<TicketsState> emit,
  ) async {
    _selectedFilter = event.filter;
    add(LoadTicketsEvent(isAdminView: event.isAdminView));
  }

  /// Event handler: Update priority filter
  Future<void> _onUpdatePriorityFilter(
    UpdatePriorityFilterEvent event,
    Emitter<TicketsState> emit,
  ) async {
    _selectedPriority = event.priority;
    add(LoadTicketsEvent(isAdminView: event.isAdminView));
  }

  /// Event handler: Update search query
  Future<void> _onUpdateSearchQuery(
    UpdateSearchQueryEvent event,
    Emitter<TicketsState> emit,
  ) async {
    _searchQuery = event.query;
    add(LoadTicketsEvent(isAdminView: event.isAdminView));
  }

  /// Event handler: Change filter (Employee view)
  Future<void> _onChangeFilter(
    ChangeFilterEvent event,
    Emitter<TicketsState> emit,
  ) async {
    _selectedFilterIndex = event.filterIndex;
    add(const LoadTicketsEvent(isAdminView: false));
  }

  /// Event handler: Create ticket
  Future<void> _onCreateTicket(
    CreateTicketEvent event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());

    try {
      // Simulate creating ticket
      await Future.delayed(const Duration(milliseconds: 300));

      // Reload tickets after creation
      add(const LoadTicketsEvent(isAdminView: false));
    } catch (e) {
      emit(TicketsError(e.toString()));
    }
  }

  /// Event handler: Assign ticket
  Future<void> _onAssignTicket(
    AssignTicketEvent event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      add(LoadTicketsEvent(isAdminView: event.isAdminView));
    } catch (e) {
      emit(TicketsError(e.toString()));
    }
  }

  /// Event handler: Update ticket status
  Future<void> _onUpdateTicketStatus(
    UpdateTicketStatusEvent event,
    Emitter<TicketsState> emit,
  ) async {
    if (!event.isAdminView) {
      // For employee view, don't show loading for quick updates
      try {
        await Future.delayed(const Duration(milliseconds: 200));
        add(const LoadTicketsEvent(isAdminView: false));
      } catch (e) {
        emit(TicketsError(e.toString()));
      }
      return;
    }

    emit(const TicketsLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      add(LoadTicketsEvent(isAdminView: event.isAdminView));
    } catch (e) {
      emit(TicketsError(e.toString()));
    }
  }

  /// Event handler: Update ticket priority
  Future<void> _onUpdateTicketPriority(
    UpdateTicketPriorityEvent event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      add(LoadTicketsEvent(isAdminView: event.isAdminView));
    } catch (e) {
      emit(TicketsError(e.toString()));
    }
  }

  /// Event handler: Refresh tickets
  Future<void> _onRefreshTickets(
    RefreshTicketsEvent event,
    Emitter<TicketsState> emit,
  ) async {
    add(LoadTicketsEvent(isAdminView: event.isAdminView));
  }

  /// Filter tickets for admin view
  List<Map<String, dynamic>> _filterTickets(
    List<Map<String, dynamic>> tickets,
    bool isAdminView,
  ) {
    if (!isAdminView) return tickets;

    var filtered = tickets;

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered =
          filtered
              .where(
                (t) =>
                    t['status'].toString().toLowerCase() ==
                    _selectedFilter.toLowerCase(),
              )
              .toList();
    }

    // Apply priority filter
    if (_selectedPriority != 'all') {
      filtered =
          filtered
              .where(
                (t) =>
                    t['priority'].toString().toLowerCase() ==
                    _selectedPriority.toLowerCase(),
              )
              .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (t) =>
                    t['title'].toString().toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    t['description'].toString().toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    t['customerName'].toString().toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    t['id'].toString().toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  /// Filter tickets for employee view
  List<Map<String, dynamic>> _filterEmployeeTickets(
    List<Map<String, dynamic>> tickets,
  ) {
    // Filter tickets based on selected filter index
    switch (_selectedFilterIndex) {
      case 1: // Open
        return tickets.where((t) => t['status'] == 'Open').toList();
      case 2: // In Progress
        return tickets.where((t) => t['status'] == 'In Progress').toList();
      case 3: // Resolved
        return tickets.where((t) => t['status'] == 'Resolved').toList();
      default: // All
        return tickets;
    }
  }

  /// Get employee tickets data
  List<Map<String, dynamic>> _getEmployeeTickets() {
    return [
      {
        'id': 'EMP-001',
        'title': 'Product Quality Issue',
        'description':
            'Customer reports defective product received. The customer received a laptop with a cracked screen and is requesting a replacement.',
        'priority': 'High',
        'status': 'Open',
        'assignedTo': 'Sarah Johnson',
        'assignedToAvatar': 'S',
        'assignedToColor': const Color(0xFF2196F3),
        'department': 'Customer Support',
        'createdAt': '2 hours ago',
        'updatedAt': '1 hour ago',
        'category': 'Product Quality',
        'customerName': 'Mike Chen',
        'estimatedTime': '2 hours',
        'source': 'Employee Ticket',
        'employeeId': 'EMP123',
        'employeeName': 'Sarah Johnson',
        // Employee view compatibility
        'assignee': 'You',
        'created': '2 hours ago',
        'customer': 'Mike Chen',
        'url': 'https://support.example.com/ticket/emp001',
      },
      {
        'id': 'EMP-002',
        'title': 'Shipping Delay Inquiry',
        'description':
            'Customer asking about delayed shipment. Order was supposed to arrive yesterday but tracking shows it\'s still in transit.',
        'priority': 'Medium',
        'status': 'In Progress',
        'assignedTo': 'John Smith',
        'assignedToAvatar': 'J',
        'assignedToColor': const Color(0xFF4CAF50),
        'department': 'Logistics',
        'createdAt': '4 hours ago',
        'updatedAt': '30 minutes ago',
        'category': 'Shipping',
        'customerName': 'Emily Davis',
        'estimatedTime': '1 hour',
        'source': 'Employee Ticket',
        'employeeId': 'EMP456',
        'employeeName': 'John Smith',
        // Employee view compatibility
        'assignee': 'You',
        'created': '4 hours ago',
        'customer': 'Emily Davis',
        'url': 'https://support.example.com/ticket/emp002',
      },
      {
        'id': 'EMP-003',
        'title': 'Account Access Issue',
        'description':
            'Customer cannot log into their account after password reset. Getting error message about invalid credentials.',
        'priority': 'Critical',
        'status': 'Open',
        'assignedTo': 'Lisa Wong',
        'assignedToAvatar': 'L',
        'assignedToColor': const Color(0xFFFF9800),
        'department': 'IT Support',
        'createdAt': '1 hour ago',
        'updatedAt': '30 minutes ago',
        'category': 'Account Management',
        'customerName': 'Robert Wilson',
        'estimatedTime': '3 hours',
        'source': 'Employee Ticket',
        'employeeId': 'EMP789',
        'employeeName': 'Lisa Wong',
        // Employee view compatibility
        'assignee': 'You',
        'created': '1 hour ago',
        'customer': 'Robert Wilson',
        'url': 'https://support.example.com/ticket/emp003',
      },
      {
        'id': 'EMP-004',
        'title': 'Refund Request',
        'description':
            'Customer wants to return and get refund for defective smartwatch. Product stopped working after 2 days.',
        'priority': 'Medium',
        'status': 'Resolved',
        'assignedTo': 'David Kim',
        'assignedToAvatar': 'D',
        'assignedToColor': const Color(0xFF9C27B0),
        'department': 'Customer Support',
        'createdAt': '1 day ago',
        'updatedAt': '2 hours ago',
        'category': 'Returns & Refunds',
        'customerName': 'Anna Martinez',
        'estimatedTime': '4 hours',
        'source': 'Employee Ticket',
        'employeeId': 'EMP101',
        'employeeName': 'David Kim',
        // Employee view compatibility
        'assignee': 'Team Lead',
        'created': '1 day ago',
        'customer': 'Anna Martinez',
        'url': 'https://support.example.com/ticket/emp004',
      },
      {
        'id': 'EMP-005',
        'title': 'Product Information Request',
        'description':
            'Customer needs more details about product features and compatibility with their existing setup.',
        'priority': 'Low',
        'status': 'In Progress',
        'assignedTo': 'Maria Garcia',
        'assignedToAvatar': 'M',
        'assignedToColor': const Color(0xFF607D8B),
        'department': 'Sales Support',
        'createdAt': '3 hours ago',
        'updatedAt': '1 hour ago',
        'category': 'Product Information',
        'customerName': 'James Thompson',
        'estimatedTime': '1 hour',
        'source': 'Employee Ticket',
        'employeeId': 'EMP202',
        'employeeName': 'Maria Garcia',
        // Employee view compatibility
        'assignee': 'You',
        'created': '3 hours ago',
        'customer': 'James Thompson',
        'url': 'https://support.example.com/ticket/emp005',
      },
    ];
  }

  /// Get admin tickets data (existing admin tickets)
  List<Map<String, dynamic>> _getAdminTickets() {
    return [
      {
        'id': 'TK-001',
        'title': 'YouTube review spam detection - Tech channel verified',
        'description':
            'Multiple fake positive reviews detected on TechReview99 channel for iPhone 15 Pro. Bot comments with similar patterns posted within 2-hour window. Requires manual verification.',
        'status': 'Open',
        'priority': 'High',
        'assignedTo': 'John Smith',
        'assignedToAvatar': 'J',
        'assignedToColor': const Color(0xFF4CAF50),
        'department': 'Content Moderation',
        'createdAt': '2 hours ago',
        'updatedAt': '1 hour ago',
        'category': 'Spam Detection',
        'customerName': 'TechReview99 Channel',
        'estimatedTime': '4 hours',
        'source': 'Admin Ticket',
        // Employee view compatibility
        'assignee': 'John Smith',
        'created': '2 hours ago',
        'customer': 'TechReview99 Channel',
        'url': 'https://admin.example.com/ticket/001',
      },
      {
        'id': 'TK-002',
        'title': 'YouTube sentiment analysis failing for product reviews',
        'description':
            'AI sentiment classifier incorrectly marking negative gaming laptop reviews as positive. Affecting YouTuber UnboxKing\'s product rating aggregation and sponsor relationships.',
        'status': 'In Progress',
        'priority': 'Critical',
        'assignedTo': 'Sarah Johnson',
        'assignedToAvatar': 'S',
        'assignedToColor': const Color(0xFF2196F3),
        'department': 'AI/ML Analysis',
        'createdAt': '5 hours ago',
        'updatedAt': '30 minutes ago',
        'category': 'System Error',
        'customerName': 'UnboxKing Channel',
        'estimatedTime': '6 hours',
        'source': 'Admin Ticket',
        // Employee view compatibility
        'assignee': 'Sarah Johnson',
        'created': '5 hours ago',
        'customer': 'UnboxKing Channel',
        'url': 'https://admin.example.com/ticket/002',
      },
      {
        'id': 'TK-003',
        'title': 'System Performance Degradation',
        'description':
            'Server response times have increased by 40% in the last 24 hours. Multiple users reporting slow loading times.',
        'status': 'Open',
        'priority': 'Critical',
        'assignedTo': 'Tech Team',
        'assignedToAvatar': 'T',
        'assignedToColor': const Color(0xFFE91E63),
        'department': 'System Administration',
        'createdAt': '6 hours ago',
        'updatedAt': '2 hours ago',
        'category': 'System Performance',
        'customerName': 'Internal System',
        'estimatedTime': '8 hours',
        'source': 'Admin Ticket',
        // Employee view compatibility
        'assignee': 'Tech Team',
        'created': '6 hours ago',
        'customer': 'Internal System',
        'url': 'https://admin.example.com/ticket/003',
      },
    ];
  }

  /// Backward compatibility methods for cubit-like usage
  Future<void> loadAllTickets({bool isAdminView = false}) async {
    add(LoadTicketsEvent(isAdminView: isAdminView));
  }

  Future<void> loadTickets() async {
    add(const LoadTicketsEvent(isAdminView: false));
  }

  Future<void> updateFilter(String filter, {bool isAdminView = true}) async {
    add(UpdateFilterEvent(filter: filter, isAdminView: isAdminView));
  }

  Future<void> updatePriorityFilter(
    String priority, {
    bool isAdminView = true,
  }) async {
    add(
      UpdatePriorityFilterEvent(priority: priority, isAdminView: isAdminView),
    );
  }

  Future<void> updateSearchQuery(
    String query, {
    bool isAdminView = true,
  }) async {
    add(UpdateSearchQueryEvent(query: query, isAdminView: isAdminView));
  }

  Future<void> changeFilter(int filterIndex) async {
    add(ChangeFilterEvent(filterIndex: filterIndex));
  }

  Future<void> createTicket(Map<String, dynamic> ticketData) async {
    add(CreateTicketEvent(ticketData: ticketData));
  }

  Future<void> assignTicket(
    String ticketId,
    String assignee, {
    bool isAdminView = true,
  }) async {
    add(
      AssignTicketEvent(
        ticketId: ticketId,
        assignee: assignee,
        isAdminView: isAdminView,
      ),
    );
  }

  Future<void> updateTicketStatus(
    String ticketId,
    String status, {
    bool isAdminView = true,
  }) async {
    add(
      UpdateTicketStatusEvent(
        ticketId: ticketId,
        status: status,
        isAdminView: isAdminView,
      ),
    );
  }

  Future<void> updateTicketPriority(
    String ticketId,
    String priority, {
    bool isAdminView = true,
  }) async {
    add(
      UpdateTicketPriorityEvent(
        ticketId: ticketId,
        priority: priority,
        isAdminView: isAdminView,
      ),
    );
  }

  Future<void> refreshTickets({bool isAdminView = true}) async {
    add(RefreshTicketsEvent(isAdminView: isAdminView));
  }
}
