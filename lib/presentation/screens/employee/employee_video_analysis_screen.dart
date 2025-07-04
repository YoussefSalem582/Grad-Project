import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import '../../../core/core.dart';
import '../../../data/models/video_analysis_response.dart';
import '../../cubit/video_analysis/video_analysis_cubit.dart';

class EmployeeVideoAnalysisScreen extends StatefulWidget {
  const EmployeeVideoAnalysisScreen({super.key});

  @override
  State<EmployeeVideoAnalysisScreen> createState() =>
      _EmployeeVideoAnalysisScreenState();
}

class _EmployeeVideoAnalysisScreenState
    extends State<EmployeeVideoAnalysisScreen>
    with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();

  late AnimationController _headerController;
  late AnimationController _cardController;
  late AnimationController _resultsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Video Analysis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedHeader(),
              const SizedBox(height: 24),
              _buildVideoUrlInput(),
              const SizedBox(height: 20),
              _buildAnalyzeButton(),
              const SizedBox(height: 24),
              _buildVideoAnalysisResults(),
              const SizedBox(height: 20),
              _buildEmployeeInsights(),
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
          offset: Offset(0, 20 * (1 - _headerAnimation.value)),
          child: Opacity(
            opacity: _headerAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667EEA),
                    Color(0xFF764BA2),
                    Color(0xFF6B73FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.video_library_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Video Analysis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Analyze customer emotions in videos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
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
                    color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.link_rounded,
                    color: Color(0xFF667EEA),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Video URL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _urlFocusNode.hasFocus
                    ? const Color(0xFF667EEA).withValues(alpha: 0.05)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _urlFocusNode.hasFocus
                      ? const Color(0xFF667EEA)
                      : AppColors.border.withValues(alpha: 0.5),
                  width: _urlFocusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: _urlController,
                focusNode: _urlFocusNode,
                decoration: InputDecoration(
                  hintText: 'Enter video URL (YouTube, Vimeo, etc.)',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.video_collection_rounded,
                    color: _urlFocusNode.hasFocus
                        ? const Color(0xFF667EEA)
                        : AppColors.textSecondary,
                    size: 20,
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
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Customer interview videos and feedback sessions',
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
      child: BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
        builder: (context, state) {
          final isLoading = state is VideoAnalysisLoading;

          return Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: canAnalyze && !isLoading
                  ? const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    )
                  : null,
              color: canAnalyze && !isLoading ? null : AppColors.border,
              borderRadius: BorderRadius.circular(14),
              boxShadow: canAnalyze && !isLoading
                  ? [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: canAnalyze && !isLoading ? _analyzeVideo : null,
                child: Center(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Analyzing Customer Video...',
                              style: TextStyle(
                                fontSize: 15,
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
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Analyze Customer Video',
                              style: TextStyle(
                                fontSize: 15,
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
          );
        },
      ),
    );
  }

  Widget _buildVideoAnalysisResults() {
    return BlocConsumer<VideoAnalysisCubit, VideoAnalysisState>(
      listener: (context, state) {
        if (state is VideoAnalysisSuccess || state is VideoAnalysisDemo) {
          _resultsController.forward();
          HapticFeedback.heavyImpact();
        } else if (state is VideoAnalysisError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is VideoAnalysisInitial) {
          return const SizedBox.shrink();
        }

        if (state is VideoAnalysisSuccess) {
          return _buildResultsWidget(state.result);
        } else if (state is VideoAnalysisDemo) {
          return _buildResultsWidget(state.demoResult);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildResultsWidget(VideoAnalysisResponse result) {
    return AnimatedBuilder(
      animation: _resultsController,
      builder: (context, child) {
        return Opacity(
          opacity: _resultsController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _resultsController.value)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
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
                          color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.video_library_rounded,
                          color: Color(0xFF667EEA),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Customer Video Analysis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildCustomerMetrics(result),
                  const SizedBox(height: 20),
                  _buildCustomerSnapshot(result.summarySnapshot),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerMetrics(VideoAnalysisResponse result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withValues(alpha: 0.08),
            const Color(0xFF764BA2).withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            'Frames',
            '${result.framesAnalyzed}',
            Icons.image_rounded,
            const Color(0xFF667EEA),
          ),
          _buildMetricItem(
            'Emotion',
            result.dominantEmotion,
            Icons.sentiment_satisfied_rounded,
            const Color(0xFF764BA2),
          ),
          _buildMetricItem(
            'Confidence',
            '${(result.averageConfidence * 100).toInt()}%',
            Icons.verified_rounded,
            const Color(0xFF10B981),
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
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSnapshot(SummarySnapshot snapshot) {
    final emotionColor = _getEmotionColor(snapshot.emotion);
    final sentimentColor = _getSentimentColor(snapshot.sentiment);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: emotionColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.person_rounded, color: emotionColor, size: 16),
            ),
            const SizedBox(width: 10),
            const Text(
              'Customer Emotional State',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Customer emotion analysis card
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                emotionColor.withValues(alpha: 0.05),
                sentimentColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: emotionColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              // Video snapshot with customer focus
              Container(
                margin: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildFrameImage(
                          snapshot.frameImageBase64,
                          snapshot.assetImagePath,
                        ),
                      ),
                    ),
                    // Customer insights overlay
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'CUSTOMER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Confidence indicator
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              sentimentColor,
                              sentimentColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${(snapshot.confidence * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Customer emotion and sentiment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: emotionColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: emotionColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.sentiment_satisfied_rounded,
                              color: emotionColor,
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              snapshot.emotion.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: emotionColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Emotion',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: sentimentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sentimentColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              color: sentimentColor,
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              snapshot.sentiment.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: sentimentColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Sentiment',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Customer insights summary
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF667EEA,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.psychology_rounded,
                            color: const Color(0xFF667EEA),
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Customer Insights',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        height: 1.4,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInsights() {
    return BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
      builder: (context, state) {
        if (state is! VideoAnalysisSuccess && state is! VideoAnalysisDemo) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: Color(0xFF10B981),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Employee Action Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildActionItem(
                'Follow up on customer concerns',
                'Schedule a call to address any issues raised',
                Icons.phone_rounded,
                const Color(0xFF667EEA),
              ),
              const SizedBox(height: 12),
              _buildActionItem(
                'Document customer feedback',
                'Add insights to customer profile and CRM',
                Icons.edit_note_rounded,
                const Color(0xFF764BA2),
              ),
              const SizedBox(height: 12),
              _buildActionItem(
                'Share with team',
                'Discuss findings in next team meeting',
                Icons.people_rounded,
                const Color(0xFF10B981),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
        return const Color(0xFF667EEA);
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

  Widget _buildFrameImage(String base64Data, [String? assetPath]) {
    // Prioritize asset path if available
    if (assetPath != null && assetPath.isNotEmpty) {
      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.broken_image_rounded,
              color: Colors.grey,
              size: 30,
            ),
          );
        },
      );
    }

    // Fallback to base64 if no asset path
    if (base64Data.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_not_supported_rounded,
          color: Colors.grey,
          size: 30,
        ),
      );
    }

    try {
      String cleanBase64 = base64Data;
      if (base64Data.startsWith('data:')) {
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
              borderRadius: BorderRadius.circular(8),
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
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_not_supported_rounded,
          color: Colors.grey,
          size: 30,
        ),
      );
    }
  }

  void _analyzeVideo() {
    if (_urlController.text.isEmpty) return;

    HapticFeedback.mediumImpact();
    context.read<VideoAnalysisCubit>().analyzeVideo(
      videoUrl: _urlController.text,
      frameInterval: 30,
      maxFrames: 5,
    );
  }
}
