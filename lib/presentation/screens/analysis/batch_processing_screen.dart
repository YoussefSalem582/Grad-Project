import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/analysis/analysis.dart';
import '../../widgets/auth/animated_background_widget.dart';

class BatchProcessingScreen extends StatefulWidget {
  const BatchProcessingScreen({super.key});

  @override
  State<BatchProcessingScreen> createState() => _BatchProcessingScreenState();
}

class _BatchProcessingScreenState extends State<BatchProcessingScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = [];
  final ScrollController _scrollController = ScrollController();
  int _textCount = 3;
  static const int _maxTexts = 10;
  static const int _minTexts = 2;

  bool _isProcessing = false;
  List<Map<String, dynamic>> _batchResults = [];
  String _selectedProcessingMode = 'Parallel Processing';

  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeAnimation;

  final List<AnalysisHistoryItem> _processingHistory = [];

  final List<String> _processingModes = [
    'Parallel Processing',
    'Sequential Processing',
    'Priority Processing',
    'Optimized Processing',
  ];

  final List<AnalysisHeaderStat> _quickStats = [
    AnalysisHeaderStat(
      value: '47',
      label: 'Batches',
      icon: Icons.batch_prediction,
    ),
    AnalysisHeaderStat(value: '3.2s', label: 'Avg Time', icon: Icons.speed),
    AnalysisHeaderStat(
      value: '98%',
      label: 'Success Rate',
      icon: Icons.check_circle,
    ),
  ];

  final List<String> _sampleTexts = [
    "Thank you for your excellent customer service!",
    "I'm disappointed with the delayed delivery.",
    "The product quality exceeded my expectations.",
    "Please resolve this issue as soon as possible.",
    "Your team was very helpful and professional.",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeControllers();
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

  void _initializeControllers() {
    _controllers.clear();
    for (int i = 0; i < _textCount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _loadSampleHistory() {
    _processingHistory.addAll([
      AnalysisHistoryItem(
        id: '1',
        title: 'Customer Feedback Batch',
        type: 'Parallel Processing',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        confidence: 0.85,
        result: {'items_processed': 8},
      ),
      AnalysisHistoryItem(
        id: '2',
        title: 'Support Tickets Analysis',
        type: 'Sequential Processing',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        confidence: 0.91,
        result: {'items_processed': 12},
      ),
    ]);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _addTextField() {
    if (_textCount < _maxTexts) {
      setState(() {
        _textCount++;
        _controllers.add(TextEditingController());
      });

      // Scroll to show the new field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _removeTextField() {
    if (_textCount > _minTexts) {
      setState(() {
        _controllers.removeLast().dispose();
        _textCount--;
      });
    }
  }

  void _loadSampleData() {
    for (int i = 0; i < _controllers.length && i < _sampleTexts.length; i++) {
      _controllers[i].text = _sampleTexts[i];
    }
    setState(() {});
  }

  void _clearAllFields() {
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _batchResults.clear();
    });
  }

  Future<void> _processBatch() async {
    final texts = _controllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (texts.isEmpty) {
      _showSnackBar('Please enter at least one text to process', isError: true);
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _isProcessing = true;
      _batchResults.clear();
    });

    // Simulate batch processing
    final results = <Map<String, dynamic>>[];

    for (int i = 0; i < texts.length; i++) {
      final text = texts[i];

      // Simulate processing delay based on mode
      await Future.delayed(
        _selectedProcessingMode == 'Parallel Processing'
            ? Duration(milliseconds: 200)
            : Duration(milliseconds: 500),
      );

      final result = {
        'index': i + 1,
        'text': text,
        'sentiment': _analyzeSentiment(text),
        'emotion': _analyzeEmotion(text),
        'confidence': 0.80 + (0.15 * (text.length / 100).clamp(0, 1)),
        'keywords': _extractKeywords(text),
        'urgency': _analyzeUrgency(text),
        'category': _categorizeText(text),
      };

      results.add(result);

      // Update UI progressively for sequential processing
      if (_selectedProcessingMode == 'Sequential Processing') {
        setState(() {
          _batchResults = List.from(results);
        });
      }
    }

    setState(() {
      _batchResults = results;
      _isProcessing = false;
    });

    // Add to history
    final historyItem = AnalysisHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Batch Processing',
      type: _selectedProcessingMode,
      timestamp: DateTime.now(),
      confidence:
          results.fold(0.0, (sum, r) => sum + (r['confidence'] as double)) /
          results.length,
      result: {'items_processed': texts.length, 'results': results},
    );

    setState(() {
      _processingHistory.insert(0, historyItem);
    });

    HapticFeedback.lightImpact();
    _showSnackBar('Batch processing completed successfully!');
  }

  String _analyzeSentiment(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains(
      RegExp(r'thank|excellent|great|amazing|wonderful|fantastic'),
    )) {
      return 'Positive';
    } else if (lowerText.contains(
      RegExp(r'disappointed|terrible|awful|hate|worst|bad'),
    )) {
      return 'Negative';
    } else {
      return 'Neutral';
    }
  }

  String _analyzeEmotion(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains(RegExp(r'happy|joy|excited|thrilled'))) {
      return 'Joy';
    } else if (lowerText.contains(RegExp(r'sad|disappointed|upset'))) {
      return 'Sadness';
    } else if (lowerText.contains(
      RegExp(r'angry|furious|frustrated|annoyed'),
    )) {
      return 'Anger';
    } else if (lowerText.contains(
      RegExp(r'scared|worried|anxious|concerned'),
    )) {
      return 'Fear';
    } else {
      return 'Neutral';
    }
  }

  List<String> _extractKeywords(String text) {
    final words = text.toLowerCase().split(RegExp(r'\W+'));
    final keywords = words
        .where((word) => word.length > 4)
        .where(
          (word) => ![
            'that',
            'this',
            'with',
            'have',
            'they',
            'were',
            'been',
            'their',
          ].contains(word),
        )
        .take(3)
        .toList();
    return keywords;
  }

  String _analyzeUrgency(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains(
      RegExp(r'urgent|asap|immediately|emergency|critical'),
    )) {
      return 'High';
    } else if (lowerText.contains(RegExp(r'soon|quickly|please|important'))) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  String _categorizeText(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains(RegExp(r'service|support|help|assistance'))) {
      return 'Support';
    } else if (lowerText.contains(RegExp(r'product|quality|delivery|order'))) {
      return 'Product';
    } else if (lowerText.contains(RegExp(r'billing|payment|charge|refund'))) {
      return 'Billing';
    } else {
      return 'General';
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Main Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: AnalysisHeaderWidget(
                      title: 'Batch Processing',
                      description: 'Process multiple texts simultaneously',
                      icon: Icons.batch_prediction,
                      gradientColors: const [
                        Color(0xFF4facfe),
                        Color(0xFF00f2fe),
                      ],
                      stats: _quickStats,
                    ),
                  ),

                  // Processing Mode Selection
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: _buildProcessingModeSection(theme, customSpacing),
                    ),
                  ),

                  // Text Input Fields
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: _buildTextInputSection(theme, customSpacing),
                    ),
                  ),

                  // Processing Controls
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: _buildProcessingControls(theme, customSpacing),
                    ),
                  ),

                  // Processing Progress
                  if (_isProcessing)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(customSpacing.md),
                        child: _buildProcessingProgress(theme, customSpacing),
                      ),
                    ),

                  // Batch Results
                  if (_batchResults.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(customSpacing.md),
                        child: _buildBatchResults(theme, customSpacing),
                      ),
                    ),

                  // Quick Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: AnalysisQuickActionsWidget(
                        actions: [
                          AnalysisQuickAction(
                            title: 'Import CSV',
                            description: 'Import from CSV file',
                            icon: Icons.upload_file,
                            color: AppColors.primary,
                            onTap: () => _importFromCSV(),
                          ),
                          AnalysisQuickAction(
                            title: 'Export Results',
                            description: 'Export analysis results',
                            icon: Icons.download,
                            color: AppColors.secondary,
                            onTap: () => _exportResults(),
                          ),
                          AnalysisQuickAction(
                            title: 'Schedule Batch',
                            description: 'Schedule batch processing',
                            icon: Icons.schedule,
                            color: AppColors.success,
                            onTap: () => _scheduleBatch(),
                          ),
                          AnalysisQuickAction(
                            title: 'Settings',
                            description: 'Processing settings',
                            icon: Icons.settings,
                            color: AppColors.warning,
                            onTap: () => _showSettings(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Processing History
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: AnalysisHistoryWidget(
                        historyItems: _processingHistory,
                        onItemTap: (item) => _showHistoryDetails(item),
                      ),
                    ),
                  ),

                  // Bottom spacing
                  SliverToBoxAdapter(child: SizedBox(height: customSpacing.xl)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingModeSection(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppColors.primary, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Processing Mode',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Container(
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedProcessingMode,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                onChanged: (value) {
                  setState(() {
                    _selectedProcessingMode = value!;
                  });
                },
                items: _processingModes.map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Text(
                      mode,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputSection(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields, color: AppColors.primary, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Text Inputs ($_textCount/$_maxTexts)',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _textCount < _maxTexts ? _addTextField : null,
                icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
              ),
              IconButton(
                onPressed: _textCount > _minTexts ? _removeTextField : null,
                icon: Icon(Icons.remove_circle_outline, color: AppColors.error),
              ),
            ],
          ),
          SizedBox(height: spacing.md),

          // Text input fields
          ...List.generate(_textCount, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: spacing.md),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    hintText: 'Enter text ${index + 1} to analyze...',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(spacing.md),
                    prefixIcon: Icon(
                      Icons.text_snippet,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  style: TextStyle(color: AppColors.textPrimary),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProcessingControls(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildControlButton(
                  label: 'Load Sample',
                  icon: Icons.file_copy,
                  color: AppColors.secondary,
                  onTap: _loadSampleData,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: _buildControlButton(
                  label: 'Clear All',
                  icon: Icons.clear_all,
                  color: AppColors.error,
                  onTap: _clearAllFields,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          _buildControlButton(
            label: _isProcessing ? 'Processing...' : 'Process Batch',
            icon: _isProcessing ? Icons.hourglass_empty : Icons.play_arrow,
            color: AppColors.primary,
            onTap: !_isProcessing ? _processBatch : null,
            isLoading: _isProcessing,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 48,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: onTap != null ? color : color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingProgress(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.hourglass_empty, color: AppColors.primary, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Processing Batch...',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          LinearProgressIndicator(
            backgroundColor: AppColors.background,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: spacing.md),
          Text(
            'Processing ${_batchResults.length + 1} of ${_controllers.where((c) => c.text.trim().isNotEmpty).length}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchResults(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppColors.success, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Batch Results (${_batchResults.length} items)',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),

          // Results summary
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResultStat(
                  'Avg Confidence',
                  '${(_batchResults.fold(0.0, (sum, r) => sum + r['confidence']) / _batchResults.length * 100).toInt()}%',
                ),
                _buildResultStat(
                  'Positive',
                  '${_batchResults.where((r) => r['sentiment'] == 'Positive').length}',
                ),
                _buildResultStat(
                  'High Urgency',
                  '${_batchResults.where((r) => r['urgency'] == 'High').length}',
                ),
              ],
            ),
          ),

          SizedBox(height: spacing.lg),

          // Individual results
          ...List.generate(_batchResults.length, (index) {
            final result = _batchResults[index];
            return Padding(
              padding: EdgeInsets.only(bottom: spacing.md),
              child: _buildResultCard(result, theme, spacing),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildResultCard(
    Map<String, dynamic> result,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#${result['index']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${(result['confidence'] * 100).toInt()}%',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Text(
            result['text'],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.sm,
            children: [
              _buildResultChip(
                result['sentiment'],
                _getSentimentColor(result['sentiment']),
              ),
              _buildResultChip(result['emotion'], AppColors.secondary),
              _buildResultChip(
                result['urgency'],
                _getUrgencyColor(result['urgency']),
              ),
              _buildResultChip(result['category'], AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'Positive':
        return AppColors.success;
      case 'Negative':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'High':
        return AppColors.error;
      case 'Medium':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  void _importFromCSV() {
    // Implement CSV import functionality
  }

  void _exportResults() {
    // Implement results export functionality
  }

  void _scheduleBatch() {
    // Implement batch scheduling functionality
  }

  void _showSettings() {
    // Show settings dialog
  }

  void _showHistoryDetails(AnalysisHistoryItem item) {
    // Show detailed history item
  }
}
