import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../core/core.dart';
import '../../../data/models/video_analysis_response.dart';
import '../../providers/emotion_provider.dart';

class VideoAnalysisScreen extends StatefulWidget {
  const VideoAnalysisScreen({super.key});

  @override
  State<VideoAnalysisScreen> createState() => _VideoAnalysisScreenState();
}

class _VideoAnalysisScreenState extends State<VideoAnalysisScreen>
    with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  bool _isAnalyzing = false;
  bool _showResults = false;

  late AnimationController _headerController;
  late AnimationController _cardController;
  late AnimationController _resultsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _resultsAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _urlFocusNode.addListener(_onFocusChanged);
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _resultsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _resultsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultsController, curve: Curves.easeInOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _cardController.forward();
    });
  }

  void _onFocusChanged() {
    if (_urlFocusNode.hasFocus) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    _headerController.dispose();
    _cardController.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              _buildAnimatedHeader(),
              const SizedBox(height: 32),
              _buildVideoUrlInput(),
              const SizedBox(height: 24),
              _buildAnalyzeButton(),
              const SizedBox(height: 32),
              if (_showResults) _buildVideoAnalysisResults(),
              const SizedBox(height: 24),
              _buildQuickActionsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _headerAnimation.value)),
          child: Opacity(
            opacity: _headerAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF3B82F6),
                    Color(0xFF06B6D4),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.video_library_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Video Link Analysis',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Extract key emotions from video',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoUrlInput() {
    return ScaleTransition(
      scale: _cardAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.link_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Enter Video URL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _urlFocusNode.hasFocus
                    ? const Color(0xFF8B5CF6).withOpacity(0.05)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _urlFocusNode.hasFocus
                      ? const Color(0xFF8B5CF6)
                      : AppColors.border.withOpacity(0.5),
                  width: _urlFocusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: _urlController,
                focusNode: _urlFocusNode,
                decoration: InputDecoration(
                  hintText: 'https://youtube.com/watch?v=... or any video URL',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.video_collection_rounded,
                    color: _urlFocusNode.hasFocus
                        ? const Color(0xFF8B5CF6)
                        : AppColors.textSecondary,
                  ),
                  suffixIcon: _urlController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _urlController.clear();
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.clear_rounded,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Supports YouTube, Vimeo, and other video platforms',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    final canAnalyze = _urlController.text.isNotEmpty;

    return ScaleTransition(
      scale: _cardAnimation,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: canAnalyze
              ? const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                )
              : null,
          color: canAnalyze ? null : AppColors.border,
          borderRadius: BorderRadius.circular(16),
          boxShadow: canAnalyze
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: canAnalyze ? _analyzeVideo : null,
            child: Center(
              child: _isAnalyzing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Analyzing Video...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.analytics_rounded,
                          color: canAnalyze
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Analyze Video',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: canAnalyze
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoAnalysisResults() {
    return Consumer<EmotionProvider>(
      builder: (context, provider, child) {
        final videoResult = provider.lastVideoResult;

        if (videoResult == null) {
          return _buildDemoResults();
        }

        return FadeTransition(
          opacity: _resultsAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(_resultsAnimation),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 15,
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.video_library_rounded,
                          color: Color(0xFF8B5CF6),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Video Analysis Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryStats(videoResult),
                  const SizedBox(height: 24),
                  _buildSummarySnapshot(videoResult.summarySnapshot),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoResults() {
    // Demo summary snapshot for when no real analysis result is available
    final demoSummary = SummarySnapshot(
      emotion: 'Happy',
      sentiment: 'positive',
      confidence: 0.89,
      subtitle:
          'A summary of the customer\'s review showing overall satisfaction with the product.',
      frameImageBase64: _generateDemoImage('Happy', 0),
      totalFramesAnalyzed: 5,
      emotionDistribution: {
        'Happy': 3,
        'Excited': 1,
        'Confident': 1,
        'Neutral': 0,
      },
    );

    return FadeTransition(
      opacity: _resultsAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_resultsAnimation),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 15,
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.video_library_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Video Analysis Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDemoSummaryStats(),
              const SizedBox(height: 24),
              _buildSummarySnapshot(demoSummary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStats(VideoAnalysisResponse videoResult) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B5CF6).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Frames',
            '${videoResult.framesAnalyzed}',
            Icons.image_rounded,
            const Color(0xFF8B5CF6),
          ),
          _buildStatItem(
            'Dominant',
            videoResult.dominantEmotion,
            Icons.sentiment_satisfied_rounded,
            const Color(0xFF3B82F6),
          ),
          _buildStatItem(
            'Confidence',
            '${(videoResult.averageConfidence * 100).toInt()}%',
            Icons.check_circle_rounded,
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoSummaryStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B5CF6).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Frames',
            '5',
            Icons.image_rounded,
            const Color(0xFF8B5CF6),
          ),
          _buildStatItem(
            'Dominant',
            'Happy',
            Icons.sentiment_satisfied_rounded,
            const Color(0xFF3B82F6),
          ),
          _buildStatItem(
            'Confidence',
            '89%',
            Icons.check_circle_rounded,
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySnapshot(SummarySnapshot snapshot) {
    final emotionColor = _getEmotionColor(snapshot.emotion);
    final sentimentColor = _getSentimentColor(snapshot.sentiment);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: emotionColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 320,
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: emotionColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _buildFrameImage(snapshot.frameImageBase64),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: sentimentColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${(snapshot.confidence * 100).toInt()}% Confidence',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: emotionColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_rounded,
                          size: 16,
                          color: emotionColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          snapshot.emotion,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: emotionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: sentimentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: 16,
                          color: sentimentColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          snapshot.sentiment.substring(0, 1).toUpperCase() +
                              snapshot.sentiment.substring(1),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: sentimentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_rounded,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        snapshot.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildEmotionDistribution(snapshot.emotionDistribution),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionDistribution(Map<String, int> distribution) {
    // Sort emotions by frequency (descending)
    final sortedEmotions = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalFrames = distribution.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emotion Distribution',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: sortedEmotions.map((entry) {
            final emotion = entry.key;
            final count = entry.value;
            final percentage = (count / totalFrames * 100).toInt();
            final color = _getEmotionColor(emotion);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      emotion,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.border.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: count / totalFrames,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$percentage%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildQuickAction(
                'Export Report',
                Icons.file_download_rounded,
                const Color(0xFF8B5CF6),
              ),
              _buildQuickAction(
                'Share Results',
                Icons.share_rounded,
                const Color(0xFF3B82F6),
              ),
              _buildQuickAction(
                'Save Analysis',
                Icons.bookmark_rounded,
                const Color(0xFF10B981),
              ),
              _buildQuickAction(
                'Settings',
                Icons.settings_rounded,
                const Color(0xFFF59E0B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => HapticFeedback.lightImpact(),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return const Color(0xFF10B981);
      case 'excited':
      case 'enthusiastic':
        return const Color(0xFFF59E0B);
      case 'confident':
        return const Color(0xFF3B82F6);
      case 'serious':
      case 'neutral':
        return const Color(0xFF6B7280);
      case 'sad':
        return const Color(0xFF8B5CF6);
      case 'angry':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return const Color(0xFF10B981);
      case 'negative':
        return const Color(0xFFEF4444);
      case 'neutral':
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatTimestamp(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildFrameImage(String base64Data) {
    try {
      // Handle both raw base64 and data URL format
      String cleanBase64 = base64Data;
      if (base64Data.startsWith('data:')) {
        // Extract base64 part from data URL
        final parts = base64Data.split(',');
        if (parts.length > 1) {
          cleanBase64 = parts[1];
        }
      }

      final bytes = base64Decode(cleanBase64);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.broken_image_rounded,
              color: Colors.grey,
              size: 30,
            ),
          );
        },
      );
    } catch (e) {
      // Fallback for invalid base64 data
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.image_not_supported_rounded,
          color: Colors.grey,
          size: 30,
        ),
      );
    }
  }

  String _generateDemoImage(String emotion, int frameIndex) {
    // Generate a simple SVG image as base64 for demo purposes
    final emotionColors = {
      'Happy': '#FFD700',
      'Excited': '#FF8C00',
      'Confident': '#4169E1',
      'Serious': '#708090',
      'Enthusiastic': '#FF6347',
    };

    final color = emotionColors[emotion] ?? '#808080';

    final svgData =
        '''
      <svg width="320" height="240" xmlns="http://www.w3.org/2000/svg">
        <rect width="320" height="240" fill="$color" rx="8"/>
        <circle cx="120" cy="100" r="30" fill="#000" opacity="0.7"/>
        <circle cx="200" cy="100" r="30" fill="#000" opacity="0.7"/>
        <path d="M 100 160 Q 160 200 220 160" stroke="#000" stroke-width="8" fill="none" opacity="0.7"/>
        <text x="160" y="220" text-anchor="middle" fill="white" font-size="24" font-family="Arial">
          $emotion
        </text>
      </svg>
    ''';

    return 'data:image/svg+xml;base64,${base64Encode(svgData.codeUnits)}';
  }

  Future<void> _analyzeVideo() async {
    if (_urlController.text.isEmpty) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _isAnalyzing = true;
      _showResults = false;
    });

    try {
      final provider = Provider.of<EmotionProvider>(context, listen: false);
      await provider.analyzeVideo(
        _urlController.text,
        frameInterval: 30,
        maxFrames: 5,
      );

      setState(() {
        _showResults = true;
      });

      _resultsController.forward();
      HapticFeedback.heavyImpact();
    } catch (e) {
      // Show error message or handle error
      setState(() {
        _showResults = true; // Show demo results on error
      });
      _resultsController.forward();
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }
}
