import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import 'base_analysis_screen.dart';

class EnhancedVoiceAnalysisScreen extends BaseAnalysisScreen {
  const EnhancedVoiceAnalysisScreen({super.key});

  @override
  State<EnhancedVoiceAnalysisScreen> createState() =>
      _EnhancedVoiceAnalysisScreenState();
}

class _EnhancedVoiceAnalysisScreenState
    extends BaseAnalysisScreenState<EnhancedVoiceAnalysisScreen> {
  bool _isRecording = false;
  bool _isAnalyzing = false;
  bool _hasRecording = false;
  String _recordingDuration = '00:00';
  double _recordingLevel = 0.0;
  Map<String, dynamic>? _analysisResult;

  late AnimationController _waveController;
  late AnimationController _levelController;
  late AnimationController _recordingController;
  late AnimationController _resultController;
  late Animation<double> _resultAnimation;

  final List<Map<String, dynamic>> _recentRecordings = [];
  int _recordingSeconds = 0;

  @override
  String get analysisType => 'AI Voice Analysis';

  @override
  IconData get analysisIcon => Icons.record_voice_over;

  @override
  String get analysisDescription =>
      'Real-time voice emotion and sentiment analysis';

  @override
  List<Color> get gradientColors => [
    const Color(0xFF11998e),
    const Color(0xFF38ef7d),
  ];

  @override
  List<Map<String, dynamic>> get headerStats => [
    {'label': 'Recordings', 'value': '23', 'icon': Icons.mic},
    {'label': 'Accuracy', 'value': '96%', 'icon': Icons.verified},
    {'label': 'Avg Length', 'value': '2.1m', 'icon': Icons.timer},
  ];

  @override
  void initState() {
    super.initState();
    _initializeVoiceAnimations();
  }

  void _initializeVoiceAnimations() {
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _levelController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    _recordingController.dispose();
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
        // Recording Section
        _buildRecordingSection(theme, spacing),
        SizedBox(height: spacing.lg),

        // Analysis Result
        if (_analysisResult != null) ...[
          _buildAnalysisResult(theme, spacing),
          SizedBox(height: spacing.lg),
        ],

        // Quick Actions
        _buildQuickActions(theme, spacing),
      ],
    );
  }

  @override
  Widget? buildAdditionalFeatures(
    BuildContext context,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return _buildRecentRecordings(theme, spacing);
  }

  Widget _buildRecordingSection(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Recording Visualizer
          _buildRecordingVisualizer(theme, spacing),
          SizedBox(height: spacing.xl),

          // Recording Duration
          Text(
            _recordingDuration,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _isRecording
                  ? gradientColors.first
                  : AppColors.textPrimary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: spacing.lg),

          // Recording Controls
          _buildRecordingControls(theme, spacing),

          if (_hasRecording && !_isRecording) ...[
            SizedBox(height: spacing.lg),
            _buildAnalyzeButton(theme, spacing),
          ],
        ],
      ),
    );
  }

  Widget _buildRecordingVisualizer(ThemeData theme, CustomSpacing spacing) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circles
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _recordingController,
              builder: (context, child) {
                final scale =
                    1.0 + (index * 0.3) + (_recordingController.value * 0.2);
                final opacity =
                    (1.0 - (index * 0.3)) *
                    (_isRecording ? 0.3 : 0.1) *
                    (1.0 - _recordingController.value);

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gradientColors.first.withValues(alpha: opacity),
                      border: Border.all(
                        color: gradientColors.first.withValues(
                          alpha: opacity * 0.5,
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main Record Button
          GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _isRecording
                    ? LinearGradient(colors: [Colors.red, Colors.red.shade400])
                    : LinearGradient(colors: gradientColors),
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording ? Colors.red : gradientColors.first)
                        .withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          // Wave Animation
          if (_isRecording)
            ...List.generate(5, (index) {
              return AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  final delay = index * 0.2;
                  final value = (_waveController.value + delay) % 1.0;
                  final height =
                      20 + (sin(value * 2 * pi) * 15 * _recordingLevel);

                  return Positioned(
                    left: 40 + (index * 20.0),
                    child: Container(
                      width: 4,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRecordingControls(ThemeData theme, CustomSpacing spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Play/Pause
        _buildControlButton(
          icon: _hasRecording ? Icons.play_arrow : Icons.play_disabled,
          label: 'Play',
          onTap: _hasRecording ? _playRecording : null,
          theme: theme,
          spacing: spacing,
        ),

        // Delete
        _buildControlButton(
          icon: Icons.delete_outline,
          label: 'Delete',
          onTap: _hasRecording ? _deleteRecording : null,
          theme: theme,
          spacing: spacing,
        ),

        // Save
        _buildControlButton(
          icon: Icons.save_alt,
          label: 'Save',
          onTap: _hasRecording ? _saveRecording : null,
          theme: theme,
          spacing: spacing,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required ThemeData theme,
    required CustomSpacing spacing,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.surfaceVariant
              : AppColors.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled
                ? AppColors.border
                : AppColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isEnabled
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withValues(alpha: 0.5),
              size: 20,
            ),
            SizedBox(height: spacing.xs),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isEnabled
                    ? AppColors.textPrimary
                    : AppColors.textSecondary.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(ThemeData theme, CustomSpacing spacing) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isAnalyzing ? null : _performAnalysis,
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
                  const Text('Analyzing Voice...'),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.psychology, size: 20),
                  SizedBox(width: spacing.sm),
                  const Text(
                    'Analyze Voice',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
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
            color: gradientColors.first.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.1),
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
                    color: gradientColors.first.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: gradientColors.first,
                    size: 20,
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    'Voice Analysis Complete',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.lg),

            // Voice metrics
            _buildVoiceMetric('Emotion', 'Confident', '89%', AppColors.success),
            SizedBox(height: spacing.md),
            _buildVoiceMetric('Stress Level', 'Low', '23%', AppColors.info),
            SizedBox(height: spacing.md),
            _buildVoiceMetric('Clarity', 'Excellent', '95%', AppColors.warning),
            SizedBox(height: spacing.md),
            _buildVoiceMetric('Pace', 'Natural', '78%', AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceMetric(
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

  Widget _buildQuickActions(ThemeData theme, CustomSpacing spacing) {
    final actions = [
      {
        'title': 'Speech Training',
        'icon': Icons.school,
        'color': AppColors.primary,
      },
      {
        'title': 'Voice Samples',
        'icon': Icons.library_music,
        'color': AppColors.info,
      },
      {'title': 'Settings', 'icon': Icons.tune, 'color': AppColors.warning},
      {
        'title': 'Export Data',
        'icon': Icons.download,
        'color': AppColors.success,
      },
    ];

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
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: spacing.sm,
            mainAxisSpacing: spacing.sm,
            childAspectRatio: 2.5,
            children: actions.map((action) {
              return _buildActionCard(
                action['title'] as String,
                action['icon'] as IconData,
                action['color'] as Color,
                theme,
                spacing,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecordings(ThemeData theme, CustomSpacing spacing) {
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
                  'Recent Recordings',
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
          if (_recentRecordings.isEmpty)
            Container(
              padding: EdgeInsets.all(spacing.xl),
              child: Column(
                children: [
                  Icon(
                    Icons.mic_none,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    'No recordings yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    'Start recording to build your voice analysis history',
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

  void _toggleRecording() async {
    HapticFeedback.mediumImpact();

    if (_isRecording) {
      // Stop recording
      setState(() {
        _isRecording = false;
        _hasRecording = true;
      });
      _recordingController.stop();
      _waveController.stop();
    } else {
      // Start recording
      setState(() {
        _isRecording = true;
        _hasRecording = false;
        _recordingSeconds = 0;
        _recordingDuration = '00:00';
      });
      _recordingController.repeat();
      _waveController.repeat();
      _startTimer();
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording) {
        setState(() {
          _recordingSeconds++;
          final minutes = _recordingSeconds ~/ 60;
          final seconds = _recordingSeconds % 60;
          _recordingDuration =
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          _recordingLevel =
              0.3 + (Random().nextDouble() * 0.7); // Simulate voice level
        });
        return true;
      }
      return false;
    });
  }

  void _playRecording() {
    HapticFeedback.lightImpact();
    // Implement play functionality
  }

  void _deleteRecording() {
    HapticFeedback.lightImpact();
    setState(() {
      _hasRecording = false;
      _recordingDuration = '00:00';
      _analysisResult = null;
    });
  }

  void _saveRecording() {
    HapticFeedback.lightImpact();
    // Implement save functionality
  }

  void _performAnalysis() async {
    if (!_hasRecording) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isAnalyzing = false;
      _analysisResult = {
        'emotion': 'Confident',
        'stress': 0.23,
        'clarity': 0.95,
        'pace': 0.78,
      };
    });

    _resultController.forward();
    HapticFeedback.mediumImpact();
  }
}
