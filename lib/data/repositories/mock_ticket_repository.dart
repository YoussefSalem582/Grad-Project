import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';

/// Mock implementation of ticket repository for development
class MockTicketRepository implements TicketRepository {
  // In-memory storage for development
  final List<Ticket> _tickets = [];
  final StreamController<List<Ticket>> _ticketsController = StreamController.broadcast();

  MockTicketRepository() {
    _initializeMockData();
  }

  /// Get stream of tickets for real-time updates
  Stream<List<Ticket>> get ticketsStream => _ticketsController.stream;

  @override
  Future<List<Ticket>> getAllTickets() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_tickets);
  }

  @override
  Future<List<Ticket>> getTicketsByFilter(TicketFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final filteredTickets = _tickets.where(filter.matches).toList();
    return filteredTickets;
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Ticket> createTicket(Ticket ticket) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _tickets.add(ticket);
    _notifyTicketsChanged();
    return ticket;
  }

  @override
  Future<Ticket> updateTicket(Ticket ticket) async {
    await Future.delayed(const Duration(milliseconds: 250));
    
    final index = _tickets.indexWhere((t) => t.id == ticket.id);
    if (index == -1) {
      throw Exception('Ticket not found');
    }
    
    _tickets[index] = ticket.copyWith(updatedAt: DateTime.now());
    _notifyTicketsChanged();
    return _tickets[index];
  }

  @override
  Future<void> deleteTicket(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    _tickets.removeWhere((ticket) => ticket.id == id);
    _notifyTicketsChanged();
  }

  @override
  Future<Ticket> assignTicket(String ticketId, String assigneeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final ticket = await getTicketById(ticketId);
    if (ticket == null) {
      throw Exception('Ticket not found');
    }

    // Create assignee (in real app, this would come from user service)
    final assignee = Assignee(
      id: assigneeId,
      name: _getAssigneeName(assigneeId),
      avatar: _getAssigneeAvatar(assigneeId),
      color: _getAssigneeColor(assigneeId),
      department: 'Support Team',
    );

    final updatedTicket = ticket.copyWith(
      assignee: assignee,
      updatedAt: DateTime.now(),
    );

    return updateTicket(updatedTicket);
  }

  @override
  Future<Ticket> updateTicketStatus(String ticketId, TicketStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final ticket = await getTicketById(ticketId);
    if (ticket == null) {
      throw Exception('Ticket not found');
    }

    final updatedTicket = ticket.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    return updateTicket(updatedTicket);
  }

  @override
  Future<Ticket> updateTicketPriority(String ticketId, TicketPriority priority) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final ticket = await getTicketById(ticketId);
    if (ticket == null) {
      throw Exception('Ticket not found');
    }

    final updatedTicket = ticket.copyWith(
      priority: priority,
      updatedAt: DateTime.now(),
    );

    return updateTicket(updatedTicket);
  }

  @override
  Future<List<Ticket>> getTicketsAssignedTo(String assigneeId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    return _tickets
        .where((ticket) => ticket.assignee?.id == assigneeId)
        .toList();
  }

  @override
  Future<List<Ticket>> getTicketsCreatedBy(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    // In a real app, tickets would have a createdBy field
    return _tickets
        .where((ticket) => ticket.source == TicketSource.employee)
        .toList();
  }

  @override
  Future<List<Ticket>> searchTickets(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final filter = TicketFilter(searchQuery: query);
    return getTicketsByFilter(filter);
  }

  @override
  Future<TicketStatistics> getTicketStatistics() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    return TicketStatistics.fromTickets(_tickets);
  }

  /// Initialize mock data
  void _initializeMockData() {
    final now = DateTime.now();
    
    _tickets.addAll([
      Ticket(
        id: 'EMP-001',
        title: 'Product Quality Issue',
        description: 'Customer reports defective product received. The customer received a laptop with a cracked screen and is requesting a replacement.',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        source: TicketSource.employee,
        customerName: 'Mike Chen',
        assignee: const Assignee(
          id: 'USER-001',
          name: 'Sarah Johnson',
          avatar: 'S',
          color: Color(0xFF2196F3),
          department: 'Customer Support',
        ),
        category: 'Product Quality',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        estimatedTime: '2 hours',
        referenceUrl: 'https://support.example.com/ticket/emp001',
      ),
      Ticket(
        id: 'EMP-002',
        title: 'Shipping Delay Inquiry',
        description: 'Customer asking about delayed shipment. Order was supposed to arrive yesterday but tracking shows it\'s still in transit.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.medium,
        source: TicketSource.employee,
        customerName: 'Emily Davis',
        assignee: const Assignee(
          id: 'USER-002',
          name: 'John Smith',
          avatar: 'J',
          color: Color(0xFF4CAF50),
          department: 'Logistics',
        ),
        category: 'Shipping',
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        estimatedTime: '1 hour',
        referenceUrl: 'https://support.example.com/ticket/emp002',
      ),
      Ticket(
        id: 'EMP-003',
        title: 'Account Access Issue',
        description: 'Customer cannot log into their account after password reset. Getting error message about invalid credentials.',
        status: TicketStatus.open,
        priority: TicketPriority.critical,
        source: TicketSource.employee,
        customerName: 'Robert Wilson',
        assignee: const Assignee(
          id: 'USER-003',
          name: 'Lisa Wong',
          avatar: 'L',
          color: Color(0xFFFF9800),
          department: 'IT Support',
        ),
        category: 'Account Management',
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        estimatedTime: '3 hours',
        referenceUrl: 'https://support.example.com/ticket/emp003',
      ),
      Ticket(
        id: 'TK-001',
        title: 'YouTube review spam detection - Tech channel verified',
        description: 'Multiple fake positive reviews detected on TechReview99 channel for iPhone 15 Pro. Bot comments with similar patterns posted within 2-hour window. Requires manual verification.',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        source: TicketSource.admin,
        customerName: 'TechReview99 Channel',
        assignee: const Assignee(
          id: 'USER-004',
          name: 'John Smith',
          avatar: 'J',
          color: Color(0xFF4CAF50),
          department: 'Content Moderation',
        ),
        category: 'Spam Detection',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        estimatedTime: '4 hours',
        referenceUrl: 'https://admin.example.com/ticket/001',
      ),
      Ticket(
        id: 'TK-002',
        title: 'YouTube sentiment analysis failing for product reviews',
        description: 'AI sentiment classifier incorrectly marking negative gaming laptop reviews as positive. Affecting YouTuber UnboxKing\'s product rating aggregation and sponsor relationships.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.critical,
        source: TicketSource.admin,
        customerName: 'UnboxKing Channel',
        assignee: const Assignee(
          id: 'USER-001',
          name: 'Sarah Johnson',
          avatar: 'S',
          color: Color(0xFF2196F3),
          department: 'AI/ML Analysis',
        ),
        category: 'System Error',
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        estimatedTime: '6 hours',
        referenceUrl: 'https://admin.example.com/ticket/002',
      ),
    ]);
  }

  void _notifyTicketsChanged() {
    _ticketsController.add(List.from(_tickets));
  }

  String _getAssigneeName(String assigneeId) {
    switch (assigneeId) {
      case 'USER-001':
        return 'Sarah Johnson';
      case 'USER-002':
        return 'John Smith';
      case 'USER-003':
        return 'Lisa Wong';
      case 'USER-004':
        return 'David Kim';
      default:
        return 'Unknown User';
    }
  }

  String _getAssigneeAvatar(String assigneeId) {
    return _getAssigneeName(assigneeId).substring(0, 1);
  }

  Color _getAssigneeColor(String assigneeId) {
    switch (assigneeId) {
      case 'USER-001':
        return const Color(0xFF2196F3);
      case 'USER-002':
        return const Color(0xFF4CAF50);
      case 'USER-003':
        return const Color(0xFFFF9800);
      case 'USER-004':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  void dispose() {
    _ticketsController.close();
  }
}
