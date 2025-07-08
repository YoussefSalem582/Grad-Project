import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../cubit/employee_tickets/employee_tickets_cubit.dart';
import 'widgets/review_video_filter_chips_widget.dart';

class EmployeeTicketsScreen extends StatefulWidget {
  const EmployeeTicketsScreen({super.key});

  @override
  State<EmployeeTicketsScreen> createState() => _EmployeeTicketsScreenState();
}

class _EmployeeTicketsScreenState extends State<EmployeeTicketsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _backgroundController;

  int _selectedFilterIndex = 0;
  bool _showVideoDetailsDialog = false;
  bool _showCreateTicketDialog = false;
  String? _selectedVideoId;

  // Controllers for the create ticket dialog
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _referenceUrlController = TextEditingController();
  String _selectedPriority = 'Medium';

  final List<Map<String, dynamic>> _sampleTickets = [
    {
      'id': 'TK-001',
      'title': 'Product Quality Issue',
      'description': 'Customer reports defective product received',
      'customer': 'Sarah Johnson',
      'priority': 'High',
      'status': 'Open',
      'created': '2 hours ago',
      'assignee': 'You',
      'referenceUrl': 'https://support.example.com/ticket/001',
    },
    {
      'id': 'TK-002',
      'title': 'Shipping Delay Inquiry',
      'description': 'Customer asking about delayed shipment',
      'customer': 'Mike Davis',
      'priority': 'Medium',
      'status': 'In Progress',
      'created': '4 hours ago',
      'assignee': 'You',
      'referenceUrl': 'https://support.example.com/ticket/002',
    },
    {
      'id': 'TK-003',
      'title': 'Refund Request',
      'description': 'Customer requesting refund for order',
      'customer': 'Emily Chen',
      'priority': 'Medium',
      'status': 'Resolved',
      'created': '1 day ago',
      'assignee': 'John Smith',
      'referenceUrl': 'https://support.example.com/ticket/003',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _backgroundController.dispose();
    _customerNameController.dispose();
    _issueTitleController.dispose();
    _descriptionController.dispose();
    _referenceUrlController.dispose();
    super.dispose();
  }

  void _createNewTicket() {
    if (_customerNameController.text.isNotEmpty &&
        _issueTitleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      // Generate a new ticket ID
      int ticketNumber = _sampleTickets.length + 1;
      String ticketId = 'TK-${ticketNumber.toString().padLeft(3, '0')}';

      // Create new ticket
      Map<String, dynamic> newTicket = {
        'id': ticketId,
        'title': _issueTitleController.text,
        'description': _descriptionController.text,
        'customer': _customerNameController.text,
        'priority': _selectedPriority,
        'status': 'Open',
        'created': 'Just now',
        'assignee': 'You',
        'referenceUrl':
            _referenceUrlController.text.isNotEmpty
                ? _referenceUrlController.text
                : null,
      };

      setState(() {
        _sampleTickets.insert(0, newTicket); // Add to the beginning of the list
        _showCreateTicketDialog = false;
      });

      // Clear the form
      _clearCreateTicketForm();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket $ticketId created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show error message for missing fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearCreateTicketForm() {
    _customerNameController.clear();
    _issueTitleController.clear();
    _descriptionController.clear();
    _referenceUrlController.clear();
    setState(() {
      _selectedPriority = 'Medium';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeeTicketsCubit()..loadTickets(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Animated Background with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6366F1), // Primary purple
                    Color(0xFF8B5CF6), // Secondary purple
                    Color(0xFF06B6D4), // Cyan at bottom
                  ],
                ),
              ),
            ),

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: customSpacing.md),

                  // Section Header with New Ticket Button
                  _buildSectionHeader(customSpacing),

                  SizedBox(height: customSpacing.md),

                  // Filter Chips
                  ReviewVideoFilterChipsWidget(
                    spacing: customSpacing,
                    selectedFilterIndex: _selectedFilterIndex,
                    onFilterChanged:
                        (index) => setState(() => _selectedFilterIndex = index),
                    tickets: _sampleTickets,
                  ),

                  SizedBox(height: customSpacing.md),

                  // Tickets List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: customSpacing.md,
                      ),
                      itemCount: _getFilteredTickets().length,
                      itemBuilder: (context, index) {
                        final ticket = _getFilteredTickets()[index];
                        return _buildTicketCard(ticket, customSpacing);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Dialogs
            if (_showVideoDetailsDialog) _buildTicketDetailsDialog(),
            if (_showCreateTicketDialog) _buildCreateTicketDialog(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Support Tickets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                'Total Tickets: ${_sampleTickets.length}',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => setState(() => _showCreateTicketDialog = true),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New Ticket'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket, CustomSpacing spacing) {
    final priorityColor = _getPriorityColor(ticket['priority']);
    final statusColor = _getStatusColor(ticket['status']);

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Ticket ID
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket['id'],
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              // Priority Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket['priority'],
                  style: TextStyle(
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.md),

          // Title
          Text(
            ticket['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: spacing.sm),

          // Description
          Text(
            ticket['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),

          SizedBox(height: spacing.md),

          // Footer Row
          Row(
            children: [
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              // Action Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVideoId = ticket['id'];
                    _showVideoDetailsDialog = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF6366F1)),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredTickets() {
    switch (_selectedFilterIndex) {
      case 1: // Open
        return _sampleTickets
            .where((ticket) => ticket['status'] == 'Open')
            .toList();
      case 2: // In Progress
        return _sampleTickets
            .where((ticket) => ticket['status'] == 'In Progress')
            .toList();
      case 3: // Resolved
        return _sampleTickets
            .where((ticket) => ticket['status'] == 'Resolved')
            .toList();
      default: // All
        return _sampleTickets;
    }
  }

  Widget _buildTicketDetailsDialog() {
    final ticket = _sampleTickets.firstWhere(
      (t) => t['id'] == _selectedVideoId,
      orElse: () => _sampleTickets.first,
    );

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Ticket Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap:
                        () => setState(() => _showVideoDetailsDialog = false),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Ticket ID:', ticket['id']),
              _buildDetailRow('Customer:', ticket['customer']),
              _buildDetailRow('Priority:', ticket['priority']),
              _buildDetailRow('Status:', ticket['status']),
              _buildDetailRow('Created:', ticket['created']),
              _buildDetailRow('Assignee:', ticket['assignee']),
              if (ticket['referenceUrl'] != null)
                _buildDetailRow('Reference URL:', ticket['referenceUrl']),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ticket['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          () => setState(() => _showVideoDetailsDialog = false),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => setState(() => _showVideoDetailsDialog = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Update Status'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTicketDialog() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_circle, color: Color(0xFF6366F1)),
                  const SizedBox(width: 8),
                  const Text(
                    'New Support Ticket',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _clearCreateTicketForm();
                      setState(() => _showCreateTicketDialog = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  hintText: 'Customer Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _issueTitleController,
                decoration: InputDecoration(
                  hintText: 'Issue Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _referenceUrlController,
                decoration: InputDecoration(
                  hintText: 'Reference URL (Optional)',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  hintText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _clearCreateTicketForm();
                        setState(() => _showCreateTicketDialog = false);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createNewTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Create Ticket'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
