import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Enumeration for ticket status
enum TicketStatus {
  open('Open'),
  inProgress('In Progress'),
  resolved('Resolved'),
  closed('Closed');

  const TicketStatus(this.displayName);
  final String displayName;

  static TicketStatus fromString(String status) {
    return TicketStatus.values.firstWhere(
      (e) => e.displayName.toLowerCase() == status.toLowerCase(),
      orElse: () => TicketStatus.open,
    );
  }
}

/// Enumeration for ticket priority
enum TicketPriority {
  low('Low'),
  medium('Medium'),
  high('High'),
  critical('Critical');

  const TicketPriority(this.displayName);
  final String displayName;

  static TicketPriority fromString(String priority) {
    return TicketPriority.values.firstWhere(
      (e) => e.displayName.toLowerCase() == priority.toLowerCase(),
      orElse: () => TicketPriority.medium,
    );
  }

  Color get color {
    switch (this) {
      case TicketPriority.low:
        return Colors.green;
      case TicketPriority.medium:
        return Colors.orange;
      case TicketPriority.high:
        return Colors.red;
      case TicketPriority.critical:
        return Colors.purple;
    }
  }
}

/// Enumeration for ticket source
enum TicketSource {
  employee('Employee Ticket'),
  admin('Admin Ticket'),
  system('System Ticket'),
  customer('Customer Ticket');

  const TicketSource(this.displayName);
  final String displayName;

  static TicketSource fromString(String source) {
    return TicketSource.values.firstWhere(
      (e) => e.displayName.toLowerCase() == source.toLowerCase(),
      orElse: () => TicketSource.customer,
    );
  }
}

/// Assignee information
class Assignee extends Equatable {
  final String id;
  final String name;
  final String avatar;
  final Color color;
  final String? department;

  const Assignee({
    required this.id,
    required this.name,
    required this.avatar,
    required this.color,
    this.department,
  });

  factory Assignee.fromMap(Map<String, dynamic> map) {
    return Assignee(
      id: map['id'] ?? '',
      name: map['name'] ?? map['assignedTo'] ?? 'Unassigned',
      avatar: map['avatar'] ?? map['assignedToAvatar'] ?? 'U',
      color: map['color'] ?? map['assignedToColor'] ?? Colors.grey,
      department: map['department'],
    );
  }

  @override
  List<Object?> get props => [id, name, avatar, color, department];
}

/// Main ticket domain model
class Ticket extends Equatable {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final TicketSource source;
  final String customerName;
  final Assignee? assignee;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? estimatedTime;
  final String? referenceUrl;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.source,
    required this.customerName,
    this.assignee,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedTime,
    this.referenceUrl,
  });

  /// Factory constructor from legacy map format
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: TicketStatus.fromString(map['status'] ?? 'Open'),
      priority: TicketPriority.fromString(map['priority'] ?? 'Medium'),
      source: TicketSource.fromString(map['source'] ?? 'Customer Ticket'),
      customerName: map['customerName'] ?? map['customer'] ?? '',
      assignee: map['assignedTo'] != null ? Assignee.fromMap(map) : null,
      category: map['category'] ?? 'General',
      createdAt: _parseDateTime(map['createdAt'] ?? map['created']),
      updatedAt: _parseDateTime(map['updatedAt']),
      estimatedTime: map['estimatedTime'],
      referenceUrl: map['url'] ?? map['referenceUrl'],
    );
  }

  /// Convert to map for legacy compatibility
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.displayName,
      'priority': priority.displayName,
      'source': source.displayName,
      'customerName': customerName,
      'customer': customerName, // Legacy compatibility
      'assignedTo': assignee?.name,
      'assignedToAvatar': assignee?.avatar,
      'assignedToColor': assignee?.color,
      'department': assignee?.department,
      'category': category,
      'createdAt': _formatDateTime(createdAt),
      'created': _formatDateTime(createdAt), // Legacy compatibility
      'updatedAt': _formatDateTime(updatedAt),
      'estimatedTime': estimatedTime,
      'url': referenceUrl,
      'referenceUrl': referenceUrl,
    };
  }

  /// Create copy with updated fields
  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    TicketStatus? status,
    TicketPriority? priority,
    TicketSource? source,
    String? customerName,
    Assignee? assignee,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? estimatedTime,
    String? referenceUrl,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      source: source ?? this.source,
      customerName: customerName ?? this.customerName,
      assignee: assignee ?? this.assignee,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      referenceUrl: referenceUrl ?? this.referenceUrl,
    );
  }

  /// Get time ago string
  String get timeAgoString => _getTimeAgo(createdAt);

  /// Get last updated string
  String get lastUpdatedString => _getTimeAgo(updatedAt);

  /// Check if ticket is overdue (example: if open for more than 24 hours)
  bool get isOverdue {
    if (status == TicketStatus.resolved || status == TicketStatus.closed) {
      return false;
    }
    return DateTime.now().difference(createdAt).inHours > 24;
  }

  /// Check if ticket is high priority (high or critical)
  bool get isHighPriority {
    return priority == TicketPriority.high || priority == TicketPriority.critical;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        priority,
        source,
        customerName,
        assignee,
        category,
        createdAt,
        updatedAt,
        estimatedTime,
        referenceUrl,
      ];

  /// Parse DateTime from string or return current time
  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      // Handle relative time strings like "2 hours ago"
      final now = DateTime.now();
      if (dateTime.contains('hour')) {
        final hours = int.tryParse(dateTime.split(' ')[0]) ?? 0;
        return now.subtract(Duration(hours: hours));
      } else if (dateTime.contains('day')) {
        final days = int.tryParse(dateTime.split(' ')[0]) ?? 0;
        return now.subtract(Duration(days: days));
      } else if (dateTime.contains('minute')) {
        final minutes = int.tryParse(dateTime.split(' ')[0]) ?? 0;
        return now.subtract(Duration(minutes: minutes));
      }
      // Try parsing ISO format
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return now;
      }
    }
    return DateTime.now();
  }

  /// Format DateTime to string
  static String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Get time ago string
  static String _getTimeAgo(DateTime dateTime) {
    return _formatDateTime(dateTime);
  }
}

/// Filter configuration for tickets
class TicketFilter extends Equatable {
  final TicketStatus? status;
  final TicketPriority? priority;
  final TicketSource? source;
  final String searchQuery;
  final String? category;
  final String? assigneeId;

  const TicketFilter({
    this.status,
    this.priority,
    this.source,
    this.searchQuery = '',
    this.category,
    this.assigneeId,
  });

  factory TicketFilter.empty() {
    return const TicketFilter();
  }

  TicketFilter copyWith({
    TicketStatus? status,
    TicketPriority? priority,
    TicketSource? source,
    String? searchQuery,
    String? category,
    String? assigneeId,
  }) {
    return TicketFilter(
      status: status ?? this.status,
      priority: priority ?? this.priority,
      source: source ?? this.source,
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      assigneeId: assigneeId ?? this.assigneeId,
    );
  }

  bool matches(Ticket ticket) {
    if (status != null && ticket.status != status) return false;
    if (priority != null && ticket.priority != priority) return false;
    if (source != null && ticket.source != source) return false;
    if (category != null && ticket.category != category) return false;
    if (assigneeId != null && ticket.assignee?.id != assigneeId) return false;

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      return ticket.title.toLowerCase().contains(query) ||
          ticket.description.toLowerCase().contains(query) ||
          ticket.customerName.toLowerCase().contains(query) ||
          ticket.id.toLowerCase().contains(query);
    }

    return true;
  }

  @override
  List<Object?> get props => [
        status,
        priority,
        source,
        searchQuery,
        category,
        assigneeId,
      ];
}
