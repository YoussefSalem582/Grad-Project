import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class EmployeeTextAnalysisScreen extends StatefulWidget {
  const EmployeeTextAnalysisScreen({super.key});

  @override
  State<EmployeeTextAnalysisScreen> createState() =>
      _EmployeeTextAnalysisScreenState();
}

class _EmployeeTextAnalysisScreenState extends State<EmployeeTextAnalysisScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  String _selectedAnalysisType = 'Sentiment Analysis';
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;
  late AnimationController _resultController;
  late Animation<double> _resultAnimation;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _analysisHistory = [];
  final List<String> _quickTemplates = [
    "Thank you for contacting us. We appreciate your feedback.",
    "I apologize for the inconvenience. Let me resolve this issue.",
    "Your order has been processed successfully. Thank you for your business.",
    "We value your opinion and will consider your suggestions.",
    "Is there anything else I can help you with today?",
  ];

  @override
  void initState() {
    super.initState();
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _resultAnimation = CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    );
    _pulseController.repeat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _resultController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(customSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnhancedHeader(theme, customSpacing),
            SizedBox(height: customSpacing.lg),
            _buildAnalysisTypeSelector(theme, customSpacing),
            SizedBox(height: customSpacing.lg),
            _buildTextInput(theme, customSpacing),
            SizedBox(height: customSpacing.lg),
            if (_analysisResult != null) ...[
              _buildAnalysisResult(theme, customSpacing),
              SizedBox(height: customSpacing.lg),
            ],
            _buildQuickTemplates(theme, customSpacing),
            SizedBox(height: customSpacing.lg),
            _buildAnalysisHistory(theme, customSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(ThemeData theme, CustomSpacing customSpacing) {
    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.secondaryGradient,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
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
                    Icons.auto_awesome,
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
                        'AI Text Analysis',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: customSpacing.xs),
                      Text(
                        'Advanced NLP powered by machine learning',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: customSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildHeaderStat(
                    'Analyzed Today',
                    '47',
                    Icons.analytics,
                    customSpacing,
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: _buildHeaderStat(
                    'Accuracy',
                    '94.2%',
                    Icons.verified,
                    customSpacing,
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: _buildHeaderStat(
                    'Avg Speed',
                    '1.2s',
                    Icons.speed,
                    customSpacing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(
    String label,
    String value,
    IconData icon,
    CustomSpacing customSpacing,
  ) {
    return Container(
      padding: EdgeInsets.all(customSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(height: customSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTypeSelector(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    final analysisTypes = [
      {
        'name': 'Sentiment Analysis',
        'icon': Icons.sentiment_satisfied_alt,
        'color': AppColors.success,
      },
      {
        'name': 'Emotion Detection',
        'icon': Icons.psychology,
        'color': AppColors.primary,
      },
      {
        'name': 'Intent Classification',
        'icon': Icons.lightbulb,
        'color': AppColors.warning,
      },
      {
        'name': 'Keyword Extraction',
        'icon': Icons.key,
        'color': AppColors.secondary,
      },
      {
        'name': 'Language Detection',
        'icon': Icons.translate,
        'color': AppColors.info,
      },
      {
        'name': 'Toxicity Detection',
        'icon': Icons.security,
        'color': AppColors.error,
      },
    ];

    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Analysis Type',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.sm),
          Text(
            'Choose the type of analysis you want to perform',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: customSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: analysisTypes.length,
            itemBuilder: (context, index) {
              final type = analysisTypes[index];
              final isSelected = _selectedAnalysisType == type['name'];
              return GestureDetector(
                onTap: () => setState(
                  () => _selectedAnalysisType = type['name'] as String,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              type['color'] as Color,
                              (type['color'] as Color).withValues(alpha: 0.8),
                            ],
                          )
                        : null,
                    color: !isSelected
                        ? (type['color'] as Color).withValues(alpha: 0.1)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (type['color'] as Color).withValues(
                        alpha: isSelected ? 1.0 : 0.3,
                      ),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (type['color'] as Color).withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  padding: EdgeInsets.all(customSpacing.sm),
                  child: Row(
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        color: isSelected
                            ? Colors.white
                            : type['color'] as Color,
                        size: 20,
                      ),
                      SizedBox(width: customSpacing.sm),
                      Expanded(
                        child: Text(
                          type['name'] as String,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : type['color'] as Color,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(ThemeData theme, CustomSpacing customSpacing) {
    return Column(
      children: [
        // Enhanced Input Card
        GlassCard(
          padding: EdgeInsets.all(customSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(customSpacing.sm),
                    decoration: BoxDecoration(
                      gradient: AppColors.secondaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: customSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Text Analysis',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'AI-powered natural language processing',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Character count and real-time analysis toggle
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: customSpacing.sm,
                          vertical: customSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_textController.text.length}/2000',
                          style: TextStyle(
                            fontSize: 12,
                            color: _textController.text.length > 2000
                                ? AppColors.error
                                : AppColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: customSpacing.xs),
                      GestureDetector(
                        onTap: () =>
                            setState(() {}), // Toggle real-time analysis
                        child: Container(
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
                                'LIVE',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: customSpacing.lg),

              // Enhanced text input with tabs
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
                    // Input tabs
                    Container(
                      padding: EdgeInsets.all(customSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildInputTab(
                            'Text Input',
                            Icons.text_fields,
                            true,
                            customSpacing,
                          ),
                          SizedBox(width: customSpacing.xs),
                          _buildInputTab(
                            'File Upload',
                            Icons.upload_file,
                            false,
                            customSpacing,
                          ),
                          SizedBox(width: customSpacing.xs),
                          _buildInputTab(
                            'URL Import',
                            Icons.link,
                            false,
                            customSpacing,
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: AppColors.textSecondary,
                            ),
                            onSelected: (value) => _handleInputAction(value),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'clear',
                                child: Row(
                                  children: [
                                    Icon(Icons.clear),
                                    SizedBox(width: 8),
                                    Text('Clear Text'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'paste',
                                child: Row(
                                  children: [
                                    Icon(Icons.paste),
                                    SizedBox(width: 8),
                                    Text('Paste from Clipboard'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'sample',
                                child: Row(
                                  children: [
                                    Icon(Icons.lightbulb),
                                    SizedBox(width: 8),
                                    Text('Load Sample Text'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Text input area
                    Container(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText:
                              'Enter your text here for comprehensive AI analysis...\n\nExample:\n"I love this product! The customer service was amazing and the delivery was super fast. Highly recommend!"',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 14,
                          ),
                        ),
                        maxLines: 8,
                        minLines: 6,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                        onChanged: (text) {
                          setState(() {}); // Update character count
                          // Real-time analysis could be triggered here
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: customSpacing.lg),

              // Analysis options row
              Row(
                children: [
                  // Batch analysis toggle
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(customSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.layers,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                          SizedBox(width: customSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Batch Analysis',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Analyze multiple texts',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: false,
                            onChanged: (value) => _toggleBatchMode(),
                            activeColor: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: customSpacing.md),

                  // Language detection
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(customSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.translate,
                            color: AppColors.info,
                            size: 20,
                          ),
                          SizedBox(width: customSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Auto-Detect',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Language: English',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: customSpacing.lg),

              // Enhanced analyze button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: _isAnalyzing
                      ? LinearGradient(
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.5),
                            AppColors.primary.withValues(alpha: 0.5),
                          ],
                        )
                      : AppColors.secondaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _isAnalyzing ? null : _performAnalysis,
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
                                  'Analyzing with AI...',
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Start AI Analysis',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      _selectedAnalysisType,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Real-time insights preview (if text is being typed)
        if (_textController.text.isNotEmpty) ...[
          SizedBox(height: customSpacing.lg),
          _buildRealTimeInsights(theme, customSpacing),
        ],
      ],
    );
  }

  Widget _buildInputTab(
    String title,
    IconData icon,
    bool isActive,
    CustomSpacing customSpacing,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: customSpacing.sm,
        vertical: customSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          SizedBox(width: customSpacing.xs),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealTimeInsights(ThemeData theme, CustomSpacing customSpacing) {
    final wordCount = _textController.text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .length;
    final sentenceCount = _textController.text
        .split(RegExp(r'[.!?]'))
        .where((s) => s.trim().isNotEmpty)
        .length;
    final avgWordsPerSentence = sentenceCount > 0
        ? (wordCount / sentenceCount).toStringAsFixed(1)
        : '0';

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
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.insights, color: AppColors.info, size: 20),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Real-Time Insights',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Live analysis as you type',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseController.value * 0.1),
                    child: Container(
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
                            'ANALYZING',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: customSpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildInsightMetric(
                  'Words',
                  wordCount.toString(),
                  Icons.text_fields,
                  AppColors.primary,
                  customSpacing,
                ),
              ),
              Expanded(
                child: _buildInsightMetric(
                  'Sentences',
                  sentenceCount.toString(),
                  Icons.format_list_numbered,
                  AppColors.secondary,
                  customSpacing,
                ),
              ),
              Expanded(
                child: _buildInsightMetric(
                  'Avg/Sentence',
                  avgWordsPerSentence,
                  Icons.analytics,
                  AppColors.warning,
                  customSpacing,
                ),
              ),
              Expanded(
                child: _buildInsightMetric(
                  'Readability',
                  wordCount > 10 ? 'Good' : 'Short',
                  Icons.visibility,
                  wordCount > 10 ? AppColors.success : AppColors.info,
                  customSpacing,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightMetric(
    String label,
    String value,
    IconData icon,
    Color color,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: customSpacing.xs),
      padding: EdgeInsets.all(customSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(height: customSpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _handleInputAction(String action) {
    switch (action) {
      case 'clear':
        _textController.clear();
        setState(() {});
        break;
      case 'paste':
        _pasteFromClipboard();
        break;
      case 'sample':
        _loadSampleText();
        break;
    }
  }

  void _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      _textController.text = data!.text!;
      setState(() {});
    }
  }

  void _loadSampleText() {
    const sampleTexts = [
      "I'm extremely disappointed with this product. The quality is terrible and it broke after just one day of use. Customer service was unhelpful and rude. Would not recommend to anyone!",
      "This is absolutely amazing! Best purchase I've made this year. The quality exceeded my expectations and the customer service team was incredibly helpful. Five stars!",
      "The product is okay, nothing special. It does what it's supposed to do but doesn't stand out. Delivery was on time and packaging was good. Average experience overall.",
      "I love the design and functionality, but there are some minor issues with the battery life. Overall satisfied with the purchase. Customer support responded quickly to my questions.",
    ];

    final random = DateTime.now().millisecond % sampleTexts.length;
    _textController.text = sampleTexts[random];
    setState(() {});
  }

  void _toggleBatchMode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Batch analysis mode coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _performAnalysis() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text to analyze'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    // Add to history
    _analysisHistory.insert(0, {
      'text': _textController.text.length > 100
          ? '${_textController.text.substring(0, 100)}...'
          : _textController.text,
      'type': _selectedAnalysisType,
      'timestamp': DateTime.now(),
      'result': 'Analysis completed',
    });

    // Simulate analysis
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _analysisResult = {
            'sentiment': 'Positive',
            'confidence': 0.87,
            'emotions': {'joy': 0.6, 'trust': 0.3, 'surprise': 0.1},
            'keywords': ['great', 'excellent', 'satisfied'],
            'language': 'English',
            'toxicity': 0.02,
          };
        });
        _resultController.forward();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analysis completed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  Widget _buildAnalysisResult(ThemeData theme, CustomSpacing customSpacing) {
    return ScaleTransition(
      scale: _resultAnimation,
      child: GlassCard(
        padding: EdgeInsets.all(customSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(customSpacing.sm),
                  decoration: BoxDecoration(
                    gradient: AppColors.successGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Text(
                  'Analysis Results',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Confidence: ${_analysisResult?['confidence'] ?? '94'}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: customSpacing.md),
            _buildResultVisualization(theme, customSpacing),
            SizedBox(height: customSpacing.md),
            _buildResultDetails(theme, customSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildResultVisualization(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    final sentiment = _analysisResult?['sentiment'] ?? 'Positive';
    final score = (_analysisResult?['score'] ?? 0.8) as double;

    Color sentimentColor;
    IconData sentimentIcon;

    switch (sentiment.toLowerCase()) {
      case 'positive':
        sentimentColor = AppColors.success;
        sentimentIcon = Icons.sentiment_very_satisfied;
        break;
      case 'negative':
        sentimentColor = AppColors.error;
        sentimentIcon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        sentimentColor = AppColors.warning;
        sentimentIcon = Icons.sentiment_neutral;
    }

    return Container(
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            sentimentColor.withValues(alpha: 0.1),
            sentimentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.md),
                decoration: BoxDecoration(
                  color: sentimentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(sentimentIcon, color: Colors.white, size: 32),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sentiment,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: sentimentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Overall sentiment detected',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${(score * 100).toInt()}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: sentimentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Confidence',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: customSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(sentimentColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDetails(ThemeData theme, CustomSpacing customSpacing) {
    final emotions =
        _analysisResult?['emotions'] ??
        {'Joy': 0.7, 'Trust': 0.6, 'Surprise': 0.3, 'Sadness': 0.1};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analysis',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: customSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
          ),
          itemCount: emotions.length,
          itemBuilder: (context, index) {
            final emotion = emotions.keys.elementAt(index);
            final value = emotions[emotion] as double;
            final color = _getEmotionColor(emotion);

            return Container(
              padding: EdgeInsets.all(customSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emotion,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${(value * 100).toInt()}%',
                          style: TextStyle(color: color, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: color.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation(color),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickTemplates(ThemeData theme, CustomSpacing customSpacing) {
    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Quick Templates',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                'Tap to use',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.md),
          Wrap(
            spacing: customSpacing.sm,
            runSpacing: customSpacing.sm,
            children: _quickTemplates.map((template) {
              return GestureDetector(
                onTap: () => _useTemplate(template),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: customSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    template.length > 50
                        ? '${template.substring(0, 47)}...'
                        : template,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisHistory(ThemeData theme, CustomSpacing customSpacing) {
    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Analyses',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              ModernButton(
                onPressed: _exportHistory,
                style: ModernButtonStyle.ghost,
                icon: Icons.download,
                text: 'Export',
                size: ModernButtonSize.small,
              ),
            ],
          ),
          SizedBox(height: customSpacing.md),
          if (_analysisHistory.isEmpty)
            Container(
              padding: EdgeInsets.all(customSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: customSpacing.sm),
                  Text(
                    'No analyses yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Your analysis history will appear here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(
              _analysisHistory.length.clamp(0, 5),
              (index) => _buildHistoryItem(
                _analysisHistory[index],
                theme,
                customSpacing,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    Map<String, dynamic> item,
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.sm),
            decoration: BoxDecoration(
              color: _getSentimentColor(
                item['sentiment'],
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSentimentIcon(item['sentiment']),
              color: _getSentimentColor(item['sentiment']),
              size: 16,
            ),
          ),
          SizedBox(width: customSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['text'].length > 60
                      ? '${item['text'].substring(0, 60)}...'
                      : item['text'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${item['sentiment']} • ${item['confidence']}% • ${item['time']}',
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

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joy':
        return AppColors.success;
      case 'trust':
        return AppColors.primary;
      case 'surprise':
        return AppColors.warning;
      case 'sadness':
        return AppColors.info;
      case 'fear':
        return AppColors.error;
      case 'anger':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return AppColors.success;
      case 'negative':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  IconData _getSentimentIcon(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Icons.sentiment_very_satisfied;
      case 'negative':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  void _useTemplate(String template) {
    setState(() {
      _textController.text = template;
    });
  }

  void _exportHistory() {
    // TODO: Implement export functionality
  }
}
