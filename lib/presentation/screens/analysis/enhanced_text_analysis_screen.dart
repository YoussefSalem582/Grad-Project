import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import 'base_analysis_screen.dart';

class EnhancedTextAnalysisScreen extends BaseAnalysisScreen {
  const EnhancedTextAnalysisScreen({super.key});

  @override
  State<EnhancedTextAnalysisScreen> createState() =>
      _EnhancedTextAnalysisScreenState();
}

class _EnhancedTextAnalysisScreenState
    extends BaseAnalysisScreenState<EnhancedTextAnalysisScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedAnalysisType = 'Sentiment Analysis';
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;
  late AnimationController _resultController;
  late Animation<double> _resultAnimation;

  final List<Map<String, dynamic>> _analysisHistory = [];
  final List<String> _quickTemplates = [
    "Thank you for contacting us. We appreciate your feedback.",
    "I apologize for the inconvenience. Let me resolve this issue.",
    "Your order has been processed successfully. Thank you for your business.",
    "We value your opinion and will consider your suggestions.",
    "Is there anything else I can help you with today?",
  ];

  final List<String> _analysisTypes = [
    'Sentiment Analysis',
    'Emotion Detection',
    'Topic Classification',
    'Intent Recognition',
    'Language Detection',
  ];

  @override
  String get analysisType => 'AI Text Analysis';

  @override
  IconData get analysisIcon => Icons.auto_awesome;

  @override
  String get analysisDescription => 'Advanced NLP powered by machine learning';

  @override
  List<Color> get gradientColors => [
    const Color(0xFF667EEA),
    const Color(0xFF764BA2),
  ];

  @override
  List<Map<String, dynamic>> get headerStats => [
    {'label': 'Analyzed Today', 'value': '47', 'icon': Icons.analytics},
    {'label': 'Accuracy', 'value': '94%', 'icon': Icons.verified},
    {'label': 'Avg Speed', 'value': '1.2s', 'icon': Icons.speed},
  ];

  @override
  void initState() {
    super.initState();
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _resultAnimation = CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget buildAnalysisContent(
    BuildContext context,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Analysis Type Selector
        _buildAnalysisTypeSelector(theme, spacing),
        SizedBox(height: spacing.lg),

        // Text Input Section
        _buildTextInputSection(theme, spacing),
        SizedBox(height: spacing.lg),

        // Analysis Result
        if (_analysisResult != null) ...[
          _buildAnalysisResult(theme, spacing),
          SizedBox(height: spacing.lg),
        ],

        // Quick Templates
        _buildQuickTemplates(theme, spacing),
      ],
    );
  }

  @override
  Widget? buildAdditionalFeatures(
    BuildContext context,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return _buildAnalysisHistory(theme, spacing);
  }

  Widget _buildAnalysisTypeSelector(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Type',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.md),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.sm,
            children: _analysisTypes.map((type) {
              final isSelected = type == _selectedAnalysisType;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAnalysisType = type;
                  });
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: gradientColors)
                        : null,
                    color: isSelected ? null : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    type,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
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

  Widget _buildTextInputSection(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Enter Text for Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_textController.text.length}/1000',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),

          // Text Input Field
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: TextField(
              controller: _textController,
              maxLines: 6,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'Type or paste your text here for analysis...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(spacing.md),
                counterText: '',
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: spacing.lg),

          // Analyze Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _textController.text.trim().isEmpty || _isAnalyzing
                  ? null
                  : _performAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: gradientColors.first,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isAnalyzing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: spacing.sm),
                        const Text('Analyzing...'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome, size: 20),
                        SizedBox(width: spacing.sm),
                        const Text(
                          'Analyze Text',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResult(ThemeData theme, CustomSpacing spacing) {
    return FadeTransition(
      opacity: _resultAnimation,
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(spacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    'Analysis Complete',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.lg),

            // Mock result content
            _buildResultMetric(
              'Sentiment',
              'Positive',
              '87%',
              AppColors.success,
            ),
            SizedBox(height: spacing.md),
            _buildResultMetric('Confidence', 'High', '94%', AppColors.info),
            SizedBox(height: spacing.md),
            _buildResultMetric(
              'Emotion',
              'Satisfied',
              '76%',
              AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultMetric(
    String label,
    String value,
    String confidence,
    Color color,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            confidence,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTemplates(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Templates',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.md),
          ...(_quickTemplates.map(
            (template) => _buildTemplateItem(template, theme, spacing),
          )),
        ],
      ),
    );
  }

  Widget _buildTemplateItem(
    String template,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: InkWell(
        onTap: () {
          _textController.text = template;
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  template,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisHistory(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: gradientColors.first,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),

          // Empty state
          if (_analysisHistory.isEmpty)
            Container(
              padding: EdgeInsets.all(spacing.xl),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    'No analysis history yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    'Start analyzing text to see your history here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _performAnalysis() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAnalyzing = false;
      _analysisResult = {
        'sentiment': 'Positive',
        'confidence': 0.87,
        'emotions': ['satisfied', 'confident'],
      };
    });

    _resultController.forward();
    HapticFeedback.mediumImpact();
  }
}
