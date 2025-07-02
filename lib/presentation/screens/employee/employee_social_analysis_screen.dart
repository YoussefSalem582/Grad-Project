import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class EmployeeSocialAnalysisScreen extends StatefulWidget {
  const EmployeeSocialAnalysisScreen({super.key});

  @override
  State<EmployeeSocialAnalysisScreen> createState() =>
      _EmployeeSocialAnalysisScreenState();
}

class _EmployeeSocialAnalysisScreenState
    extends State<EmployeeSocialAnalysisScreen>
    with TickerProviderStateMixin {
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedPlatform = 'Auto-detect';
  String _selectedAnalysisType = 'Comprehensive';
  String _selectedTimeframe = 'Last 24h';
  bool _isAnalyzing = false;
  bool _isLiveMonitoring = false;
  int _selectedTabIndex = 0;

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _chartController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _chartAnimation;

  final Map<String, dynamic> _liveMetrics = {
    'mentions': 247,
    'sentiment_positive': 78,
    'sentiment_neutral': 15,
    'sentiment_negative': 7,
    'engagement_rate': 4.2,
    'trending_score': 8.7,
    'reach_estimate': 15400,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLiveUpdates();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutQuart,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.elasticOut,
    );

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _startLiveUpdates() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isLiveMonitoring) {
        setState(() {
          _liveMetrics['mentions'] =
              _liveMetrics['mentions'] + (1 + (DateTime.now().millisecond % 3));
          _liveMetrics['engagement_rate'] =
              4.0 + (DateTime.now().millisecond % 10) / 10;
        });
        _startLiveUpdates();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _chartController.dispose();
    _linkController.dispose();
    _searchController.dispose();
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
        child: CustomScrollView(
          slivers: [
            // Enhanced Hero Header
            SliverToBoxAdapter(
              child: _buildEnhancedHeroHeader(theme, customSpacing),
            ),

            // Navigation Tabs
            SliverToBoxAdapter(
              child: _buildNavigationTabs(theme, customSpacing),
            ),

            // Tab Content
            SliverToBoxAdapter(child: _buildTabContent(theme, customSpacing)),

            // Bottom Padding
            SliverToBoxAdapter(child: SizedBox(height: customSpacing.xxl * 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeroHeader(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
            Color(0xFF48CAE4),
            Color(0xFF5B73E8),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background elements
          Positioned(
            top: -20,
            right: -20,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(customSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(customSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.trending_up,
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
                            'Social Media Intelligence',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: customSpacing.xs),
                          Text(
                            'AI-Powered Sentiment Analysis & Brand Monitoring',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Live monitoring toggle
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isLiveMonitoring
                              ? _pulseAnimation.value
                              : 1.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLiveMonitoring = !_isLiveMonitoring;
                                if (_isLiveMonitoring) {
                                  _startLiveUpdates();
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: customSpacing.md,
                                vertical: customSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: _isLiveMonitoring
                                    ? AppColors.success.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _isLiveMonitoring
                                      ? AppColors.success
                                      : Colors.white.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _isLiveMonitoring
                                          ? AppColors.success
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: customSpacing.xs),
                                  Text(
                                    _isLiveMonitoring ? 'LIVE' : 'OFF',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: customSpacing.lg),

                // Live metrics row
                Row(
                  children: [
                    Expanded(
                      child: _buildLiveMetricCard(
                        'Mentions',
                        '${_liveMetrics['mentions']}',
                        Icons.campaign,
                        '+12 today',
                        customSpacing,
                      ),
                    ),
                    SizedBox(width: customSpacing.sm),
                    Expanded(
                      child: _buildLiveMetricCard(
                        'Sentiment',
                        '${_liveMetrics['sentiment_positive']}%',
                        Icons.sentiment_very_satisfied,
                        'Positive',
                        customSpacing,
                      ),
                    ),
                    SizedBox(width: customSpacing.sm),
                    Expanded(
                      child: _buildLiveMetricCard(
                        'Engagement',
                        '${_liveMetrics['engagement_rate']}%',
                        Icons.favorite,
                        'Rate',
                        customSpacing,
                      ),
                    ),
                    SizedBox(width: customSpacing.sm),
                    Expanded(
                      child: _buildLiveMetricCard(
                        'Reach',
                        '${(_liveMetrics['reach_estimate'] / 1000).toStringAsFixed(1)}K',
                        Icons.visibility,
                        'Estimated',
                        customSpacing,
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

  Widget _buildLiveMetricCard(
    String title,
    String value,
    IconData icon,
    String subtitle,
    CustomSpacing customSpacing,
  ) {
    return Container(
      padding: EdgeInsets.all(customSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          SizedBox(height: customSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white60, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTabs(ThemeData theme, CustomSpacing customSpacing) {
    final tabs = [
      {'title': 'Analysis', 'icon': Icons.analytics},
      {'title': 'Monitor', 'icon': Icons.monitor},
      {'title': 'Insights', 'icon': Icons.lightbulb},
      {'title': 'Reports', 'icon': Icons.assessment},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: customSpacing.md),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTabIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: customSpacing.xs),
                padding: EdgeInsets.symmetric(
                  vertical: customSpacing.md,
                  horizontal: customSpacing.sm,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(height: customSpacing.xs),
                    Text(
                      tab['title'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme, CustomSpacing customSpacing) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildAnalysisTab(theme, customSpacing);
      case 1:
        return _buildMonitorTab(theme, customSpacing);
      case 2:
        return _buildInsightsTab(theme, customSpacing);
      case 3:
        return _buildReportsTab(theme, customSpacing);
      default:
        return _buildAnalysisTab(theme, customSpacing);
    }
  }

  Widget _buildAnalysisTab(ThemeData theme, CustomSpacing customSpacing) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: EdgeInsets.all(customSpacing.md),
        child: Column(
          children: [
            // Enhanced Analysis Input
            _buildEnhancedAnalysisInput(theme, customSpacing),

            SizedBox(height: customSpacing.lg),

            // Platform Selection Grid
            _buildPlatformSelectionGrid(theme, customSpacing),

            SizedBox(height: customSpacing.lg),

            // Quick Actions
            _buildQuickActions(theme, customSpacing),

            SizedBox(height: customSpacing.lg),

            // Recent Analysis Results
            _buildRecentAnalysisResults(theme, customSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedAnalysisInput(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.link, color: Colors.white, size: 20),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Social Media Analysis',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Enter URL or search terms for comprehensive analysis',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: customSpacing.lg),

          // Enhanced input field with multiple options
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // URL Input
                Container(
                  padding: EdgeInsets.all(customSpacing.md),
                  child: TextField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      hintText:
                          'Paste social media URL or enter search terms...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.link, color: AppColors.primary),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.paste),
                            onPressed: _pasteFromClipboard,
                            color: AppColors.primary,
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _linkController.clear(),
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    maxLines: 3,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),

                // Analysis options row
                Container(
                  padding: EdgeInsets.all(customSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Platform selector
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPlatform,
                          decoration: InputDecoration(
                            labelText: 'Platform',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: customSpacing.md,
                              vertical: customSpacing.sm,
                            ),
                          ),
                          items:
                              [
                                    'Auto-detect',
                                    'Twitter/X',
                                    'Facebook',
                                    'Instagram',
                                    'LinkedIn',
                                    'TikTok',
                                    'YouTube',
                                    'Reddit',
                                    'Pinterest',
                                  ]
                                  .map(
                                    (platform) => DropdownMenuItem(
                                      value: platform,
                                      child: Text(platform),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedPlatform = value!),
                        ),
                      ),

                      SizedBox(width: customSpacing.md),

                      // Analysis type
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedAnalysisType,
                          decoration: InputDecoration(
                            labelText: 'Analysis Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: customSpacing.md,
                              vertical: customSpacing.sm,
                            ),
                          ),
                          items:
                              [
                                    'Comprehensive',
                                    'Sentiment Only',
                                    'Engagement Analysis',
                                    'Trend Analysis',
                                    'Competitor Analysis',
                                  ]
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedAnalysisType = value!),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: customSpacing.lg),

          // Enhanced analyze button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: _isAnalyzing
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.5),
                        AppColors.secondary.withValues(alpha: 0.5),
                      ],
                    )
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _isAnalyzing ? null : _analyzeLink,
                child: Center(
                  child: _isAnalyzing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: customSpacing.md),
                            const Text(
                              'Analyzing...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: customSpacing.sm),
                            const Text(
                              'Start AI Analysis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformSelectionGrid(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    final platforms = [
      {
        'name': 'Twitter/X',
        'icon': Icons.chat,
        'color': const Color(0xFF1DA1F2),
        'posts': '1.2K',
      },
      {
        'name': 'Facebook',
        'icon': Icons.facebook,
        'color': const Color(0xFF4267B2),
        'posts': '856',
      },
      {
        'name': 'Instagram',
        'icon': Icons.camera_alt,
        'color': const Color(0xFFE4405F),
        'posts': '2.3K',
      },
      {
        'name': 'LinkedIn',
        'icon': Icons.work,
        'color': const Color(0xFF2867B2),
        'posts': '432',
      },
      {
        'name': 'TikTok',
        'icon': Icons.music_note,
        'color': const Color(0xFF000000),
        'posts': '1.8K',
      },
      {
        'name': 'YouTube',
        'icon': Icons.play_arrow,
        'color': const Color(0xFFFF0000),
        'posts': '567',
      },
    ];

    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Insights',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.sm),
          Text(
            'Real-time mentions across platforms',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: platforms.length,
            itemBuilder: (context, index) {
              final platform = platforms[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (platform['color'] as Color).withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (platform['color'] as Color).withValues(
                        alpha: 0.1,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(customSpacing.sm),
                      decoration: BoxDecoration(
                        color: (platform['color'] as Color).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        platform['icon'] as IconData,
                        color: platform['color'] as Color,
                        size: 24,
                      ),
                    ),
                    SizedBox(height: customSpacing.xs),
                    Text(
                      platform['posts'] as String,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: platform['color'] as Color,
                      ),
                    ),
                    Text(
                      platform['name'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, CustomSpacing customSpacing) {
    final actions = [
      {
        'title': 'Hashtag Trends',
        'subtitle': 'Discover trending hashtags',
        'icon': Icons.tag,
        'color': AppColors.primary,
      },
      {
        'title': 'Competitor Analysis',
        'subtitle': 'Compare with competitors',
        'icon': Icons.compare_arrows,
        'color': AppColors.secondary,
      },
      {
        'title': 'Brand Mentions',
        'subtitle': 'Track brand mentions',
        'icon': Icons.notifications,
        'color': AppColors.warning,
      },
      {
        'title': 'Sentiment Report',
        'subtitle': 'Generate sentiment report',
        'icon': Icons.assessment,
        'color': AppColors.success,
      },
    ];

    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
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

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (action['color'] as Color).withValues(alpha: 0.1),
                      (action['color'] as Color).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (action['color'] as Color).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _handleQuickAction(action['title'] as String),
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(customSpacing.sm),
                            decoration: BoxDecoration(
                              color: action['color'] as Color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              action['icon'] as IconData,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: customSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  action['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  action['subtitle'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAnalysisResults(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    final results = [
      {
        'platform': 'Twitter',
        'url': 'twitter.com/brand/status/123...',
        'sentiment': 'Positive',
        'score': 0.85,
        'engagement': '1.2K',
        'time': '2 min ago',
        'color': AppColors.success,
      },
      {
        'platform': 'Instagram',
        'url': 'instagram.com/p/ABC123...',
        'sentiment': 'Neutral',
        'score': 0.62,
        'engagement': '856',
        'time': '5 min ago',
        'color': AppColors.warning,
      },
      {
        'platform': 'Facebook',
        'url': 'facebook.com/brand/posts/456...',
        'sentiment': 'Positive',
        'score': 0.78,
        'engagement': '2.1K',
        'time': '8 min ago',
        'color': AppColors.success,
      },
    ];

    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Analysis',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _selectedTabIndex = 3),
                child: const Text('View All'),
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          ...results
              .map(
                (result) => Container(
                  margin: EdgeInsets.only(bottom: customSpacing.md),
                  padding: EdgeInsets.all(customSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (result['color'] as Color).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: result['color'] as Color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: customSpacing.md),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  result['platform'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  result['time'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: customSpacing.xs),
                            Text(
                              result['url'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: customSpacing.sm),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: customSpacing.sm,
                                    vertical: customSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (result['color'] as Color)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    result['sentiment'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: result['color'] as Color,
                                    ),
                                  ),
                                ),
                                SizedBox(width: customSpacing.sm),
                                Text(
                                  '${((result['score'] as double) * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.favorite,
                                  size: 14,
                                  color: AppColors.error,
                                ),
                                SizedBox(width: customSpacing.xs),
                                Text(
                                  result['engagement'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  // Stub methods for other tabs - will implement if needed
  Widget _buildMonitorTab(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: GlassCard(
        padding: EdgeInsets.all(customSpacing.lg),
        child: Column(
          children: [
            Icon(Icons.monitor, size: 64, color: AppColors.primary),
            SizedBox(height: customSpacing.md),
            Text(
              'Live Monitoring Dashboard',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: customSpacing.sm),
            Text(
              'Real-time social media monitoring features coming soon',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTab(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: GlassCard(
        padding: EdgeInsets.all(customSpacing.lg),
        child: Column(
          children: [
            Icon(Icons.lightbulb, size: 64, color: AppColors.accent),
            SizedBox(height: customSpacing.md),
            Text(
              'AI Insights & Recommendations',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: customSpacing.sm),
            Text(
              'Intelligent insights and actionable recommendations',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: GlassCard(
        padding: EdgeInsets.all(customSpacing.lg),
        child: Column(
          children: [
            Icon(Icons.assessment, size: 64, color: AppColors.success),
            SizedBox(height: customSpacing.md),
            Text(
              'Analytics Reports',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: customSpacing.sm),
            Text(
              'Comprehensive analytics and reporting tools',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  void _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      _linkController.text = data!.text!;
    }
  }

  void _analyzeLink() {
    if (_linkController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a URL or search terms'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    // Simulate analysis
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        _chartController.forward();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analysis completed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _handleQuickAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
