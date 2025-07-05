import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/analysis/analysis.dart';
import '../../widgets/auth/animated_background_widget.dart';

class EmotionAnalyzerScreen extends StatefulWidget {
  const EmotionAnalyzerScreen({super.key});

  @override
  State<EmotionAnalyzerScreen> createState() => _EmotionAnalyzerScreenState();
}

class _EmotionAnalyzerScreenState extends State<EmotionAnalyzerScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  String _selectedEmotionModel = 'Advanced Neural Network';
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeAnimation;

  final List<AnalysisHistoryItem> _analysisHistory = [];

  final List<String> _emotionModels = [
    'Advanced Neural Network',
    'Basic Emotion Detection',
    'Contextual Analysis',
    'Multi-Modal Detection',
    'Real-time Processing',
  ];

  final List<AnalysisHeaderStat> _quickStats = [
    AnalysisHeaderStat(value: '156', label: 'Analyses', icon: Icons.psychology),
    AnalysisHeaderStat(value: '94%', label: 'Accuracy', icon: Icons.grade),
    AnalysisHeaderStat(value: '0.8s', label: 'Speed', icon: Icons.speed),
  ];

  final List<String> _quickTemplates = [
    "I'm feeling overwhelmed with work lately.",
    "Thank you so much for your excellent service!",
    "I'm disappointed with the product quality.",
    "This meeting was incredibly productive and energizing.",
    "I'm concerned about the recent changes in policy.",
    "Your team exceeded all my expectations today.",
    "I feel anxious about the upcoming presentation.",
    "The customer support was absolutely fantastic!",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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

  void _loadSampleHistory() {
    _analysisHistory.addAll([
      AnalysisHistoryItem(
        id: '1',
        title: 'Customer Feedback Analysis',
        type: 'Advanced Neural Network',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        confidence: 0.89,
        result: {'emotion': 'Joy', 'confidence': 0.89},
      ),
      AnalysisHistoryItem(
        id: '2',
        title: 'Support Ticket Emotion',
        type: 'Contextual Analysis',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        confidence: 0.76,
        result: {'emotion': 'Frustration', 'confidence': 0.76},
      ),
      AnalysisHistoryItem(
        id: '3',
        title: 'Product Review Sentiment',
        type: 'Multi-Modal Detection',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        confidence: 0.92,
        result: {'emotion': 'Satisfaction', 'confidence': 0.92},
      ),
    ]);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _analyzeEmotion() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.mediumImpact();
    setState(() => _isAnalyzing = true);

    // Simulate emotion analysis
    await Future.delayed(const Duration(milliseconds: 1500));

    final result = {
      'text': text,
      'primary_emotion': _generatePrimaryEmotion(text),
      'confidence': 0.87 + (0.13 * (text.length / 100).clamp(0, 1)),
      'emotions': _generateEmotionBreakdown(text),
      'sentiment_score': _generateSentimentScore(text),
      'emotional_intensity': _generateIntensity(text),
      'emotional_categories': {
        'Positive': _calculatePositive(text),
        'Negative': _calculateNegative(text),
        'Neutral': _calculateNeutral(text),
      },
      'insights': _generateInsights(text),
      'recommendations': _generateRecommendations(text),
      'detailed_analysis': {
        'word_count': text.split(' ').length,
        'character_count': text.length,
        'emotional_keywords': _extractEmotionalKeywords(text),
        'tone': _analyzeTone(text),
      },
    };

    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
    });

    // Add to history
    final historyItem = AnalysisHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Text: ${text.length > 30 ? text.substring(0, 30) + '...' : text}',
      type: _selectedEmotionModel,
      timestamp: DateTime.now(),
      confidence: (result['confidence'] as double?) ?? 0.0,
      result: result,
    );

    setState(() {
      _analysisHistory.insert(0, historyItem);
    });

    HapticFeedback.lightImpact();
  }

  String _generatePrimaryEmotion(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains(
      RegExp(r'happy|joy|excited|amazing|fantastic|excellent|love|wonderful'),
    )) {
      return 'Joy';
    } else if (lowerText.contains(
      RegExp(r'sad|disappointed|upset|terrible|awful|hate|horrible'),
    )) {
      return 'Sadness';
    } else if (lowerText.contains(
      RegExp(r'angry|furious|mad|annoyed|frustrated|irritated'),
    )) {
      return 'Anger';
    } else if (lowerText.contains(
      RegExp(r'scared|afraid|worried|anxious|nervous|concerned'),
    )) {
      return 'Fear';
    } else if (lowerText.contains(
      RegExp(r'surprised|shocked|amazed|astonished'),
    )) {
      return 'Surprise';
    } else if (lowerText.contains(RegExp(r'disgusted|revolted|repulsed'))) {
      return 'Disgust';
    } else {
      return 'Neutral';
    }
  }

  Map<String, double> _generateEmotionBreakdown(String text) {
    final primary = _generatePrimaryEmotion(text);
    final emotions = <String, double>{};

    switch (primary) {
      case 'Joy':
        emotions['Joy'] = 0.85;
        emotions['Surprise'] = 0.15;
        emotions['Neutral'] = 0.05;
        break;
      case 'Sadness':
        emotions['Sadness'] = 0.80;
        emotions['Fear'] = 0.20;
        emotions['Neutral'] = 0.10;
        break;
      case 'Anger':
        emotions['Anger'] = 0.85;
        emotions['Disgust'] = 0.25;
        emotions['Sadness'] = 0.15;
        break;
      case 'Fear':
        emotions['Fear'] = 0.80;
        emotions['Sadness'] = 0.30;
        emotions['Surprise'] = 0.20;
        break;
      default:
        emotions['Neutral'] = 0.75;
        emotions['Joy'] = 0.15;
        emotions['Sadness'] = 0.10;
    }

    return emotions;
  }

  double _generateSentimentScore(String text) {
    final lowerText = text.toLowerCase();
    double score = 0.0;

    if (lowerText.contains(
      RegExp(r'good|great|excellent|amazing|fantastic|wonderful|love|perfect'),
    )) {
      score += 0.3;
    }
    if (lowerText.contains(
      RegExp(r'bad|terrible|awful|horrible|hate|worst|disgusting'),
    )) {
      score -= 0.3;
    }
    if (lowerText.contains(RegExp(r'thank|thanks|appreciate|grateful'))) {
      score += 0.2;
    }
    if (lowerText.contains(RegExp(r'sorry|apologize|regret|unfortunately'))) {
      score -= 0.1;
    }

    return (score + 0.5).clamp(0.0, 1.0);
  }

  double _generateIntensity(String text) {
    final exclamationMarks = text.split('!').length - 1;
    final capsWords = RegExp(r'\b[A-Z]{2,}\b').allMatches(text).length;
    final emotionalWords = RegExp(
      r'very|extremely|absolutely|completely|totally|incredibly|amazingly',
    ).allMatches(text.toLowerCase()).length;

    return ((exclamationMarks * 0.1) +
            (capsWords * 0.15) +
            (emotionalWords * 0.2))
        .clamp(0.0, 1.0);
  }

  double _calculatePositive(String text) {
    return _generateSentimentScore(text);
  }

  double _calculateNegative(String text) {
    return 1.0 - _generateSentimentScore(text);
  }

  double _calculateNeutral(String text) {
    final sentiment = _generateSentimentScore(text);
    return 1.0 - (sentiment - 0.5).abs() * 2;
  }

  List<String> _generateInsights(String text) {
    final insights = <String>[];
    final primary = _generatePrimaryEmotion(text);

    insights.add('Primary emotion detected: $primary');

    if (text.length > 100) {
      insights.add('Detailed text provides rich emotional context');
    }

    if (text.contains('!')) {
      insights.add('Exclamation marks indicate heightened emotional state');
    }

    if (RegExp(r'\b[A-Z]{2,}\b').hasMatch(text)) {
      insights.add('Capital letters suggest emphasis or strong feelings');
    }

    return insights;
  }

  List<String> _generateRecommendations(String text) {
    final recommendations = <String>[];
    final primary = _generatePrimaryEmotion(text);

    switch (primary) {
      case 'Joy':
        recommendations.add('Maintain positive engagement');
        recommendations.add('Consider amplifying this positive feedback');
        break;
      case 'Sadness':
        recommendations.add('Provide empathetic response');
        recommendations.add('Offer support and assistance');
        break;
      case 'Anger':
        recommendations.add('Address concerns promptly');
        recommendations.add('Use de-escalation techniques');
        break;
      case 'Fear':
        recommendations.add('Provide reassurance and clarity');
        recommendations.add('Address underlying concerns');
        break;
      default:
        recommendations.add('Monitor for emotional changes');
        recommendations.add('Engage with balanced approach');
    }

    return recommendations;
  }

  List<String> _extractEmotionalKeywords(String text) {
    final keywords = <String>[];
    final lowerText = text.toLowerCase();
    final emotionalWords = [
      'happy',
      'sad',
      'angry',
      'excited',
      'disappointed',
      'frustrated',
      'amazing',
      'terrible',
      'wonderful',
      'awful',
      'fantastic',
      'horrible',
      'love',
      'hate',
      'like',
      'dislike',
      'enjoy',
      'despise',
    ];

    for (final word in emotionalWords) {
      if (lowerText.contains(word)) {
        keywords.add(word);
      }
    }

    return keywords.take(5).toList();
  }

  String _analyzeTone(String text) {
    final lowerText = text.toLowerCase();

    if (lowerText.contains(
      RegExp(r'please|thank|appreciate|kindly|would you'),
    )) {
      return 'Polite';
    } else if (lowerText.contains(
      RegExp(r'amazing|fantastic|excellent|wonderful'),
    )) {
      return 'Enthusiastic';
    } else if (lowerText.contains(
      RegExp(r'unfortunately|sorry|regret|apologize'),
    )) {
      return 'Apologetic';
    } else if (lowerText.contains(RegExp(r'immediately|urgent|asap|now'))) {
      return 'Urgent';
    } else {
      return 'Neutral';
    }
  }

  void _useTemplate(String template) {
    _textController.text = template;
  }

  Widget _buildTextInputField(ThemeData theme, CustomSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Analysis Model Selector
        Row(
          children: [
            Icon(Icons.tune, color: AppColors.primary, size: 16),
            SizedBox(width: spacing.sm),
            Text(
              'Analysis Model',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.sm),
        Container(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedEmotionModel,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.primary,
                size: 16,
              ),
              onChanged: (value) {
                setState(() {
                  _selectedEmotionModel = value!;
                });
              },
              items: _emotionModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(
                    model,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: spacing.md),

        // Text Input Field
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Enter text to analyze emotions...',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(spacing.md),
            ),
            style: TextStyle(color: AppColors.textPrimary),
            maxLines: 4,
            minLines: 3,
          ),
        ),
      ],
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
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: AnalysisHeaderWidget(
                      title: 'Emotion Analyzer',
                      description: 'Advanced AI emotion detection and analysis',
                      icon: Icons.psychology,
                      gradientColors: const [
                        Color(0xFFf093fb),
                        Color(0xFFf5576c),
                      ],
                      stats: _quickStats,
                    ),
                  ),

                  // Text Input Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: AnalysisInputWidget(
                        inputType: 'Text Analysis',
                        inputWidget: _buildTextInputField(theme, customSpacing),
                        onAnalyze: _analyzeEmotion,
                        isAnalyzing: _isAnalyzing,
                        analyzeButtonText: 'Analyze Emotion',
                        quickActions: _quickTemplates.take(4).toList(),
                        onQuickAction: _useTemplate,
                      ),
                    ),
                  ),

                  // Quick Templates
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: _buildQuickTemplatesSection(theme, customSpacing),
                    ),
                  ),

                  // Analysis Result
                  if (_analysisResult != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: customSpacing.md,
                        ),
                        child: AnalysisResultWidget(
                          result: _analysisResult!,
                          isLoading: false,
                          analysisType: 'emotion',
                        ),
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
                            description: 'Process multiple texts',
                            icon: Icons.batch_prediction,
                            color: AppColors.primary,
                            onTap: () => _showBatchAnalysis(),
                          ),
                          AnalysisQuickAction(
                            title: 'Model Info',
                            description: 'View model details',
                            icon: Icons.model_training,
                            color: AppColors.secondary,
                            onTap: () => _showModelInfo(),
                          ),
                          AnalysisQuickAction(
                            title: 'Emotion Trends',
                            description: 'View trends analytics',
                            icon: Icons.analytics,
                            color: AppColors.success,
                            onTap: () => _showEmotionTrends(),
                          ),
                          AnalysisQuickAction(
                            title: 'Settings',
                            description: 'Configure analysis',
                            icon: Icons.settings,
                            color: AppColors.warning,
                            onTap: () => _showSettings(),
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
                  SliverToBoxAdapter(child: SizedBox(height: customSpacing.xl)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTemplatesSection(ThemeData theme, CustomSpacing spacing) {
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
              Icon(Icons.text_snippet, color: AppColors.primary, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Quick Templates',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.sm,
            children: _quickTemplates.map((template) {
              return GestureDetector(
                onTap: () => _useTemplate(template),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          template.length > 40
                              ? template.substring(0, 40) + '...'
                              : template,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showBatchAnalysis() {
    // Navigate to batch analysis screen
  }

  void _showModelInfo() {
    // Show model information dialog
  }

  void _showEmotionTrends() {
    // Show emotion trends analytics
  }

  void _showSettings() {
    // Show settings dialog
  }

  void _showHistoryDetails(AnalysisHistoryItem item) {
    // Show detailed history item
  }
}
