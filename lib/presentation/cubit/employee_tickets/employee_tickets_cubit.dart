import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'employee_tickets_state.dart';

class EmployeeTicketsCubit extends Cubit<EmployeeTicketsState> {
  EmployeeTicketsCubit() : super(const EmployeeTicketsInitial());

  int _selectedFilterIndex = 0;

  int get selectedFilterIndex => _selectedFilterIndex;

  /// Load tickets data
  Future<void> loadTickets() async {
    emit(const EmployeeTicketsLoading());

    try {
      // Simulate loading tickets data
      await Future.delayed(const Duration(milliseconds: 400));

      final ticketsData = EmployeeTicketsData(
        tickets: _getTicketsData(),
        filterCounts: [12, 8, 3, 45], // All, Open, In Progress, Resolved
        selectedFilterIndex: _selectedFilterIndex,
      );

      emit(EmployeeTicketsSuccess(ticketsData));
    } catch (e) {
      emit(EmployeeTicketsError(e.toString()));
    }
  }

  /// Change filter and reload tickets
  Future<void> changeFilter(int filterIndex) async {
    _selectedFilterIndex = filterIndex;
    await loadTickets();
  }

  /// Create new ticket
  Future<void> createTicket(Map<String, dynamic> ticketData) async {
    emit(const EmployeeTicketsLoading());

    try {
      // Simulate creating ticket
      await Future.delayed(const Duration(milliseconds: 300));

      // Reload tickets after creation
      await loadTickets();
    } catch (e) {
      emit(EmployeeTicketsError(e.toString()));
    }
  }

  /// Update ticket status
  Future<void> updateTicketStatus(String ticketId, String status) async {
    try {
      // Simulate updating ticket
      await Future.delayed(const Duration(milliseconds: 200));

      // Reload tickets after update
      await loadTickets();
    } catch (e) {
      emit(EmployeeTicketsError(e.toString()));
    }
  }

  /// Refresh tickets data
  Future<void> refreshTickets() async {
    await loadTickets();
  }

  List<Map<String, dynamic>> _getTicketsData() {
    final allTickets = [
      {
        'id': '#TK-001',
        'title': 'Product Quality Issue',
        'description': 'Customer reports defective product received',
        'priority': 'High',
        'status': 'Open',
        'assignee': 'You',
        'created': '2 hours ago',
        'customer': 'Sarah Johnson',
        'url': 'https://support.example.com/ticket/001',
      },
      {
        'id': '#TK-002',
        'title': 'Shipping Delay Inquiry',
        'description': 'Customer asking about delayed shipment',
        'priority': 'Medium',
        'status': 'In Progress',
        'assignee': 'You',
        'created': '4 hours ago',
        'customer': 'Mike Chen',
        'url': 'https://support.example.com/ticket/002',
      },
      {
        'id': '#TK-003',
        'title': 'Refund Request',
        'description': 'Customer wants to return and get refund',
        'priority': 'Low',
        'status': 'In Progress',
        'assignee': 'Team Lead',
        'created': '1 day ago',
        'customer': 'Emily Davis',
        'url': 'https://support.example.com/ticket/003',
      },
      {
        'id': '#TK-004',
        'title': 'Account Access Issue',
        'description': 'Customer cannot log into their account',
        'priority': 'High',
        'status': 'Resolved',
        'assignee': 'You',
        'created': '2 days ago',
        'customer': 'Robert Wilson',
        'url': 'https://support.example.com/ticket/004',
      },
      {
        'id': '#TK-005',
        'title': 'Product Information Request',
        'description': 'Customer needs more details about product features',
        'priority': 'Low',
        'status': 'Open',
        'assignee': 'You',
        'created': '3 hours ago',
        'customer': 'Anna Martinez',
        'url': 'https://support.example.com/ticket/005',
      },
    ];

    // Filter tickets based on selected filter
    switch (_selectedFilterIndex) {
      case 1: // Open
        return allTickets.where((t) => t['status'] == 'Open').toList();
      case 2: // In Progress
        return allTickets.where((t) => t['status'] == 'In Progress').toList();
      case 3: // Resolved
        return allTickets.where((t) => t['status'] == 'Resolved').toList();
      default: // All
        return allTickets;
    }
  }
}
