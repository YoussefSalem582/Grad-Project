import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class EmployeeVoiceAnalysisScreen extends StatefulWidget {
  const EmployeeVoiceAnalysisScreen({super.key});

  @override
  State<EmployeeVoiceAnalysisScreen> createState() =>
      _EmployeeVoiceAnalysisScreenState();
}

class _EmployeeVoiceAnalysisScreenState
    extends State<EmployeeVoiceAnalysisScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isAnalyzing = false;
  bool _hasRecording = false;
  String _recordingDuration = '00:00';
  double _recordingLevel = 0.0;
  Map<String, dynamic>? _analysisResult;
  late AnimationController _waveController;
  late AnimationController _levelController;
  late AnimationController _pulseController;
  late AnimationController _resultController;
  late Animation<double> _resultAnimation;

  final List<Map<String, dynamic>> _recentRecordings = [];
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _levelController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
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
    _waveController.dispose();
    _levelController.dispose();
    _pulseController.dispose();
    _resultController.dispose();
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
            _buildRecordingSection(theme, customSpacing),
            SizedBox(height: customSpacing.lg),
            if (_analysisResult != null) ...[
              _buildAnalysisResult(theme, customSpacing),
              SizedBox(height: customSpacing.lg),
            ],
            _buildQuickActions(theme, customSpacing),
            SizedBox(height: customSpacing.lg),
            _buildRecentRecordings(theme, customSpacing),
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
          gradient: AppColors.successGradient,
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
                    Icons.record_voice_over,
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
                        'AI Voice Analysis',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: customSpacing.xs),
                      Text(
                        'Real-time speech emotion & quality analysis',
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
                    '12',
                    Icons.analytics,
                    customSpacing,
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: _buildHeaderStat(
                    'Quality Score',
                    '8.7/10',
                    Icons.star,
                    customSpacing,
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: _buildHeaderStat(
                    'Processing',
                    '2.1s',
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

  Widget _buildRecordingSection(ThemeData theme, CustomSpacing customSpacing) {
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
                  gradient: AppColors.successGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 20),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Recording Studio',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Professional-grade voice analysis',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Recording status indicator
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.md,
                  vertical: customSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: _isRecording
                      ? AppColors.error.withValues(alpha: 0.1)
                      : _hasRecording
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isRecording
                        ? AppColors.error
                        : _hasRecording
                        ? AppColors.success
                        : AppColors.info,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isRecording
                              ? (1.0 + _pulseController.value * 0.3)
                              : 1.0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isRecording
                                  ? AppColors.error
                                  : _hasRecording
                                  ? AppColors.success
                                  : AppColors.info,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: customSpacing.xs),
                    Text(
                      _isRecording
                          ? 'RECORDING'
                          : _hasRecording
                          ? 'READY'
                          : 'IDLE',
                      style: TextStyle(
                        color: _isRecording
                            ? AppColors.error
                            : _hasRecording
                            ? AppColors.success
                            : AppColors.info,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: customSpacing.lg),

          // Enhanced recording visualization
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Grid background
                Positioned.fill(child: CustomPaint(painter: GridPainter())),

                // Waveform visualization
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WaveformPainter(
                          animationValue: _waveController.value,
                          isRecording: _isRecording,
                          recordingLevel: _recordingLevel,
                        ),
                      );
                    },
                  ),
                ),

                // Recording timer overlay
                Positioned(
                  top: customSpacing.md,
                  left: customSpacing.md,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: customSpacing.md,
                      vertical: customSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isRecording
                              ? Icons.fiber_manual_record
                              : Icons.timer,
                          color: _isRecording ? AppColors.error : Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: customSpacing.xs),
                        Text(
                          _recordingDuration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Audio level meter
                Positioned(
                  top: customSpacing.md,
                  right: customSpacing.md,
                  child: Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 80 * _recordingLevel,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.success,
                                AppColors.warning,
                                AppColors.error,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Center(
                          child: Text(
                            'LEVEL',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Center recording button
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isRecording
                                ? (1.0 + _pulseController.value * 0.2)
                                : 1.0,
                            child: GestureDetector(
                              onTap: _toggleRecording,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: _isRecording
                                      ? LinearGradient(
                                          colors: [
                                            AppColors.error,
                                            AppColors.error.withValues(
                                              alpha: 0.8,
                                            ),
                                          ],
                                        )
                                      : AppColors.successGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (_isRecording
                                                  ? AppColors.error
                                                  : AppColors.success)
                                              .withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isRecording ? Icons.stop : Icons.mic,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: customSpacing.md),
                      Text(
                        _isRecording
                            ? 'Tap to Stop Recording'
                            : _hasRecording
                            ? 'Tap to Record Again'
                            : 'Tap to Start Recording',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: customSpacing.lg),

          // Recording controls
          Row(
            children: [
              // Play/Pause button
              Expanded(
                child: ModernButton(
                  onPressed: _hasRecording ? _playRecording : null,
                  style: ModernButtonStyle.outlined,
                  icon: Icons.play_arrow,
                  text: 'Play',
                ),
              ),
              SizedBox(width: customSpacing.md),

              // Analyze button
              Expanded(
                flex: 2,
                child: ModernButton(
                  onPressed: _hasRecording && !_isAnalyzing
                      ? _analyzeRecording
                      : null,
                  style: ModernButtonStyle.primary,
                  icon: _isAnalyzing ? null : Icons.analytics,
                  text: _isAnalyzing ? 'Analyzing...' : 'Analyze Voice',
                  isLoading: _isAnalyzing,
                ),
              ),
              SizedBox(width: customSpacing.md),

              // Delete button
              Expanded(
                child: ModernButton(
                  onPressed: _hasRecording ? _deleteRecording : null,
                  style: ModernButtonStyle.ghost,
                  icon: Icons.delete,
                  text: 'Delete',
                ),
              ),
            ],
          ),

          if (_hasRecording) ...[
            SizedBox(height: customSpacing.lg),

            // Recording info
            Container(
              padding: EdgeInsets.all(customSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 20),
                  SizedBox(width: customSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recording Details',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Duration: $_recordingDuration • Quality: High • Format: WAV',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      'Ready',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
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
                  'Voice Analysis Results',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: customSpacing.lg),
            _buildVoiceMetrics(theme, customSpacing),
            SizedBox(height: customSpacing.md),
            _buildEmotionAnalysis(theme, customSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceMetrics(ThemeData theme, CustomSpacing customSpacing) {
    final metrics =
        _analysisResult?['metrics'] ??
        {
          'sentiment': 'Positive',
          'emotion': 'Confident',
          'clarity': 0.92,
          'pace': 'Optimal',
          'tone': 'Professional',
        };

    return Container(
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Sentiment',
                  metrics['sentiment'],
                  Icons.sentiment_satisfied_alt,
                  AppColors.success,
                  customSpacing,
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Expanded(
                child: _buildMetricItem(
                  'Emotion',
                  metrics['emotion'],
                  Icons.psychology,
                  AppColors.primary,
                  customSpacing,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Clarity',
                  '${(metrics['clarity'] * 100).toInt()}%',
                  Icons.volume_up,
                  AppColors.info,
                  customSpacing,
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Expanded(
                child: _buildMetricItem(
                  'Pace',
                  metrics['pace'],
                  Icons.speed,
                  AppColors.warning,
                  customSpacing,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
    CustomSpacing customSpacing,
  ) {
    return Container(
      padding: EdgeInsets.all(customSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: customSpacing.xs),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEmotionAnalysis(ThemeData theme, CustomSpacing customSpacing) {
    final emotions =
        _analysisResult?['emotions'] ??
        {
          'Confidence': 0.8,
          'Friendliness': 0.7,
          'Professionalism': 0.9,
          'Enthusiasm': 0.6,
        };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emotional Indicators',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: customSpacing.sm),
        ...emotions.entries.map((entry) {
          final color = _getEmotionColor(entry.key);
          return Container(
            margin: EdgeInsets.only(bottom: customSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: LinearProgressIndicator(
                    value: entry.value,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Text(
                  '${(entry.value * 100).toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme, CustomSpacing customSpacing) {
    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.sm,
            mainAxisSpacing: customSpacing.sm,
            childAspectRatio: 2.5,
            children: [
              _buildQuickActionItem(
                'Live Call Analysis',
                Icons.call,
                AppColors.primary,
                () => _startLiveAnalysis(),
                customSpacing,
              ),
              _buildQuickActionItem(
                'Upload Recording',
                Icons.file_upload,
                AppColors.secondary,
                () => _uploadAudio(),
                customSpacing,
              ),
              _buildQuickActionItem(
                'Voice Training',
                Icons.school,
                AppColors.warning,
                () => _startVoiceTraining(),
                customSpacing,
              ),
              _buildQuickActionItem(
                'Export Report',
                Icons.download,
                AppColors.info,
                () => _exportReport(),
                customSpacing,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    CustomSpacing customSpacing,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(customSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: customSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecordings(ThemeData theme, CustomSpacing customSpacing) {
    return GlassCard(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Recordings',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              ModernButton(
                onPressed: _viewAllRecordings,
                style: ModernButtonStyle.ghost,
                icon: Icons.history,
                text: 'View All',
                size: ModernButtonSize.small,
              ),
            ],
          ),
          SizedBox(height: customSpacing.md),
          if (_recentRecordings.isEmpty)
            Container(
              padding: EdgeInsets.all(customSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.mic_none,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: customSpacing.sm),
                  Text(
                    'No recordings yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Your recording history will appear here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(
              _recentRecordings.length.clamp(0, 3),
              (index) => _buildRecordingItem(
                _recentRecordings[index],
                theme,
                customSpacing,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecordingItem(
    Map<String, dynamic> recording,
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
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          SizedBox(width: customSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recording['title'] ?? 'Voice Recording',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${recording['duration']} • ${recording['sentiment']} • ${recording['time']}',
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
      case 'confidence':
        return AppColors.primary;
      case 'friendliness':
        return AppColors.success;
      case 'professionalism':
        return AppColors.info;
      case 'enthusiasm':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasRecording = true;
        _waveController.stop();
        _pulseController.stop();
      } else {
        _isRecording = true;
        _hasRecording = false;
        _seconds = 0;
        _recordingLevel = 0.0;
        _startRecordingTimer();
        _waveController.repeat();
        _pulseController.repeat();
        _simulateAudioLevel();
      }
    });
  }

  void _startRecordingTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _seconds++;
          final minutes = _seconds ~/ 60;
          final remainingSeconds = _seconds % 60;
          _recordingDuration =
              '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
        });
        _startRecordingTimer();
      }
    });
  }

  void _simulateAudioLevel() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingLevel = 0.3 + (DateTime.now().millisecond % 100) / 150;
        });
        _simulateAudioLevel();
      }
    });
  }

  void _playRecording() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing recording...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _analyzeRecording() {
    setState(() => _isAnalyzing = true);

    // Simulate analysis
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _analysisResult = {
            'sentiment': 'Positive',
            'confidence': 0.89,
            'emotions': {
              'happiness': 0.7,
              'confidence': 0.6,
              'excitement': 0.4,
            },
            'speech_quality': {
              'clarity': 0.92,
              'pace': 'Optimal',
              'volume': 'Good',
            },
            'insights': [
              'Clear and confident speech',
              'Positive emotional tone',
              'Good pace and articulation',
            ],
          };
        });
        _resultController.forward();
      }
    });
  }

  void _deleteRecording() {
    setState(() {
      _hasRecording = false;
      _recordingDuration = '00:00';
      _analysisResult = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recording deleted'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _uploadAudio() {
    // TODO: Implement audio upload
  }

  void _startLiveAnalysis() {
    // TODO: Implement live analysis
  }

  void _startVoiceTraining() {
    // TODO: Implement voice training
  }

  void _exportReport() {
    // TODO: Implement export
  }

  void _viewAllRecordings() {
    // TODO: Implement view all recordings
  }
}

// Custom painters for enhanced visualization
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw horizontal lines
    for (int i = 0; i <= 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (int i = 0; i <= 20; i++) {
      final x = (size.width / 20) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaveformPainter extends CustomPainter {
  final double animationValue;
  final bool isRecording;
  final double recordingLevel;

  WaveformPainter({
    required this.animationValue,
    required this.isRecording,
    required this.recordingLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (isRecording) {
      // Draw live waveform
      paint.color = AppColors.success;

      final path = Path();
      final centerY = size.height / 2;

      for (int x = 0; x < size.width; x += 5) {
        final frequency = 0.02 + recordingLevel * 0.01;
        final amplitude = (size.height / 4) * recordingLevel;
        final y =
            centerY +
            amplitude * sin((x * frequency) + (animationValue * 2 * pi));

        if (x == 0) {
          path.moveTo(x.toDouble(), y);
        } else {
          path.lineTo(x.toDouble(), y);
        }
      }

      canvas.drawPath(path, paint);
    } else {
      // Draw static waveform pattern
      paint.color = AppColors.primary.withValues(alpha: 0.5);

      final path = Path();
      final centerY = size.height / 2;

      for (int x = 0; x < size.width; x += 3) {
        final amplitude = (size.height / 6) * (0.5 + 0.5 * sin(x * 0.02));
        final y = centerY + amplitude * sin(x * 0.01);

        if (x == 0) {
          path.moveTo(x.toDouble(), y);
        } else {
          path.lineTo(x.toDouble(), y);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
