import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

class ReviewVideoCardWidget extends StatelessWidget {
  final Map<String, dynamic> video;
  final CustomSpacing spacing;
  final VoidCallback onTap;

  const ReviewVideoCardWidget({
    super.key,
    required this.video,
    required this.spacing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(video['priority']);
    final statusColor = _getStatusColor(video['status']);

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
              // Video ID
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
                  video['id'],
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),

              SizedBox(width: spacing.sm),

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPriorityIcon(video['priority']),
                      color: priorityColor,
                      size: 12,
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      video['priority'],
                      style: TextStyle(
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

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
                  video['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.md),

          // Video Title and Channel
          Text(
            video['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: spacing.xs),

          // Channel Info
          Row(
            children: [
              Icon(Icons.youtube_searched_for, size: 16, color: Colors.red),
              SizedBox(width: spacing.xs),
              Text(
                video['channel'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.sm),

          // Description
          Text(
            video['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: spacing.md),

          // Footer Row
          Row(
            children: [
              // Reviewer Name
              Icon(Icons.person_outline, size: 16, color: Colors.grey[500]),
              SizedBox(width: spacing.xs),
              Text(
                video['reviewer'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(width: spacing.md),

              // Time
              Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
              SizedBox(width: spacing.xs),
              Text(
                video['created'],
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),

              SizedBox(width: spacing.md),

              // Views
              Icon(Icons.visibility, size: 16, color: Colors.grey[500]),
              SizedBox(width: spacing.xs),
              Text(
                video['views'],
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),

              const Spacer(),

              // Action Button
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(spacing.sm),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Color(0xFF6366F1),
                    size: 14,
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

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'under review':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
