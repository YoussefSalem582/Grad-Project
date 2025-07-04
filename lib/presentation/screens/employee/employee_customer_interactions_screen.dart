import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class EmployeeCustomerInteractionsScreen extends StatefulWidget {
  const EmployeeCustomerInteractionsScreen({super.key});

  @override
  State<EmployeeCustomerInteractionsScreen> createState() =>
      _EmployeeCustomerInteractionsScreenState();
}

class _EmployeeCustomerInteractionsScreenState
    extends State<EmployeeCustomerInteractionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _selectedTab = 0;
  final PageController _tabController = PageController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildAdvancedTabBar(theme, customSpacing),
            Expanded(
              child: PageView(
                controller: _tabController,
                onPageChanged: (index) {
                  setState(() => _selectedTab = index);
                },
                children: [
                  _buildActiveChatsSection(theme, customSpacing),
                  _buildMyTicketsSection(theme, customSpacing),
                  _buildAnalyticsSection(theme, customSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedTabBar(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.only(
        left: customSpacing.md,
        right: customSpacing.md,
        top: customSpacing.lg, // Increased top margin since no local app bar
        bottom: customSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAdvancedTab('Active Chats', Icons.chat, 0, customSpacing),
          _buildAdvancedTab('My Tickets', Icons.assignment, 1, customSpacing),
          _buildAdvancedTab('Analytics', Icons.analytics, 2, customSpacing),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab(
    String title,
    IconData icon,
    int index,
    CustomSpacing customSpacing,
  ) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = index);
          _tabController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: customSpacing.md,
            horizontal: customSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 18,
              ),
              SizedBox(width: customSpacing.xs),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveChatsSection(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Conversations',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.sm,
                  vertical: customSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '8 Active',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          // Priority chats
          Container(
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.error.withValues(alpha: 0.05),
                  AppColors.warning.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(customSpacing.sm),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.priority_high,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'High Priority Chats',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                      Text(
                        '3 customers waiting > 5 minutes',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ModernButton(
                  onPressed: _viewAllChats,
                  style: ModernButtonStyle.outlined,
                  text: 'View All',
                  size: ModernButtonSize.small,
                ),
              ],
            ),
          ),
          SizedBox(height: customSpacing.lg),

          // Chat list
          ...List.generate(5, (index) {
            return _buildAdvancedChatCard(index, customSpacing);
          }),
        ],
      ),
    );
  }

  Widget _buildAdvancedChatCard(int index, CustomSpacing customSpacing) {
    final customers = [
      {
        'name': 'Sarah Johnson',
        'message': 'Hi, I need help with my recent order #12345...',
        'time': '2 min ago',
        'priority': 'High',
        'status': 'Active',
        'avatar': 'S',
        'color': AppColors.error,
      },
      {
        'name': 'Mike Chen',
        'message': 'The product arrived damaged, what should I do?',
        'time': '5 min ago',
        'priority': 'Medium',
        'status': 'Waiting',
        'avatar': 'M',
        'color': AppColors.warning,
      },
      {
        'name': 'Emily Davis',
        'message': 'Can you help me track my shipment?',
        'time': '10 min ago',
        'priority': 'Low',
        'status': 'Active',
        'avatar': 'E',
        'color': AppColors.success,
      },
      {
        'name': 'Robert Wilson',
        'message': 'I want to return this item, how do I proceed?',
        'time': '15 min ago',
        'priority': 'Medium',
        'status': 'Pending',
        'avatar': 'R',
        'color': AppColors.info,
      },
      {
        'name': 'Lisa Anderson',
        'message': 'Thank you for the excellent service!',
        'time': '1 hour ago',
        'priority': 'Low',
        'status': 'Resolved',
        'avatar': 'L',
        'color': AppColors.success,
      },
    ];

    final customer = customers[index];

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (customer['color'] as Color).withValues(alpha: 0.2),
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
      child: InkWell(
        onTap: () => _openChat(customer['name'] as String),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(customSpacing.md),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              customer['color'] as Color,
                              (customer['color'] as Color).withValues(
                                alpha: 0.8,
                              ),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            customer['avatar'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              customer['status'] as String,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: customSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                customer['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: customSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (customer['color'] as Color).withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                customer['priority'] as String,
                                style: TextStyle(
                                  color: customer['color'] as Color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: customSpacing.xs),
                        Text(
                          customer['message'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: customSpacing.sm),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: AppColors.textLight),
                  SizedBox(width: customSpacing.xs),
                  Text(
                    customer['time'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: customSpacing.sm,
                      vertical: customSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        customer['status'] as String,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      customer['status'] as String,
                      style: TextStyle(
                        color: _getStatusColor(customer['status'] as String),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: customSpacing.sm),
                  ModernButton(
                    onPressed: () => _openChat(customer['name'] as String),
                    style: ModernButtonStyle.ghost,
                    text: '',
                    icon: Icons.arrow_forward,
                    size: ModernButtonSize.small,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'waiting':
        return AppColors.warning;
      case 'pending':
        return AppColors.info;
      case 'resolved':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildMyTicketsSection(ThemeData theme, CustomSpacing customSpacing) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'My Support Tickets',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              ModernButton(
                onPressed: _createNewTicket,
                style: ModernButtonStyle.primary,
                text: 'New Ticket',
                icon: Icons.add,
                size: ModernButtonSize.small,
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          // Filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 12, true, customSpacing),
                _buildFilterChip('Open', 8, false, customSpacing),
                _buildFilterChip('In Progress', 3, false, customSpacing),
                _buildFilterChip('Resolved', 45, false, customSpacing),
              ],
            ),
          ),
          SizedBox(height: customSpacing.lg),

          // Tickets list
          ...List.generate(4, (index) {
            return _buildTicketCard(index, customSpacing);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    int count,
    bool isSelected,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(right: customSpacing.sm),
      child: FilterChip(
        label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (selected) {},
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTicketCard(int index, CustomSpacing customSpacing) {
    final tickets = [
      {
        'id': '#TK-001',
        'title': 'Product Quality Issue',
        'description': 'Customer reports defective product received',
        'priority': 'High',
        'status': 'Open',
        'assignee': 'You',
        'created': '2 hours ago',
        'customer': 'Sarah Johnson',
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
      },
      {
        'id': '#TK-003',
        'title': 'Refund Request',
        'description': 'Customer wants to return and get refund',
        'priority': 'Low',
        'status': 'Pending',
        'assignee': 'Team Lead',
        'created': '1 day ago',
        'customer': 'Emily Davis',
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
      },
    ];

    final ticket = tickets[index];
    final priorityColor = _getPriorityColor(ticket['priority'] as String);

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
                    ticket['id'] as String,
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
                    ticket['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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
                    ticket['priority'] as String,
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
              ticket['description'] as String,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: customSpacing.md),
            Row(
              children: [
                _buildTicketInfo('Customer', ticket['customer'] as String),
                SizedBox(width: customSpacing.md),
                _buildTicketInfo('Assignee', ticket['assignee'] as String),
                SizedBox(width: customSpacing.md),
                _buildTicketInfo('Created', ticket['created'] as String),
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
                    color: _getStatusColor(
                      ticket['status'] as String,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ticket['status'] as String,
                    style: TextStyle(
                      color: _getStatusColor(ticket['status'] as String),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                ModernButton(
                  onPressed: _viewTicketDetails,
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

  Widget _buildTicketInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

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

  Widget _buildAnalyticsSection(ThemeData theme, CustomSpacing customSpacing) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interaction Analytics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          // Analytics cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.md,
            mainAxisSpacing: customSpacing.md,
            childAspectRatio: 1.2,
            children: [
              _buildAnalyticsCard(
                'Response Time',
                '2.1 min',
                'avg',
                Icons.timer,
                AppColors.primary,
                '-15% vs last week',
                customSpacing,
              ),
              _buildAnalyticsCard(
                'Resolution Rate',
                '94%',
                'success',
                Icons.check_circle,
                AppColors.success,
                '+5% vs last week',
                customSpacing,
              ),
              _buildAnalyticsCard(
                'Customer Satisfaction',
                '4.8/5',
                'rating',
                Icons.star,
                AppColors.warning,
                '+0.2 vs last week',
                customSpacing,
              ),
              _buildAnalyticsCard(
                'Active Hours',
                '7.5h',
                'today',
                Icons.access_time,
                AppColors.info,
                'Target: 8h',
                customSpacing,
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          // Performance chart placeholder
          Container(
            height: 200,
            padding: EdgeInsets.all(customSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Performance Trend',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: customSpacing.md),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 48,
                          color: AppColors.success,
                        ),
                        SizedBox(height: customSpacing.sm),
                        const Text(
                          'Performance trending upward',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const Text(
                          'Chart visualization would go here',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    String trend,
    CustomSpacing customSpacing,
  ) {
    return Container(
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.xs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: AppColors.success, size: 16),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.xs),
          Text(
            trend,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(String customerName) {
    // Navigate to chat screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.chat, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Chat with $customerName'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildChatMessage(
                        'Hello! How can I help you today?',
                        true,
                      ),
                      _buildChatMessage(
                        'Hi, I need help with my order #12345',
                        false,
                      ),
                      _buildChatMessage(
                        'Of course! Let me check that for you.',
                        true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add send message logic
                    },
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String message, bool isFromAgent) {
    return Align(
      alignment: isFromAgent ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isFromAgent
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
        ),
      ),
    );
  }

  void _viewAllChats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('All Customer Chats'),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text('C${index + 1}'),
                  backgroundColor: AppColors.primary,
                ),
                title: Text('Customer ${index + 1}'),
                subtitle: Text('Last message...'),
                trailing: Text('${index + 1}h ago'),
                onTap: () {
                  Navigator.pop(context);
                  _openChat('Customer ${index + 1}');
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _createNewTicket() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add_circle, color: AppColors.primary),
            SizedBox(width: 8),
            Text('New Support Ticket'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Issue Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ticket created successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Create Ticket'),
          ),
        ],
      ),
    );
  }

  void _viewTicketDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ticket Details'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Ticket ID', '#TK-001'),
              _buildDetailRow('Customer', 'Sarah Johnson'),
              _buildDetailRow('Priority', 'High'),
              _buildDetailRow('Status', 'Open'),
              _buildDetailRow('Created', '2 hours ago'),
              _buildDetailRow('Assignee', 'You'),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Customer reports defective product received. Product arrived damaged and needs immediate replacement.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ticket updated!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Update Status'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
