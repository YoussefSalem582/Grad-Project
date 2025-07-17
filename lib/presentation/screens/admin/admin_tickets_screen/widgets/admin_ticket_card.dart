import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import '../../../../../domain/models/ticket.dart';
import '../../../../cubit/tickets/tickets_cubit.dart';
import '../../../../widgets/dialogs/ticket_details_dialog.dart';

class AdminTicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final TicketsCubit cubit;

  const AdminTicketCard({super.key, required this.ticket, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
          padding: EdgeInsets.all(customSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(theme, customSpacing),
              SizedBox(height: customSpacing.sm),
              _buildTitle(theme),
              SizedBox(height: customSpacing.sm),
              _buildDescription(theme),
              SizedBox(height: customSpacing.md),
              _buildStatusAndPriorityRow(customSpacing),
              SizedBox(height: customSpacing.md),
              _buildFooterRow(theme, customSpacing),
              if (ticket['source']?.toString() == 'Employee Ticket') ...[
                SizedBox(height: customSpacing.sm),
                _buildEmployeeTicketInfo(theme, customSpacing),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(ThemeData theme, CustomSpacing spacing) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color:
                ticket['source'] == 'Employee Ticket'
                    ? Colors.blue.withValues(alpha: 0.1)
                    : Colors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  ticket['source'] == 'Employee Ticket'
                      ? Colors.blue.withValues(alpha: 0.3)
                      : Colors.purple.withValues(alpha: 0.3),
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
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      ticket['title']?.toString() ?? 'No Title',
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      ticket['description']?.toString() ?? 'No Description',
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusAndPriorityRow(CustomSpacing spacing) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(
              ticket['status']?.toString(),
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getStatusColor(
                ticket['status']?.toString(),
              ).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            ticket['status']?.toString() ?? 'Unknown',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(ticket['status']?.toString()),
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
            color: _getPriorityColor(
              ticket['priority']?.toString(),
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getPriorityColor(
                ticket['priority']?.toString(),
              ).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            ticket['priority']?.toString() ?? 'Unknown',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getPriorityColor(ticket['priority']?.toString()),
            ),
          ),
        ),
        const Spacer(),
        _buildActionMenu(),
      ],
    );
  }

  Widget _buildActionMenu() {
    return Builder(
      builder:
          (context) => PopupMenuButton<String>(
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
    );
  }

  Widget _buildFooterRow(ThemeData theme, CustomSpacing spacing) {
    return Row(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: ticket['assignedToColor'] ?? Colors.grey,
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
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildEmployeeTicketInfo(ThemeData theme, CustomSpacing spacing) {
    return Row(
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
    );
  }

  Color _getPriorityColor(String? priority) {
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

  Color _getStatusColor(String? status) {
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
}

// Dialog helper functions (moved from main screen)
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
                  cubit.assignTicket(ticketId, 'John Smith');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Sarah Johnson'),
                subtitle: const Text('Technical Lead'),
                onTap: () {
                  cubit.assignTicket(ticketId, 'Sarah Johnson');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Lisa Wong'),
                subtitle: const Text('Customer Success'),
                onTap: () {
                  cubit.assignTicket(ticketId, 'Lisa Wong');
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
                  cubit.updateTicketStatus(ticketId, TicketStatus.open);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('In Progress'),
                onTap: () {
                  cubit.updateTicketStatus(ticketId, TicketStatus.inProgress);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Resolved'),
                onTap: () {
                  cubit.updateTicketStatus(ticketId, TicketStatus.resolved);
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
                  cubit.updateTicketPriority(ticketId, TicketPriority.low);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Medium'),
                onTap: () {
                  cubit.updateTicketPriority(ticketId, TicketPriority.medium);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('High'),
                onTap: () {
                  cubit.updateTicketPriority(ticketId, TicketPriority.high);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Critical'),
                onTap: () {
                  cubit.updateTicketPriority(ticketId, TicketPriority.critical);
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
