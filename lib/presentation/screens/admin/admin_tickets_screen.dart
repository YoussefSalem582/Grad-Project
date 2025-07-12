import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../cubit/tickets/tickets_cubit.dart';
import '../../widgets/common/animated_background_widget.dart';
import '../../widgets/dialogs/ticket_details_dialog.dart';

class AdminTicketsScreen extends StatefulWidget {
  const AdminTicketsScreen({super.key});

  @override
  State<AdminTicketsScreen> createState() => _AdminTicketsScreenState();
}

class _AdminTicketsScreenState extends State<AdminTicketsScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );
    _backgroundController.repeat();

    _searchController = TextEditingController();

    // Load tickets when screen initializes
    context.read<TicketsCubit>().loadAllTickets(isAdminView: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Main content
          SafeArea(
            child: BlocBuilder<TicketsCubit, TicketsState>(
              builder: (context, state) {
                if (state is TicketsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TicketsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(height: customSpacing.md),
                        Text(
                          'Error loading tickets',
                          style: theme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: customSpacing.sm),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: customSpacing.lg),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TicketsCubit>().loadAllTickets(isAdminView: true);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TicketsSuccess && state.isAdminView && state.adminData != null) {
                  return _buildTicketsContent(
                    context,
                    state.adminData!,
                    customSpacing,
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsContent(
    BuildContext context,
    AdminTicketsData data,
    CustomSpacing spacing,
  ) {
    final theme = Theme.of(context);
    final cubit = context.read<TicketsCubit>();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and stats
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Tickets',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: spacing.xs),
                          Text(
                            'Employee & Admin Tickets Management',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.md,
                        vertical: spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${data.totalCount}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Total Tickets',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacing.xl),

                // Stats cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Open',
                        '${data.openCount}',
                        Icons.circle_outlined,
                        Colors.orange,
                        spacing,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: _buildStatCard(
                        'In Progress',
                        '${data.inProgressCount}',
                        Icons.pending,
                        Colors.blue,
                        spacing,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: _buildStatCard(
                        'Resolved',
                        '${data.resolvedCount}',
                        Icons.check_circle,
                        Colors.green,
                        spacing,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: _buildStatCard(
                        'Critical',
                        '${data.criticalCount}',
                        Icons.warning,
                        Colors.red,
                        spacing,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacing.xl),

                // Search and filters
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search tickets...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          cubit.updateSearchQuery(value, isAdminView: true);
                        },
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: cubit.selectedFilter,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('All Status'),
                          ),
                          DropdownMenuItem(value: 'open', child: Text('Open')),
                          DropdownMenuItem(
                            value: 'in progress',
                            child: Text('In Progress'),
                          ),
                          DropdownMenuItem(
                            value: 'resolved',
                            child: Text('Resolved'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            cubit.updateFilter(value, isAdminView: true);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: cubit.selectedPriority,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('All Priority'),
                          ),
                          DropdownMenuItem(value: 'low', child: Text('Low')),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(value: 'high', child: Text('High')),
                          DropdownMenuItem(
                            value: 'critical',
                            child: Text('Critical'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            cubit.updatePriorityFilter(value, isAdminView: true);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Tickets list
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final ticket = data.filteredTickets[index];
              return _buildTicketCard(context, ticket, spacing);
            }, childCount: data.filteredTickets.length),
          ),
        ),

        // Bottom padding
        SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
    CustomSpacing spacing,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: spacing.xs),
          Text(
            count,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    Map<String, dynamic> ticket,
    CustomSpacing spacing,
  ) {
    final theme = Theme.of(context);
    final cubit = context.read<TicketsCubit>();

    Color getPriorityColor(String? priority) {
      if (priority == null) return Colors.grey;
      switch (priority.toLowerCase()) {
        case 'critical':
          return Colors.red;
        case 'high':
          return Colors.orange;
        case 'medium':
          return Colors.blue;
        case 'low':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    Color getStatusColor(String? status) {
      if (status == null) return Colors.grey;
      switch (status.toLowerCase()) {
        case 'open':
          return Colors.orange;
        case 'in progress':
          return Colors.blue;
        case 'resolved':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => TicketDetailsDialog(ticket: ticket),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Ticket source badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color:
                          ticket['source'] == 'Employee Ticket'
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            ticket['source'] == 'Employee Ticket'
                                ? Colors.blue.withOpacity(0.3)
                                : Colors.purple.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      ticket['source'] ?? 'Admin Ticket',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                            ticket['source'] == 'Employee Ticket'
                                ? Colors.blue[700]
                                : Colors.purple[700],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    ticket['id']?.toString() ?? 'NO-ID',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing.sm),

              // Title
              Text(
                ticket['title']?.toString() ?? 'No Title',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: spacing.sm),

              // Description
              Text(
                ticket['description']?.toString() ?? 'No Description',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: spacing.md),

              // Status and priority badges
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(ticket['status']?.toString()).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getStatusColor(
                          ticket['status']?.toString(),
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      ticket['status']?.toString() ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: getStatusColor(ticket['status']?.toString()),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: getPriorityColor(
                        ticket['priority']?.toString(),
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getPriorityColor(
                          ticket['priority']?.toString(),
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      ticket['priority']?.toString() ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: getPriorityColor(ticket['priority']?.toString()),
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      final ticketId = ticket['id']?.toString();
                      if (ticketId == null) return;
                      
                      switch (value) {
                        case 'assign':
                          _showAssignDialog(context, ticket, cubit);
                          break;
                        case 'status':
                          _showStatusDialog(context, ticket, cubit);
                          break;
                        case 'priority':
                          _showPriorityDialog(context, ticket, cubit);
                          break;
                      }
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'assign',
                            child: Row(
                              children: [
                                Icon(Icons.person_add, size: 16),
                                SizedBox(width: 8),
                                Text('Assign'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'status',
                            child: Row(
                              children: [
                                Icon(Icons.update, size: 16),
                                SizedBox(width: 8),
                                Text('Change Status'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'priority',
                            child: Row(
                              children: [
                                Icon(Icons.flag, size: 16),
                                SizedBox(width: 8),
                                Text('Change Priority'),
                              ],
                            ),
                          ),
                        ],
                    child: Icon(Icons.more_vert, color: Colors.grey[600]),
                  ),
                ],
              ),

              SizedBox(height: spacing.md),

              // Footer row
              Row(
                children: [
                  // Assigned to
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor:
                            ticket['assignedToColor'] ?? Colors.grey,
                        child: Text(
                          ticket['assignedToAvatar'] ?? '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      Text(
                        ticket['assignedTo'] ?? 'Unassigned',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    ticket['createdAt'] ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Customer name for employee tickets
              if (ticket['source']?.toString() == 'Employee Ticket') ...[
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    SizedBox(width: spacing.xs),
                    Text(
                      'Customer: ${ticket['customerName']?.toString() ?? 'Unknown'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'by ${ticket['employeeName']?.toString() ?? 'Unknown'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignDialog(
    BuildContext context,
    Map<String, dynamic> ticket,
    TicketsCubit cubit,
  ) {
    final ticketId = ticket['id']?.toString();
    if (ticketId == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Assign Ticket'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('John Smith'),
                  subtitle: const Text('Senior Support'),
                  onTap: () {
                    cubit.assignTicket(ticketId, 'John Smith', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Sarah Johnson'),
                  subtitle: const Text('Technical Lead'),
                  onTap: () {
                    cubit.assignTicket(ticketId, 'Sarah Johnson', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Lisa Wong'),
                  subtitle: const Text('Customer Success'),
                  onTap: () {
                    cubit.assignTicket(ticketId, 'Lisa Wong', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showStatusDialog(
    BuildContext context,
    Map<String, dynamic> ticket,
    TicketsCubit cubit,
  ) {
    final ticketId = ticket['id']?.toString();
    if (ticketId == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Open'),
                  onTap: () {
                    cubit.updateTicketStatus(ticketId, 'Open', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('In Progress'),
                  onTap: () {
                    cubit.updateTicketStatus(ticketId, 'In Progress', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Resolved'),
                  onTap: () {
                    cubit.updateTicketStatus(ticketId, 'Resolved', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showPriorityDialog(
    BuildContext context,
    Map<String, dynamic> ticket,
    TicketsCubit cubit,
  ) {
    final ticketId = ticket['id']?.toString();
    if (ticketId == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Priority'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Low'),
                  onTap: () {
                    cubit.updateTicketPriority(ticketId, 'Low', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Medium'),
                  onTap: () {
                    cubit.updateTicketPriority(ticketId, 'Medium', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('High'),
                  onTap: () {
                    cubit.updateTicketPriority(ticketId, 'High', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Critical'),
                  onTap: () {
                    cubit.updateTicketPriority(ticketId, 'Critical', isAdminView: true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }
}
