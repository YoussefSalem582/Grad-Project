import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/auth/animated_background_widget.dart';

class AdminTicketsScreen extends StatefulWidget {
  const AdminTicketsScreen({super.key});

  @override
  State<AdminTicketsScreen> createState() => _AdminTicketsScreenState();
}

class _AdminTicketsScreenState extends State<AdminTicketsScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  String _selectedFilter = 'all';
  String _selectedPriority = 'all';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _tickets = [
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
      'category': 'Algorithm Bug',
      'customerName': 'UnboxKing YouTube',
      'estimatedTime': '8 hours',
    },
    {
      'id': 'TK-003',
      'title': 'Bulk YouTube comment analysis dashboard request',
      'description':
          'YouTuber requesting custom analytics dashboard to track sentiment across all product review videos. Need real-time comment sentiment tracking, keyword extraction, and engagement metrics.',
      'status': 'Pending',
      'priority': 'Medium',
      'assignedTo': 'Mike Chen',
      'assignedToAvatar': 'M',
      'assignedToColor': const Color(0xFF9C27B0),
      'department': 'Product Development',
      'createdAt': '1 day ago',
      'updatedAt': '6 hours ago',
      'category': 'Feature Request',
      'customerName': 'GadgetGuru Official',
      'estimatedTime': '12 hours',
    },
    {
      'id': 'TK-004',
      'title': 'YouTube video transcript extraction not working',
      'description':
          'Unable to extract transcripts from product review videos for sentiment analysis. YouTube API integration returning timeout errors for videos longer than 20 minutes.',
      'status': 'Resolved',
      'priority': 'Low',
      'assignedTo': 'Emily Davis',
      'assignedToAvatar': 'E',
      'assignedToColor': const Color(0xFFFF9800),
      'department': 'Technical Support',
      'createdAt': '2 days ago',
      'updatedAt': '1 day ago',
      'category': 'API Integration',
      'customerName': 'ReviewMaster Channel',
      'estimatedTime': '2 hours',
    },
    {
      'id': 'TK-005',
      'title': 'YouTube review analytics export failing',
      'description':
          'Channel owner cannot export YouTube comment sentiment data to CSV. Export function timing out when processing channels with 100K+ subscribers and high comment volume.',
      'status': 'Open',
      'priority': 'Medium',
      'assignedTo': 'John Smith',
      'assignedToAvatar': 'J',
      'assignedToColor': const Color(0xFF4CAF50),
      'department': 'Data Analytics',
      'createdAt': '3 hours ago',
      'updatedAt': '2 hours ago',
      'category': 'Data Export',
      'customerName': 'TechTalk Premium',
      'estimatedTime': '6 hours',
    },
  ];

  final Map<String, Map<String, dynamic>> _ticketMetrics = {
    'totalTickets': {'value': '29', 'change': '+2', 'color': Color(0xFF4CAF50)},
    'openTickets': {'value': '23', 'change': '+5', 'color': Color(0xFFFF9800)},
    'productIssues': {
      'value': '18',
      'change': '-2',
      'color': Color(0xFF2196F3),
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedBackgroundWidget(animation: _backgroundAnimation),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: customSpacing.xl * 2,
                  ), // Space for admin badge
                  _buildHeader(theme, customSpacing),
                  SizedBox(height: customSpacing.lg),
                  _buildMetricsOverview(customSpacing),
                  SizedBox(height: customSpacing.lg),
                  _buildFiltersAndSearch(customSpacing),
                  SizedBox(height: customSpacing.lg),
                  _buildTicketsList(customSpacing),
                  SizedBox(height: customSpacing.xl), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Container(
        padding: EdgeInsets.all(customSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6B6B).withValues(alpha: 0.1),
              const Color(0xFFFF8E53).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(customSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.confirmation_number,
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tickets Review Analytics',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: customSpacing.xs),
                  Text(
                    'Monitor and manage product review content and analytics',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: customSpacing.sm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: customSpacing.sm,
                      vertical: customSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notification_important,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        SizedBox(width: customSpacing.xs),
                        Text(
                          '${_getOpenTicketsCount()} Review issues need attention',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsOverview(CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: customSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: _ticketMetrics.length,
            itemBuilder: (context, index) {
              final entry = _ticketMetrics.entries.elementAt(index);
              return _buildMetricCard(entry.key, entry.value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String key, Map<String, dynamic> metric) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: metric['color'].withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: metric['color'].withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: metric['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getMetricIcon(key),
                  color: metric['color'],
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                metric['change'],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: metric['change'].startsWith('+')
                      ? AppColors.success
                      : metric['change'].startsWith('-')
                      ? AppColors.error
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            metric['value'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: metric['color'],
            ),
          ),
          Text(
            _formatMetricTitle(key),
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch(CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search tickets...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: customSpacing.md,
                  vertical: customSpacing.md,
                ),
              ),
            ),
          ),
          SizedBox(height: customSpacing.md),
          // Filter chips
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all', _selectedFilter),
                      SizedBox(width: customSpacing.sm),
                      _buildFilterChip('Open', 'open', _selectedFilter),
                      SizedBox(width: customSpacing.sm),
                      _buildFilterChip(
                        'In Progress',
                        'in_progress',
                        _selectedFilter,
                      ),
                      SizedBox(width: customSpacing.sm),
                      _buildFilterChip('Resolved', 'resolved', _selectedFilter),
                      SizedBox(width: customSpacing.sm),
                      _buildFilterChip('Pending', 'pending', _selectedFilter),
                    ],
                  ),
                ),
              ),
              SizedBox(width: customSpacing.sm),
              // Priority filter
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  initialValue: _selectedPriority,
                  onSelected: (value) =>
                      setState(() => _selectedPriority = value),
                  child: Container(
                    padding: EdgeInsets.all(customSpacing.sm),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.priority_high,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _selectedPriority.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('All Priorities'),
                    ),
                    const PopupMenuItem(
                      value: 'critical',
                      child: Text('Critical'),
                    ),
                    const PopupMenuItem(value: 'high', child: Text('High')),
                    const PopupMenuItem(value: 'medium', child: Text('Medium')),
                    const PopupMenuItem(value: 'low', child: Text('Low')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String selectedValue) {
    final isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B6B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B6B) : AppColors.textLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTicketsList(CustomSpacing customSpacing) {
    final filteredTickets = _tickets.where((ticket) {
      final matchesSearch =
          ticket['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket['customerName'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesFilter =
          _selectedFilter == 'all' ||
          ticket['status'].toLowerCase().replaceAll(' ', '_') ==
              _selectedFilter;

      final matchesPriority =
          _selectedPriority == 'all' ||
          ticket['priority'].toLowerCase() == _selectedPriority;

      return matchesSearch && matchesFilter && matchesPriority;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Column(
        children: filteredTickets
            .map((ticket) => _buildTicketCard(ticket, customSpacing))
            .toList(),
      ),
    );
  }

  Widget _buildTicketCard(
    Map<String, dynamic> ticket,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(customSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      ticket['priority'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket['id'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _getPriorityColor(ticket['priority']),
                    ),
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      ticket['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(ticket['status']),
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (action) => _handleTicketAction(action, ticket),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'assign',
                      child: Text('Reassign'),
                    ),
                    const PopupMenuItem(
                      value: 'priority',
                      child: Text('Change Priority'),
                    ),
                    const PopupMenuItem(
                      value: 'status',
                      child: Text('Update Status'),
                    ),
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('View Details'),
                    ),
                  ],
                  child: Icon(Icons.more_vert, color: AppColors.textSecondary),
                ),
              ],
            ),
            SizedBox(height: customSpacing.sm),
            // Title and Description
            Text(
              ticket['title'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: customSpacing.xs),
            Text(
              ticket['description'],
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: customSpacing.sm),
            // Details
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: ticket['assignedToColor'],
                  child: Text(
                    ticket['assignedToAvatar'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['assignedTo'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ticket['department'],
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Customer: ${ticket['customerName']}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Est: ${ticket['estimatedTime']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: customSpacing.sm),
            // Footer
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: AppColors.textLight),
                SizedBox(width: 4),
                Text(
                  'Created ${ticket['createdAt']}',
                  style: TextStyle(fontSize: 10, color: AppColors.textLight),
                ),
                SizedBox(width: customSpacing.sm),
                Icon(Icons.update, size: 12, color: AppColors.textLight),
                SizedBox(width: 4),
                Text(
                  'Updated ${ticket['updatedAt']}',
                  style: TextStyle(fontSize: 10, color: AppColors.textLight),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket['category'],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return const Color(0xFFFF0000);
      case 'high':
        return const Color(0xFFFF6B6B);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF2196F3);
      case 'in progress':
        return const Color(0xFFFF9800);
      case 'resolved':
        return AppColors.success;
      case 'pending':
        return const Color(0xFF9C27B0);
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getMetricIcon(String key) {
    switch (key) {
      case 'totalTickets':
        return Icons.confirmation_number;
      case 'openTickets':
        return Icons.inbox;
      case 'productIssues':
        return Icons.bug_report;
      default:
        return Icons.analytics;
    }
  }

  String _formatMetricTitle(String key) {
    switch (key) {
      case 'totalTickets':
        return 'Total Tickets';
      case 'openTickets':
        return 'Open Tickets';
      case 'productIssues':
        return 'Product Issues';
      default:
        return key;
    }
  }

  int _getOpenTicketsCount() {
    return _tickets
        .where(
          (ticket) =>
              ticket['status'] == 'Open' || ticket['status'] == 'In Progress',
        )
        .length;
  }

  void _handleTicketAction(String action, Map<String, dynamic> ticket) {
    switch (action) {
      case 'assign':
        _showReassignDialog(ticket);
        break;
      case 'priority':
        _showPriorityDialog(ticket);
        break;
      case 'status':
        _showStatusDialog(ticket);
        break;
      case 'view':
        _showTicketDetails(ticket);
        break;
    }
  }

  void _showReassignDialog(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reassign Ticket ${ticket['id']}'),
        content: const Text('Reassignment dialog would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ticket ${ticket['id']} reassigned')),
              );
            },
            child: const Text('Reassign'),
          ),
        ],
      ),
    );
  }

  void _showPriorityDialog(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Priority - ${ticket['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Critical'),
              leading: Radio(
                value: 'Critical',
                groupValue: ticket['priority'],
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('High'),
              leading: Radio(
                value: 'High',
                groupValue: ticket['priority'],
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Medium'),
              leading: Radio(
                value: 'Medium',
                groupValue: ticket['priority'],
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Low'),
              leading: Radio(
                value: 'Low',
                groupValue: ticket['priority'],
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Priority updated for ${ticket['id']}')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Status - ${ticket['id']}'),
        content: const Text('Status update dialog would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Status updated for ${ticket['id']}')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ticket Details - ${ticket['id']}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title: ${ticket['title']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Description: ${ticket['description']}'),
              const SizedBox(height: 8),
              Text('Customer: ${ticket['customerName']}'),
              const SizedBox(height: 8),
              Text('Assigned to: ${ticket['assignedTo']}'),
              const SizedBox(height: 8),
              Text('Department: ${ticket['department']}'),
              const SizedBox(height: 8),
              Text('Priority: ${ticket['priority']}'),
              const SizedBox(height: 8),
              Text('Status: ${ticket['status']}'),
              const SizedBox(height: 8),
              Text('Category: ${ticket['category']}'),
              const SizedBox(height: 8),
              Text('Estimated Time: ${ticket['estimatedTime']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
