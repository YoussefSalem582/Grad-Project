import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final PageController _heroController = PageController();
  int _currentHeroIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAutoSlide();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutQuart,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _nextHeroSlide();
        _startAutoSlide();
      }
    });
  }

  void _nextHeroSlide() {
    setState(() {
      _currentHeroIndex = (_currentHeroIndex + 1) % 3;
    });
    _heroController.animateToPage(
      _currentHeroIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _heroController.dispose();
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
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: context.responsivePadding(
              mobile: 0,
              tablet: 0,
              desktop: 0,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (context.isMobile) {
                  return _buildMobileLayout(context, customSpacing);
                } else if (context.isTablet) {
                  return _buildTabletLayout(context, customSpacing);
                } else {
                  return _buildDesktopLayout(context, customSpacing);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeroSection(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      height: 260,
      child: Stack(
        children: [
          // Background gradient with blur effect
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667EEA),
                  Color(0xFF764BA2),
                  Color(0xFF48CAE4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),

          // Floating shapes animation
          Positioned(
            top: 20,
            right: 30,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(customSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Profile section
                    Container(
                      padding: EdgeInsets.all(customSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: customSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning, John! 👋',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Senior Customer Experience Specialist',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Notification indicator
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: customSpacing.sm,
                        vertical: customSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: customSpacing.md),

                // Live stats carousel
                Container(
                  height: 90,
                  child: PageView.builder(
                    controller: _heroController,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildHeroStatCard(index, customSpacing);
                    },
                  ),
                ),

                SizedBox(height: customSpacing.sm),

                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(
                        horizontal: customSpacing.xs,
                      ),
                      width: _currentHeroIndex == index ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentHeroIndex == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatCard(int index, CustomSpacing customSpacing) {
    final stats = [
      {
        'title': 'Today\'s Analysis',
        'value': '24',
        'icon': Icons.analytics,
        'trend': '+15%',
      },
      {
        'title': 'Customer Satisfaction',
        'value': '4.9',
        'icon': Icons.star,
        'trend': '+0.3',
      },
      {
        'title': 'Response Time',
        'value': '1.3s',
        'icon': Icons.speed,
        'trend': '-12%',
      },
    ];

    final stat = stats[index];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: customSpacing.xs),
      padding: EdgeInsets.all(customSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              stat['icon'] as IconData,
              color: Colors.white,
              size: 18,
            ),
          ),
          SizedBox(width: customSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat['title'] as String,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        stat['value'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: customSpacing.xs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: customSpacing.xs,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        stat['trend'] as String,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetricsDashboard(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Expanded(
                child: Text(
                  'Live Metrics Dashboard',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.sm,
                  vertical: customSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: customSpacing.xs),
                    const Text(
                      'Live',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.md),

          // Metrics grid with better constraints
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.sm,
            mainAxisSpacing: customSpacing.sm,
            childAspectRatio: 1.2,
            children: [
              _buildAdvancedMetricCard(
                'Active Chats',
                '8',
                Icons.chat_bubble_outline,
                AppColors.primary,
                '+2 from yesterday',
                customSpacing,
              ),
              _buildAdvancedMetricCard(
                'Pending Tasks',
                '12',
                Icons.pending_actions,
                AppColors.warning,
                '3 high priority',
                customSpacing,
              ),
              _buildAdvancedMetricCard(
                'Resolved Today',
                '45',
                Icons.check_circle_outline,
                AppColors.success,
                '94% success rate',
                customSpacing,
              ),
              _buildAdvancedMetricCard(
                'AI Insights',
                '7',
                Icons.psychology,
                AppColors.accent,
                'New recommendations',
                customSpacing,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
    CustomSpacing customSpacing,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Background pattern - constrained properly
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(customSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(customSpacing.sm),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withValues(alpha: 0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                    const Spacer(),
                    Icon(Icons.trending_up, color: AppColors.success, size: 14),
                  ],
                ),

                SizedBox(height: customSpacing.xs),

                // Value and labels with proper constraints
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightsSection(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Text(
                'AI-Powered Insights',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          Container(
            padding: EdgeInsets.all(customSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withValues(alpha: 0.05),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: customSpacing.sm),
                    const Text(
                      'Smart Recommendation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Just now',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: customSpacing.md),
                const Text(
                  'Based on your recent interactions, consider focusing on proactive outreach to customers who haven\'t responded in 2+ days. This could improve your response rate by 23%.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: customSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: ModernButton(
                        onPressed: () {},
                        style: ModernButtonStyle.primary,
                        text: 'Apply Suggestion',
                        icon: Icons.auto_fix_high,
                      ),
                    ),
                    SizedBox(width: customSpacing.sm),
                    ModernButton(
                      onPressed: () {},
                      style: ModernButtonStyle.ghost,
                      text: '',
                      icon: Icons.close,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedAnalyticsGrid(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Analytics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'Sentiment Trend',
                  '↗ Positive',
                  Icons.sentiment_very_satisfied,
                  AppColors.success,
                  customSpacing,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: _buildAnalyticsCard(
                  'Peak Hours',
                  '2-4 PM',
                  Icons.schedule,
                  AppColors.primary,
                  customSpacing,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
    CustomSpacing customSpacing,
  ) {
    return Container(
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
          Icon(icon, color: color, size: 24),
          SizedBox(height: customSpacing.md),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: customSpacing.xs),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          Container(
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
              children: [
                _buildTimelineItem(
                  'Completed text analysis for Customer #4521',
                  '2 minutes ago',
                  Icons.text_fields,
                  AppColors.success,
                  customSpacing,
                ),
                _buildTimelineItem(
                  'New chat message received',
                  '5 minutes ago',
                  Icons.chat,
                  AppColors.primary,
                  customSpacing,
                ),
                _buildTimelineItem(
                  'AI generated customer insight',
                  '12 minutes ago',
                  Icons.psychology,
                  AppColors.accent,
                  customSpacing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time,
    IconData icon,
    Color color,
    CustomSpacing customSpacing,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: customSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: customSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsHub(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.md,
            mainAxisSpacing: customSpacing.md,
            childAspectRatio: 2.5,
            children: [
              _buildQuickActionCard(
                'Start Analysis',
                Icons.play_arrow,
                AppColors.primary,
                customSpacing,
              ),
              _buildQuickActionCard(
                'View Reports',
                Icons.assessment,
                AppColors.secondary,
                customSpacing,
              ),
              _buildQuickActionCard(
                'Customer Chat',
                Icons.chat,
                AppColors.success,
                customSpacing,
              ),
              _buildQuickActionCard(
                'Settings',
                Icons.settings,
                AppColors.textSecondary,
                customSpacing,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    CustomSpacing customSpacing,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(customSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: customSpacing.sm),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceInsights(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: AppColors.primary, size: 24),
              SizedBox(width: customSpacing.sm),
              Text(
                'Performance Insights',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          const Text(
            'You\'re performing exceptionally well this week! Your customer satisfaction rate is 15% above average, and your response time has improved by 23%.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          Row(
            children: [
              Expanded(
                child: ModernButton(
                  onPressed: () {},
                  style: ModernButtonStyle.primary,
                  text: 'View Detailed Report',
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Responsive Layout Methods
  Widget _buildMobileLayout(BuildContext context, CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernHeroSection(Theme.of(context), customSpacing),
        SizedBox(
          height: context.responsiveSpacing(
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        _buildLiveMetricsDashboard(Theme.of(context), customSpacing),
        SizedBox(
          height: context.responsiveSpacing(
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        _buildQuickActionsHub(Theme.of(context), customSpacing),
        SizedBox(
          height: context.responsiveSpacing(
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        _buildPerformanceInsights(Theme.of(context), customSpacing),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernHeroSection(Theme.of(context), customSpacing),
        SizedBox(
          height: context.responsiveSpacing(
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildLiveMetricsDashboard(Theme.of(context), customSpacing),
                  SizedBox(
                    height: context.responsiveSpacing(
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  _buildQuickActionsHub(Theme.of(context), customSpacing),
                ],
              ),
            ),
            SizedBox(
              width: context.responsiveSpacing(
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildPerformanceInsights(Theme.of(context), customSpacing),
                  SizedBox(
                    height: context.responsiveSpacing(
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  _buildActivityTimeline(Theme.of(context), customSpacing),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernHeroSection(Theme.of(context), customSpacing),
        SizedBox(
          height: context.responsiveSpacing(
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildLiveMetricsDashboard(Theme.of(context), customSpacing),
                  SizedBox(
                    height: context.responsiveSpacing(
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  _buildQuickActionsHub(Theme.of(context), customSpacing),
                ],
              ),
            ),
            SizedBox(
              width: context.responsiveSpacing(
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildPerformanceInsights(Theme.of(context), customSpacing),
                  SizedBox(
                    height: context.responsiveSpacing(
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  _buildActivityTimeline(Theme.of(context), customSpacing),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
