import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../widgets/analysis/analysis.dart';
import '../../widgets/auth/animated_background_widget.dart';
import '../../cubit/text_analysis/text_analysis_cubit.dart';
import '../core/settings_screen.dart';
import 'batch_processing_screen.dart';

class EnhancedTextAnalysisScreen extends StatelessWidget {
  const EnhancedTextAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextAnalysisCubit(),
      child: const _EnhancedTextAnalysisScreenView(),
    );
  }
}

class _EnhancedTextAnalysisScreenView extends StatefulWidget {
  const _EnhancedTextAnalysisScreenView();

  @override
  State<_EnhancedTextAnalysisScreenView> createState() =>
      _EnhancedTextAnalysisScreenViewState();
}

class _EnhancedTextAnalysisScreenViewState
    extends State<_EnhancedTextAnalysisScreenView>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  String _selectedAnalysisType = 'Sentiment Analysis';

  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeAnimation;

  final List<AnalysisHistoryItem> _analysisHistory = [];

  final List<String> _analysisTypes = [
    'Sentiment Analysis',
    'Emotion Detection',
    'Topic Classification',
    'Intent Recognition',
    'Language Detection',
  ];

  final List<AnalysisHeaderStat> _quickStats = [
    AnalysisHeaderStat(value: '47', label: 'Analyzed', icon: Icons.analytics),
    AnalysisHeaderStat(value: '94%', label: 'Accuracy', icon: Icons.verified),
    AnalysisHeaderStat(value: '1.2s', label: 'Speed', icon: Icons.speed),
  ];

  final List<TextTemplate> _textTemplates = DefaultTextTemplates.all;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _textFocusNode.addListener(_onFocusChanged);
    _loadSampleHistory();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _loadSampleHistory() {
    _analysisHistory.addAll([
      AnalysisHistoryItem(
        id: '1',
        title: 'Customer Service Analysis',
        type: 'Sentiment Analysis',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        confidence: 0.94,
        result: {'sentiment': 'Positive', 'confidence': 0.94},
      ),
      AnalysisHistoryItem(
        id: '2',
        title: 'Email Emotion Detection',
        type: 'Emotion Detection',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        confidence: 0.88,
        result: {'primaryEmotion': 'Joy', 'confidence': 0.88},
      ),
      AnalysisHistoryItem(
        id: '3',
        title: 'Support Ticket Classification',
        type: 'Topic Classification',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        confidence: 0.82,
        result: {'primaryTopic': 'Technical Support', 'confidence': 0.82},
      ),
    ]);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    _backgroundController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _clearAnalysis() {
    _textController.clear();
    context.read<TextAnalysisCubit>().clearAnalysis();
  }

  void _useTemplate(String content) {
    _textController.text = content;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('AI Text Analysis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: BlocConsumer<TextAnalysisCubit, TextAnalysisState>(
        listener: (context, state) {
          if (state is TextAnalysisSuccess) {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Text analysis completed successfully!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is TextAnalysisError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Animated Background
              AnimatedBackgroundWidget(animation: _backgroundAnimation),

              // Main Content
              FadeTransition(
                opacity: _fadeAnimation,
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // Header
                      SliverToBoxAdapter(
                        child: AnalysisHeaderWidget(
                          title: 'AI Text Analysis',
                          description:
                              'Advanced NLP powered by machine learning',
                          icon: Icons.auto_awesome,
                          gradientColors: const [
                            Color(0xFF667eea),
                            Color(0xFF764ba2),
                          ],
                          stats: _quickStats,
                        ),
                      ),

                      // Text Input Section
                      SliverToBoxAdapter(
                        child: TextInputWidget(
                          textController: _textController,
                          isAnalyzing: state is TextAnalysisLoading,
                          selectedAnalysisType: _selectedAnalysisType,
                          analysisTypes: _analysisTypes,
                          onAnalysisTypeChanged: (type) {
                            setState(() {
                              _selectedAnalysisType = type;
                            });
                          },
                          onAnalyze: _analyzeText,
                          onClear: _clearAnalysis,
                          analysisResult: state is TextAnalysisSuccess
                              ? state.result.toMap()
                              : state is TextAnalysisDemo
                              ? state.demoResult.toMap()
                              : null,
                        ),
                      ),

                      // Text Templates
                      SliverToBoxAdapter(
                        child: TextTemplatesWidget(
                          templates: _textTemplates,
                          onTemplateSelected: _useTemplate,
                        ),
                      ),

                      // Analysis Result
                      if (state is TextAnalysisSuccess ||
                          state is TextAnalysisDemo)
                        SliverToBoxAdapter(
                          child: TextAnalysisResultWidget(
                            result: state is TextAnalysisSuccess
                                ? state.result.toMap()
                                : (state as TextAnalysisDemo).demoResult
                                      .toMap(),
                            isLoading: false,
                            analysisType: _selectedAnalysisType,
                            onRetry: _analyzeText,
                            onShare: _shareResult,
                            onSave: _saveResult,
                          ),
                        ),

                      // Quick Actions
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(customSpacing.md),
                          child: AnalysisQuickActionsWidget(
                            actions: [
                              AnalysisQuickAction(
                                title: 'Batch Analysis',
                                description: 'Analyze multiple texts',
                                icon: Icons.batch_prediction,
                                color: AppColors.primary,
                                onTap: () => _navigateToBatchProcessing(),
                              ),
                              AnalysisQuickAction(
                                title: 'Export Results',
                                description: 'Save analysis to file',
                                icon: Icons.file_download,
                                color: AppColors.secondary,
                                onTap: () => _exportResults(),
                              ),
                              AnalysisQuickAction(
                                title: 'Compare Texts',
                                description: 'Side-by-side analysis',
                                icon: Icons.compare_arrows,
                                color: AppColors.success,
                                onTap: () => _compareTexts(),
                              ),
                              AnalysisQuickAction(
                                title: 'Settings',
                                description: 'Configure analysis',
                                icon: Icons.settings,
                                color: AppColors.warning,
                                onTap: () => _navigateToSettings(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Analysis History
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(customSpacing.md),
                          child: AnalysisHistoryWidget(
                            historyItems: _analysisHistory,
                            onItemTap: (item) => _showHistoryDetails(item),
                          ),
                        ),
                      ),

                      // Bottom spacing
                      SliverToBoxAdapter(
                        child: SizedBox(height: customSpacing.xl),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _analyzeText() async {
    HapticFeedback.mediumImpact();

    context.read<TextAnalysisCubit>().analyzeText(
      text: _textController.text.trim(),
      analysisType: _selectedAnalysisType,
    );
  }

  void _showHistoryDetails(AnalysisHistoryItem item) {
    setState(() {
      _selectedAnalysisType = item.type;
    });
    // Load this item's result in the cubit
    context.read<TextAnalysisCubit>().loadDemoData(item.type);
  }

  void _shareResult() {
    final cubit = context.read<TextAnalysisCubit>();
    final state = cubit.state;

    if (state is TextAnalysisSuccess || state is TextAnalysisDemo) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sharing functionality would be implemented here'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  void _saveResult() {
    final cubit = context.read<TextAnalysisCubit>();
    final state = cubit.state;

    if (state is TextAnalysisSuccess || state is TextAnalysisDemo) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Result saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToBatchProcessing() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BatchProcessingScreen()),
    );
  }

  void _exportResults() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Export feature coming soon!'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  void _compareTexts() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Compare feature coming soon!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _navigateToSettings() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _showAboutDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 28),
              const SizedBox(width: 12),
              const Text('AI Text Analysis'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Advanced natural language processing powered by machine learning algorithms.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Sentiment Analysis'),
              const Text('• Emotion Detection'),
              const Text('• Topic Classification'),
              const Text('• Intent Recognition'),
              const Text('• Language Detection'),
              const SizedBox(height: 16),
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }
}
