import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/analysis/analysis.dart';
import '../../widgets/common/animated_background_widget.dart';

class EnhancedVideoAnalysisScreen extends StatefulWidget {
  const EnhancedVideoAnalysisScreen({super.key});

  @override
  State<EnhancedVideoAnalysisScreen> createState() =>
      _EnhancedVideoAnalysisScreenState();
}

class _EnhancedVideoAnalysisScreenState
    extends State<EnhancedVideoAnalysisScreen>
    with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  bool _isValidUrl = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;
  String _selectedAnalysisType = 'Full Analysis';
  bool _isResultExpanded = false;

  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeAnimation;

  final List<AnalysisHistoryItem> _analysisHistory = [];

  final List<String> _analysisTypes = [
    'Full Analysis',
    'Facial Expression',
    'Body Language',
    'Engagement Level',
    'Presentation Quality',
  ];

  final List<AnalysisHeaderStat> _quickStats = [
    AnalysisHeaderStat(value: '24', label: 'Videos', icon: Icons.video_library),
    AnalysisHeaderStat(value: '8.7', label: 'Avg Score', icon: Icons.grade),
    AnalysisHeaderStat(value: '12s', label: 'Processing', icon: Icons.speed),
  ];

  final List<VideoSample> _sampleVideos = [
    VideoSample(
      id: '1',
      title: 'Customer Service Training',
      description: 'Professional customer interaction training session',
      url: 'https://example.com/customer-service-training.mp4',
      duration: '3:45',
      category: VideoCategory.training,
    ),
    VideoSample(
      id: '2',
      title: 'Product Presentation Demo',
      description: 'Executive presenting new product features',
      url: 'https://example.com/product-presentation.mp4',
      duration: '5:20',
      category: VideoCategory.presentation,
    ),
    VideoSample(
      id: '3',
      title: 'Job Interview Simulation',
      description: 'Mock interview for communication analysis',
      url: 'https://example.com/job-interview.mp4',
      duration: '4:15',
      category: VideoCategory.interview,
    ),
    VideoSample(
      id: '4',
      title: 'Team Feedback Session',
      description: 'Manager providing constructive feedback',
      url: 'https://example.com/feedback-session.mp4',
      duration: '2:30',
      category: VideoCategory.feedback,
    ),
    VideoSample(
      id: '5',
      title: 'Leadership Workshop',
      description: 'Leadership skills development session',
      url: 'https://example.com/leadership-workshop.mp4',
      duration: '6:10',
      category: VideoCategory.training,
    ),
    VideoSample(
      id: '6',
      title: 'Sales Pitch Practice',
      description: 'Sales representative practicing pitch delivery',
      url: 'https://example.com/sales-pitch.mp4',
      duration: '4:05',
      category: VideoCategory.presentation,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _urlFocusNode.addListener(_onFocusChanged);
    _urlController.addListener(_validateUrl);
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
        title: 'Customer Service Training Analysis',
        type: 'Full Analysis',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        confidence: 0.94,
        result: {'overall_score': 0.94, 'type': 'video'},
      ),
      AnalysisHistoryItem(
        id: '2',
        title: 'Product Presentation Analysis',
        type: 'Presentation Quality',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        confidence: 0.88,
        result: {'overall_score': 0.88, 'type': 'video'},
      ),
      AnalysisHistoryItem(
        id: '3',
        title: 'Interview Communication Analysis',
        type: 'Facial Expression',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        confidence: 0.82,
        result: {'overall_score': 0.82, 'type': 'video'},
      ),
    ]);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    _urlController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _validateUrl() {
    final url = _urlController.text.trim();
    final isValid = _isValidVideoUrl(url);
    if (isValid != _isValidUrl) {
      setState(() {
        _isValidUrl = isValid;
      });
    }
  }

  bool _isValidVideoUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          (url.contains('.mp4') ||
              url.contains('.mov') ||
              url.contains('.avi') ||
              url.contains('.webm') ||
              url.contains('youtube.com') ||
              url.contains('youtu.be') ||
              url.contains('vimeo.com'));
    } catch (e) {
      return false;
    }
  }

  Future<void> _analyzeVideo() async {
    if (!_isValidUrl) return;

    HapticFeedback.mediumImpact();
    setState(() => _isAnalyzing = true);

    // Simulate video analysis with realistic timing
    await Future.delayed(const Duration(seconds: 5));

    final result = {
      'overall_score': 0.87,
      'video_url': _urlController.text,
      'duration': '3:42',
      'analysis_type': _selectedAnalysisType,
      'facial_analysis': {
        'Happiness': 0.75,
        'Confidence': 0.92,
        'Engagement': 0.78,
        'Professionalism': 0.95,
        'Eye Contact': 0.88,
        'Expressiveness': 0.74,
      },
      'body_language': {
        'Posture': 0.91,
        'Gestures': 0.76,
        'Movement': 0.82,
        'Hand Positioning': 0.79,
        'Body Orientation': 0.85,
        'Energy Level': 0.73,
      },
      'presentation_quality': {
        'Voice Clarity': 0.89,
        'Speaking Pace': 0.83,
        'Volume Control': 0.91,
        'Articulation': 0.87,
        'Tone Variation': 0.76,
        'Filler Words': 0.68,
      },
      'engagement_metrics': {
        'Attention Holding': 0.84,
        'Emotional Connection': 0.78,
        'Information Delivery': 0.92,
        'Overall Impact': 0.85,
        'Audience Appeal': 0.81,
        'Message Clarity': 0.89,
      },
      'insights': [
        'Excellent professional demeanor maintained throughout the video',
        'Strong eye contact and confident posture demonstrate authority',
        'Clear voice delivery with good pacing and articulation',
        'Engaging hand gestures effectively support the verbal message',
        'Consistent energy level keeps audience engaged',
        'Professional attire and setup enhance credibility',
      ],
      'recommendations': [
        'Consider reducing filler words for more polished delivery',
        'Add more dynamic movement to increase visual interest',
        'Vary tone more to emphasize key points',
        'Practice pausing for emphasis instead of using filler words',
        'Use more open gestures to appear more approachable',
        'Consider adding visual aids to support complex concepts',
      ],
      'key_moments': [
        {
          'timestamp': '0:15',
          'description':
              'Strong opening with confident introduction and clear objectives',
        },
        {
          'timestamp': '1:25',
          'description':
              'Peak engagement during main content delivery with excellent gestures',
        },
        {
          'timestamp': '2:45',
          'description':
              'Effective use of pause and emphasis for key point delivery',
        },
        {
          'timestamp': '3:30',
          'description':
              'Professional closing with clear call-to-action and summary',
        },
      ],
      'detailed_metrics': {
        'speaking_time': '3:12',
        'pause_frequency': 'Optimal',
        'gesture_count': 45,
        'eye_contact_percentage': 88,
        'smile_frequency': 'High',
        'posture_stability': 'Excellent',
      },
    };

    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
    });

    // Add to history
    final historyItem = AnalysisHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Video Analysis - $_selectedAnalysisType',
      type: _selectedAnalysisType,
      timestamp: DateTime.now(),
      confidence: (result['overall_score'] as double?) ?? 0.0,
      result: result,
    );

    setState(() {
      _analysisHistory.insert(0, historyItem);
    });

    HapticFeedback.lightImpact();
  }

  void _clearAnalysis() {
    setState(() {
      _analysisResult = null;
      _urlController.clear();
      _isValidUrl = false;
    });
  }

  void _useSampleVideo(String url) {
    _urlController.text = url;
    _validateUrl();
  }

  void _onAnalysisTypeChanged(String type) {
    setState(() {
      _selectedAnalysisType = type;
    });
  }

  void _toggleResultExpanded() {
    setState(() {
      _isResultExpanded = !_isResultExpanded;
    });
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
                      title: 'AI Video Analysis',
                      description:
                          'Advanced video emotion and behavior analysis with AI',
                      icon: Icons.video_camera_back,
                      gradientColors: const [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                      stats: _quickStats,
                    ),
                  ),

                  // Video Input Section
                  SliverToBoxAdapter(
                    child: VideoInputWidget(
                      urlController: _urlController,
                      urlFocusNode: _urlFocusNode,
                      isValidUrl: _isValidUrl,
                      isAnalyzing: _isAnalyzing,
                      selectedAnalysisType: _selectedAnalysisType,
                      analysisTypes: _analysisTypes,
                      onAnalysisTypeChanged: _onAnalysisTypeChanged,
                      onAnalyze: _analyzeVideo,
                      onClear: _clearAnalysis,
                      analysisResult: _analysisResult,
                    ),
                  ),

                  // Sample Videos
                  SliverToBoxAdapter(
                    child: VideoSamplesWidget(
                      sampleVideos: _sampleVideos,
                      onSampleSelected: _useSampleVideo,
                    ),
                  ),

                  // Analysis Result
                  if (_analysisResult != null)
                    SliverToBoxAdapter(
                      child: VideoAnalysisResultWidget(
                        result: _analysisResult!,
                        isExpanded: _isResultExpanded,
                        onToggleExpand: _toggleResultExpanded,
                      ),
                    ),

                  // Quick Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: AnalysisQuickActionsWidget(
                        actions: [
                          AnalysisQuickAction(
                            title: 'Video Settings',
                            description: 'Configure analysis parameters',
                            icon: Icons.video_settings,
                            color: AppColors.primary,
                            onTap: () => _showVideoSettings(),
                          ),
                          AnalysisQuickAction(
                            title: 'Video Library',
                            description: 'Browse uploaded videos',
                            icon: Icons.video_library,
                            color: AppColors.secondary,
                            onTap: () => _showVideoLibrary(),
                          ),
                          AnalysisQuickAction(
                            title: 'Analytics Dashboard',
                            description: 'View detailed analytics',
                            icon: Icons.analytics,
                            color: AppColors.success,
                            onTap: () => _showVideoAnalytics(),
                          ),
                          AnalysisQuickAction(
                            title: 'Training Resources',
                            description: 'Video analysis tutorials',
                            icon: Icons.school,
                            color: AppColors.warning,
                            onTap: () => _showVideoTraining(),
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

  void _showVideoSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VideoSettingsBottomSheet(),
    );
  }

  void _showVideoLibrary() {
    // Navigate to video library screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Video Library - Feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showVideoAnalytics() {
    // Navigate to video analytics screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analytics Dashboard - Feature coming soon!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showVideoTraining() {
    // Navigate to video training screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Training Resources - Feature coming soon!'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _showHistoryDetails(AnalysisHistoryItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Analysis Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${item.title}'),
                Text('Type: ${item.type}'),
                Text(
                  'Confidence: ${((item.confidence ?? 0.0) * 100).toInt()}%',
                ),
                Text('Date: ${item.timestamp.toString().split('.')[0]}'),
              ],
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
}

class _VideoSettingsBottomSheet extends StatefulWidget {
  @override
  State<_VideoSettingsBottomSheet> createState() =>
      _VideoSettingsBottomSheetState();
}

class _VideoSettingsBottomSheetState extends State<_VideoSettingsBottomSheet> {
  bool _enableFacialAnalysis = true;
  bool _enableBodyLanguage = true;
  bool _enableVoiceAnalysis = true;
  bool _enableEngagementMetrics = true;
  double _analysisDepth = 0.8;
  String _outputFormat = 'Detailed';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: customSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(customSpacing.lg),
            child: Row(
              children: [
                Text(
                  'Video Analysis Settings',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Settings
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
              children: [
                _buildSettingToggle(
                  'Facial Expression Analysis',
                  'Analyze facial expressions and emotions',
                  _enableFacialAnalysis,
                  (value) => setState(() => _enableFacialAnalysis = value),
                  theme,
                  customSpacing,
                ),
                _buildSettingToggle(
                  'Body Language Analysis',
                  'Analyze posture, gestures, and movement',
                  _enableBodyLanguage,
                  (value) => setState(() => _enableBodyLanguage = value),
                  theme,
                  customSpacing,
                ),
                _buildSettingToggle(
                  'Voice Analysis',
                  'Analyze speech patterns and vocal delivery',
                  _enableVoiceAnalysis,
                  (value) => setState(() => _enableVoiceAnalysis = value),
                  theme,
                  customSpacing,
                ),
                _buildSettingToggle(
                  'Engagement Metrics',
                  'Measure audience engagement indicators',
                  _enableEngagementMetrics,
                  (value) => setState(() => _enableEngagementMetrics = value),
                  theme,
                  customSpacing,
                ),

                SizedBox(height: customSpacing.lg),

                _buildSliderSetting(
                  'Analysis Depth',
                  'Higher depth provides more detailed analysis',
                  _analysisDepth,
                  (value) => setState(() => _analysisDepth = value),
                  theme,
                  customSpacing,
                ),

                SizedBox(height: customSpacing.lg),

                _buildDropdownSetting(
                  'Output Format',
                  'Choose the format for analysis results',
                  _outputFormat,
                  ['Summary', 'Detailed', 'Technical'],
                  (value) => setState(() => _outputFormat = value!),
                  theme,
                  customSpacing,
                ),
              ],
            ),
          ),

          // Apply Button
          Padding(
            padding: EdgeInsets.all(customSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Settings saved successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: customSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Settings',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingToggle(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    String description,
    double value,
    Function(double) onChanged,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.md),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            label: '${(value * 100).toInt()}%',
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String description,
    String value,
    List<String> options,
    Function(String?) onChanged,
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
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.md),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
            ),
            items:
                options.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
          ),
        ],
      ),
    );
  }
}
