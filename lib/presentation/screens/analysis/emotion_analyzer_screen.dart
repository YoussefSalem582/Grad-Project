import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';







import '../../widgets/widgets.dart';

import '../../../core/core.dart';
import 'batch_processing_screen.dart';
import '../core/model_info_screen.dart';

class EmotionAnalyzerScreen extends StatefulWidget {
  const EmotionAnalyzerScreen({Key? key}) : super(key: key);

  @override
  _EmotionAnalyzerScreenState createState() => _EmotionAnalyzerScreenState();
}

class _EmotionAnalyzerScreenState extends State<EmotionAnalyzerScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  // NEW: Tab controller for enhanced features
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _showEnhancedFeatures = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _onAnalyzePressed() {
    final provider = context.read<EmotionProvider>();
    provider.analyzeEmotion(_textController.text).then((_) {
      if (provider.state == EmotionState.success) {
        _fadeController.forward();
        _showSnackBar(AppStrings.successMessage, isError: false);
      } else if (provider.error != null) {
        _showSnackBar(provider.error!, isError: true);
      }
    });
  }

  // NEW: Handle demo example selection
  void _onDemoExampleSelected(String text) {
    _textController.text = text;
    if (_showEnhancedFeatures) {
      setState(() {
        _showEnhancedFeatures = false;
        _tabController.animateTo(0);
      });
    }
    _onAnalyzePressed();
  }

  // NEW: Show batch processing dialog
  void _showBatchProcessingDialog() {
    final batchTexts = <String>[];
    final textControllers = List.generate(
      5,
      (index) => TextEditingController(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batch Analysis'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter up to 5 texts for batch analysis:'),
              const SizedBox(height: 16),
              ...textControllers.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: 'Text ${entry.key + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final texts = textControllers
                  .map((controller) => controller.text.trim())
                  .where((text) => text.isNotEmpty)
                  .toList();

              if (texts.isNotEmpty) {
                context.read<EmotionProvider>().analyzeBatchEmotions(texts);
                Navigator.pop(context);
                _showSnackBar('Batch analysis started!', isError: false);
              }
            },
            child: const Text('Analyze'),
          ),
        ],
      ),
    );
  }

  // NEW: Show system health status
  String _getSystemHealthStatus() {
    final provider = context.read<EmotionProvider>();
    return provider.systemHealthStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildEnhancedAppBar(),
              if (_showEnhancedFeatures) _buildTabBar(),
              _buildMainContent(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEnhancedAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Enhanced v3.0 • AI + Analytics',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          // NEW: Enhanced features toggle
          IconButton(
            onPressed: () {
              setState(() {
                _showEnhancedFeatures = !_showEnhancedFeatures;
                if (!_showEnhancedFeatures) {
                  _tabController.animateTo(0);
                }
              });
            },
            icon: Icon(
              _showEnhancedFeatures ? Icons.close : Icons.dashboard,
              color: Colors.white,
              size: 24,
            ),
            tooltip: _showEnhancedFeatures
                ? 'Close Dashboard'
                : 'Open Dashboard',
          ),
          // NEW: Menu button
          PopupMenuButton<String>(
            onSelected: (value) {
              final provider = context.read<EmotionProvider>();
              switch (value) {
                case 'batch':
                  _showBatchProcessingDialog();
                  break;
                case 'refresh':
                  provider.refreshAllData();
                  _showSnackBar('Refreshing all data...', isError: false);
                  break;
                case 'metrics_toggle':
                  provider.toggleAutoRefreshMetrics();
                  _showSnackBar(
                    provider.autoRefreshMetrics
                        ? 'Auto-refresh enabled'
                        : 'Auto-refresh disabled',
                    isError: false,
                  );
                  break;
                case 'clear_cache':
                  provider.clearCache();
                  _showSnackBar('Cache cleared!', isError: false);
                  break;
              }
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'batch',
                child: Row(
                  children: [
                    Icon(Icons.batch_prediction),
                    SizedBox(width: 8),
                    Text('Batch Analysis'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Refresh All Data'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'metrics_toggle',
                child: Consumer<EmotionProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      children: [
                        Icon(
                          provider.autoRefreshMetrics
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          provider.autoRefreshMetrics
                              ? 'Pause Auto-refresh'
                              : 'Start Auto-refresh',
                        ),
                      ],
                    );
                  },
                ),
              ),
              const PopupMenuItem(
                value: 'clear_cache',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear Cache'),
                  ],
                ),
              ),
            ],
          ),
          Consumer<EmotionProvider>(
            builder: (context, provider, child) {
              return AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: provider.isConnected ? _pulseAnimation.value : 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: provider.isConnected
                            ? AppColors.success
                            : AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        provider.isConnected ? Icons.wifi : Icons.wifi_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // NEW: Tab bar for enhanced features
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(icon: Icon(Icons.analytics), text: 'Analyzer'),
          Tab(icon: Icon(Icons.monitor), text: 'Metrics'),
          Tab(icon: Icon(Icons.insights), text: 'Analytics'),
          Tab(icon: Icon(Icons.lightbulb), text: 'Examples'),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: _showEnhancedFeatures
              ? _buildTabContent()
              : _buildAnalyzerContent(),
        ),
      ),
    );
  }

  // NEW: Tab content based on selected tab
  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAnalyzerContent(),
        _buildMetricsContent(),
        _buildAnalyticsContent(),
        _buildExamplesContent(),
      ],
    );
  }

  Widget _buildAnalyzerContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ConnectionStatusCard(),
            const SizedBox(height: 24),
            EmotionInputField(controller: _textController),
            const SizedBox(height: 24),
            AnalyzeButton(onPressed: _onAnalyzePressed),
            const SizedBox(height: 32),
            Consumer<EmotionProvider>(
              builder: (context, provider, child) {
                if (provider.hasResult) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const ResultsCard(),
                  );
                } else {
                  return const InstructionsCard();
                }
              },
            ),
            // NEW: Show batch results if available
            Consumer<EmotionProvider>(
              builder: (context, provider, child) {
                if (provider.batchResults.isNotEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildBatchResultsCard(provider.batchResults),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // NEW: System metrics content
  Widget _buildMetricsContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Consumer<EmotionProvider>(
          builder: (context, provider, child) {
            return SystemMetricsCard(
              metrics: provider.systemMetrics,
              onRefresh: () => provider.loadSystemMetrics(),
              isAutoRefresh: provider.autoRefreshMetrics,
              onToggleAutoRefresh: () => provider.toggleAutoRefreshMetrics(),
            );
          },
        ),
      ),
    );
  }

  // NEW: Analytics content
  Widget _buildAnalyticsContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Consumer<EmotionProvider>(
          builder: (context, provider, child) {
            return AnalyticsCard(
              analytics: provider.analyticsSummary,
              onRefresh: () => provider.loadAnalytics(),
            );
          },
        ),
      ),
    );
  }

  // NEW: Demo examples content
  Widget _buildExamplesContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Consumer<EmotionProvider>(
          builder: (context, provider, child) {
            return DemoExamplesCard(
              demoResult: provider.demoResult,
              onRefresh: () => provider.loadDemoData(),
              onAnalyzeExample: _onDemoExampleSelected,
            );
          },
        ),
      ),
    );
  }

  // NEW: Batch results card
  Widget _buildBatchResultsCard(List<dynamic> results) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.withValues(alpha: 0.1),
              Colors.blue.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.batch_prediction,
                  color: Colors.green,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Batch Analysis Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      context.read<EmotionProvider>().clearBatchResults(),
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  tooltip: 'Clear results',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${results.length} texts analyzed successfully',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ...results.asMap().entries.map((entry) {
              final result = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '${entry.key + 1}.',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result.emotion,
                        style: TextStyle(
                          color: result.emotion == 'joy'
                              ? Colors.amber[700]
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${(result.confidence * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionMenu() {
    return FloatingActionButton(
      onPressed: _showQuickActionsDialog,
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      child: const Icon(Icons.more_vert),
    );
  }

  void _showQuickActionsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildQuickActionTile(
              'Batch Processing',
              'Analyze multiple texts at once',
              Icons.batch_prediction,
              AppColors.primary,
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BatchProcessingScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionTile(
              'Model Information',
              'Learn about AI capabilities',
              Icons.psychology,
              AppColors.success,
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModelInfoScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionTile(
              'Send Feedback',
              'Help us improve the app',
              Icons.feedback,
              AppColors.warning,
              () {
                Navigator.pop(context);
                _showFeedbackDialog();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: color.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const Text(
          'Feedback functionality coming soon! Thank you for your interest in improving the app.',
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

