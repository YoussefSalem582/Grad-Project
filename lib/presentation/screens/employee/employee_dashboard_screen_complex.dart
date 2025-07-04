import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import 'employee_customer_interactions_screen.dart';
import 'employee_performance_screen.dart';
import 'employee_text_analysis_screen.dart';
import 'employee_voice_analysis_screen.dart';
import 'employee_video_analysis_screen.dart';
import 'employee_analysis_tools_screen.dart';
import '../analysis/batch_processing_screen.dart';

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
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

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
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
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
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
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
      _currentHeroIndex =
          (_currentHeroIndex + 1) % 4; // Changed to 4 hero cards
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
    _shimmerController.dispose();
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

  // Mobile Layout
  Widget _buildMobileLayout(BuildContext context, CustomSpacing customSpacing) {
    return Column(
      children: [
        _buildEnhancedHeroSection(context, customSpacing),
        _buildAnalysisToolsSection(context, customSpacing),
        _buildQuickActionsGrid(context, customSpacing),
        _buildRecentActivitySection(context, customSpacing),
        _buildPerformanceInsights(context, customSpacing),
        _buildUpcomingTasks(context, customSpacing),
        SizedBox(height: customSpacing.xl * 2), // Bottom padding for FAB
      ],
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout(BuildContext context, CustomSpacing customSpacing) {
    return Column(
      children: [
        _buildEnhancedHeroSection(context, customSpacing),
        _buildAnalysisToolsSection(context, customSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildQuickActionsGrid(context, customSpacing),
                  _buildRecentActivitySection(context, customSpacing),
                ],
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildPerformanceInsights(context, customSpacing),
                  _buildUpcomingTasks(context, customSpacing),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: customSpacing.xl * 2),
      ],
    );
  }

  // Desktop Layout
  Widget _buildDesktopLayout(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      margin: EdgeInsets.symmetric(horizontal: customSpacing.xl),
      child: Column(
        children: [
          _buildEnhancedHeroSection(context, customSpacing),
          _buildAnalysisToolsSection(context, customSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildQuickActionsGrid(context, customSpacing),
                    _buildRecentActivitySection(context, customSpacing),
                  ],
                ),
              ),
              SizedBox(width: customSpacing.lg),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildPerformanceInsights(context, customSpacing),
                    _buildUpcomingTasks(context, customSpacing),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.xl * 2),
        ],
      ),
    );
  }

  // Enhanced Hero Section with Premium Design
  Widget _buildEnhancedHeroSection(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      height: context.isMobile ? 280 : 320,
      child: Stack(
        children: [
          // Advanced gradient background with multiple layers
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667EEA),
                  Color(0xFF764BA2),
                  Color(0xFF48CAE4),
                  Color(0xFF667EEA),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: const Color(0xFF764BA2).withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),

          // Animated shimmer overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(
                          -1.0 + 2.0 * _shimmerAnimation.value,
                          -1.0,
                        ),
                        end: Alignment(
                          1.0 + 2.0 * _shimmerAnimation.value,
                          1.0,
                        ),
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.4, 0.6, 1.0],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Floating decoration elements
          _buildFloatingElements(customSpacing),

          // Main content
          Padding(
            padding: EdgeInsets.all(customSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced profile section
                _buildProfileSection(context, customSpacing),
                SizedBox(height: customSpacing.lg),

                // Hero stats carousel
                Expanded(
                  child: PageView.builder(
                    controller: _heroController,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return _buildEnhancedHeroStatCard(index, customSpacing);
                    },
                  ),
                ),

                SizedBox(height: customSpacing.md),

                // Enhanced page indicators
                _buildPageIndicators(customSpacing),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElements(CustomSpacing customSpacing) {
    return Stack(
      children: [
        // Large floating circle
        Positioned(
          top: 20,
          right: 40,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
        // Medium floating circle
        Positioned(
          bottom: 30,
          left: 30,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 2.0 - _pulseAnimation.value,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
        // Small floating circle
        Positioned(
          top: 80,
          left: 50,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value * 0.8,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Row(
      children: [
        // Enhanced avatar with online indicator
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF48CAE4), Color(0xFF667EEA)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(width: customSpacing.md),

        // Enhanced greeting and role
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning, Youssef! 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: context.isMobile ? 18 : 22,
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(1, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.sm,
                  vertical: customSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Senior Customer Experience Specialist',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Enhanced notification badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: customSpacing.sm,
            vertical: customSpacing.xs,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.warning, Color(0xFFFF8A50)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.warning.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedHeroStatCard(int index, CustomSpacing customSpacing) {
    final stats = [
      {
        'title': 'Today\'s Analysis',
        'value': '24',
        'icon': Icons.analytics,
        'trend': '+15%',
        'color': const Color(0xFF48CAE4),
        'subtitle': 'Text, Voice & Video',
      },
      {
        'title': 'Customer Satisfaction',
        'value': '4.9/5',
        'icon': Icons.star,
        'trend': '+0.3',
        'color': const Color(0xFFFFD700),
        'subtitle': 'Based on 47 reviews',
      },
      {
        'title': 'Response Time',
        'value': '1.3s',
        'icon': Icons.speed,
        'trend': '-12%',
        'color': const Color(0xFF4CAF50),
        'subtitle': 'Average today',
      },
      {
        'title': 'Active Conversations',
        'value': '8',
        'icon': Icons.chat_bubble,
        'trend': '+3',
        'color': const Color(0xFF9C27B0),
        'subtitle': 'Currently handling',
      },
    ];

    final stat = stats[index];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: customSpacing.xs),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and trend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (stat['color'] as Color).withValues(alpha: 0.8),
                      stat['color'] as Color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (stat['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  stat['icon'] as IconData,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.sm,
                  vertical: customSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  stat['trend'] as String,
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: customSpacing.md),

          // Main value
          Text(
            stat['value'] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(1, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),

          SizedBox(height: customSpacing.xs),

          // Title and subtitle
          Text(
            stat['title'] as String,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          Text(
            stat['subtitle'] as String,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators(CustomSpacing customSpacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: customSpacing.xs),
          width: _currentHeroIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: _currentHeroIndex == index
                ? const LinearGradient(
                    colors: [Colors.white, Color(0xFFE8F4FD)],
                  )
                : null,
            color: _currentHeroIndex != index
                ? Colors.white.withValues(alpha: 0.4)
                : null,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _currentHeroIndex == index
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  // Enhanced Analysis Tools Section with Premium Design
  Widget _buildAnalysisToolsSection(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: customSpacing.md,
        vertical: customSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: customSpacing.sm,
              vertical: customSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(customSpacing.sm),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome,
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
                        'AI Analysis Tools',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Powered by advanced machine learning',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _navigateToAnalysisTools(),
                  icon: Icon(Icons.arrow_forward, size: 16),
                  label: Text('View All'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: customSpacing.sm,
                      vertical: customSpacing.xs,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Analysis tools grid
          _buildAnalysisToolsGrid(context, customSpacing),
        ],
      ),
    );
  }

  Widget _buildAnalysisToolsGrid(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final crossAxisCount = isWide ? 3 : 1;

        if (crossAxisCount == 1) {
          // Mobile: Vertical list
          return Column(
            children: [
              _buildAnalysisToolCard(
                'Text Analysis',
                'Analyze messages, emails & feedback with sentiment analysis',
                Icons.text_fields,
                const Color(0xFF667EEA),
                '15 processed today',
                () => _navigateToTextAnalysis(),
                customSpacing,
              ),
              SizedBox(height: customSpacing.sm),
              _buildAnalysisToolCard(
                'Voice Analysis',
                'Process call recordings with emotion detection',
                Icons.mic,
                const Color(0xFF4CAF50),
                '8 calls analyzed',
                () => _navigateToVoiceAnalysis(),
                customSpacing,
              ),
              SizedBox(height: customSpacing.sm),
              _buildAnalysisToolCard(
                'Video Analysis',
                'Analyze customer videos with facial recognition',
                Icons.video_library,
                const Color(0xFF9C27B0),
                '3 videos processed',
                () => _navigateToVideoAnalysis(),
                customSpacing,
              ),
            ],
          );
        } else {
          // Tablet/Desktop: Grid
          return GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.md,
            mainAxisSpacing: customSpacing.md,
            childAspectRatio: 1.2,
            children: [
              _buildAnalysisToolCard(
                'Text Analysis',
                'Messages & feedback analysis',
                Icons.text_fields,
                const Color(0xFF667EEA),
                '15 today',
                () => _navigateToTextAnalysis(),
                customSpacing,
              ),
              _buildAnalysisToolCard(
                'Voice Analysis',
                'Call recordings analysis',
                Icons.mic,
                const Color(0xFF4CAF50),
                '8 calls',
                () => _navigateToVoiceAnalysis(),
                customSpacing,
              ),
              _buildAnalysisToolCard(
                'Video Analysis',
                'Customer videos analysis',
                Icons.video_library,
                const Color(0xFF9C27B0),
                '3 videos',
                () => _navigateToVideoAnalysis(),
                customSpacing,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildAnalysisToolCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String stats,
    VoidCallback onTap,
    CustomSpacing customSpacing,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.all(customSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(customSpacing.sm),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.8)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: context.isMobile ? 24 : 20,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: color.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ],
                  ),

                  Spacer(),

                  // Stats badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: customSpacing.sm,
                      vertical: customSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      stats,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: customSpacing.sm),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: context.isMobile ? 16 : 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),

                  SizedBox(height: customSpacing.xs),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: context.isMobile ? 12 : 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick Actions Grid
  Widget _buildQuickActionsGrid(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: customSpacing.sm),
            child: Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: customSpacing.md),

          // Actions grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: customSpacing.md,
                mainAxisSpacing: customSpacing.md,
                childAspectRatio: 1.1,
                children: [
                  _buildQuickActionCard(
                    'Customer Chats',
                    Icons.chat_bubble_outline,
                    AppColors.primary,
                    '8 active',
                    () => _navigateToCustomerInteractions(),
                    customSpacing,
                  ),
                  _buildQuickActionCard(
                    'Performance',
                    Icons.trending_up,
                    AppColors.success,
                    '92% score',
                    () => _navigateToPerformance(),
                    customSpacing,
                  ),
                  _buildQuickActionCard(
                    'Batch Analysis',
                    Icons.batch_prediction,
                    AppColors.warning,
                    'Process multiple',
                    () => _navigateToBatchProcessing(),
                    customSpacing,
                  ),
                  _buildQuickActionCard(
                    'Quick Text',
                    Icons.flash_on,
                    AppColors.accent,
                    'Instant analysis',
                    () => _navigateToTextAnalysis(),
                    customSpacing,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
    CustomSpacing customSpacing,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(customSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(height: customSpacing.sm),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: customSpacing.xs),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Recent Activity Section
  Widget _buildRecentActivitySection(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: customSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('View All')),
              ],
            ),
          ),
          SizedBox(height: customSpacing.sm),

          // Activity cards
          _buildActivityCard(
            'Text Analysis Completed',
            'Customer feedback from chat #2847',
            Icons.text_fields,
            AppColors.success,
            '2 minutes ago',
            customSpacing,
          ),
          _buildActivityCard(
            'Voice Call Analyzed',
            'Call with customer Sarah Johnson',
            Icons.mic,
            AppColors.primary,
            '15 minutes ago',
            customSpacing,
          ),
          _buildActivityCard(
            'New Customer Message',
            'Response needed in chat #2850',
            Icons.message,
            AppColors.warning,
            '23 minutes ago',
            customSpacing,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String time,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Performance Insights Section
  Widget _buildPerformanceInsights(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: customSpacing.sm),
            child: Text(
              'Performance Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: customSpacing.md),

          // Performance cards
          _buildPerformanceCard(
            'Weekly Goal',
            '87%',
            'Complete',
            Icons.flag,
            AppColors.success,
            customSpacing,
          ),
          _buildPerformanceCard(
            'Avg Response',
            '1.3s',
            'Excellent',
            Icons.speed,
            AppColors.primary,
            customSpacing,
          ),
          _buildPerformanceCard(
            'Customer Rating',
            '4.9/5',
            '+0.3 this week',
            Icons.star,
            AppColors.warning,
            customSpacing,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.08),
            color.withValues(alpha: 0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.sm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Upcoming Tasks Section
  Widget _buildUpcomingTasks(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: customSpacing.sm),
            child: Text(
              'Upcoming Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: customSpacing.md),

          // Task items
          _buildTaskItem(
            'Review video analysis results',
            'Due in 2 hours',
            AppColors.warning,
            true,
            customSpacing,
          ),
          _buildTaskItem(
            'Customer follow-up call',
            'Scheduled for 3:00 PM',
            AppColors.primary,
            false,
            customSpacing,
          ),
          _buildTaskItem(
            'Weekly performance review',
            'Due tomorrow',
            AppColors.success,
            false,
            customSpacing,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    String task,
    String time,
    Color color,
    bool isUrgent,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? color.withValues(alpha: 0.3) : AppColors.border,
          width: isUrgent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isUrgent ? Icons.schedule : Icons.schedule_outlined,
                      size: 12,
                      color: color,
                    ),
                    SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isUrgent)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: customSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'URGENT',
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToAnalysisTools() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeAnalysisToolsScreen(),
      ),
    );
  }

  void _navigateToTextAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeTextAnalysisScreen(),
      ),
    );
  }

  void _navigateToVoiceAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeVoiceAnalysisScreen(),
      ),
    );
  }

  void _navigateToVideoAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeVideoAnalysisScreen(),
      ),
    );
  }

  void _navigateToCustomerInteractions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeCustomerInteractionsScreen(),
      ),
    );
  }

  void _navigateToPerformance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeePerformanceScreen(),
      ),
    );
  }

  void _navigateToBatchProcessing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BatchProcessingScreen()),
    );
  }
}
