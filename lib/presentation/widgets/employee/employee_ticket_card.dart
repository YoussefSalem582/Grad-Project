import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../widgets.dart';

class EmployeeTicketCard extends StatelessWidget {
  final String ticketId;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String customer;
  final String assignee;
  final String created;
  final VoidCallback onTap;

  const EmployeeTicketCard({
    super.key,
    required this.ticketId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.customer,
    required this.assignee,
    required this.created,
    required this.onTap,
  });

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.error;
      case 'in progress':
        return AppColors.warning;
      case 'pending':
        return AppColors.info;
      case 'resolved':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customSpacing = Theme.of(context).extension<CustomSpacing>()!;
    final priorityColor = _getPriorityColor(priority);

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(customSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: customSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticketId,
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: customSpacing.sm),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.4,
              ),
            ),
            SizedBox(height: customSpacing.md),
            Row(
              children: [
                _TicketInfo(label: 'Customer', value: customer),
                SizedBox(width: customSpacing.md),
                _TicketInfo(label: 'Assignee', value: assignee),
                SizedBox(width: customSpacing.md),
                _TicketInfo(label: 'Created', value: created),
              ],
            ),
            SizedBox(height: customSpacing.md),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: customSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                ModernButton(
                  onPressed: onTap,
                  style: ModernButtonStyle.outlined,
                  text: 'View Details',
                  size: ModernButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketInfo extends StatelessWidget {
  final String label;
  final String value;

  const _TicketInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
