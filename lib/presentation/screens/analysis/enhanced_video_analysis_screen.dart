import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../../data/models/video_analysis_response.dart';
import '../../cubit/video_analysis/video_analysis_cubit.dart';
import '../../widgets/widgets.dart';

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

  late AnimationController _fadeController;
  late AnimationController _cardController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _urlFocusNode.addListener(_onFocusChanged);
    _urlController.addListener(_validateUrl);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    );

    _fadeController.forward();
    _cardController.forward();
  }

  @override
  void dispose() {
    _urlFocusNode.removeListener(_onFocusChanged);
    _urlController.removeListener(_validateUrl);
    _urlController.dispose();
    _urlFocusNode.dispose();
    _fadeController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _validateUrl() {
    final url = _urlController.text.trim();
    final isValid =
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://')) &&
        (url.contains('.mp4') ||
            url.contains('.mov') ||
            url.contains('.avi') ||
            url.contains('youtube.com') ||
            url.contains('youtu.be') ||
            url.contains('vimeo.com'));

    if (_isValidUrl != isValid) {
      setState(() {
        _isValidUrl = isValid;
      });
    }
  }

  void _analyzeVideo() {
    if (_urlController.text.trim().isEmpty) {
      _showSnackBar('Please enter a video URL');
      return;
    }

    if (!_isValidUrl) {
      _showSnackBar('Please enter a valid video URL');
      return;
    }

    HapticFeedback.lightImpact();
    context.read<VideoAnalysisCubit>().analyzeVideo(
      videoUrl: _urlController.text.trim(),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _clearUrl() {
    _urlController.clear();
    FocusScope.of(context).unfocus();
  }

  void _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null && clipboardData!.text!.isNotEmpty) {
        _urlController.text = clipboardData.text!;
        _validateUrl();
      }
    } catch (e) {
      _showSnackBar('Failed to paste from clipboard');
    }
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return ScaleTransition(
      scale: _cardAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedBackgroundWidget(animation: _fadeAnimation),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(customSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: customSpacing.xl),
                  _buildHeader(),
                  SizedBox(height: customSpacing.xl),
                  _buildInputSection(),
                  SizedBox(height: customSpacing.lg),
                  _buildResultsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFF6B73FF)],
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
                  'Video Analysis',
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
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildVideoUrlInput(),
        const SizedBox(height: 16),
        _buildAnalyzeButton(),
      ],
    );
  }

  Widget _buildResultsSection() {
    return BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
      builder: (context, state) {
        if (state is VideoAnalysisLoading) {
          return _buildLoadingState();
        } else if (state is VideoAnalysisSuccess) {
          return _buildSuccessState(state.result);
        } else if (state is VideoAnalysisError) {
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildVideoUrlInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _urlFocusNode.hasFocus
              ? AppColors.primary
              : (_isValidUrl
                    ? Colors.green
                    : AppColors.border.withValues(alpha: 0.3)),
          width: _urlFocusNode.hasFocus ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Icon(
                  Icons.link_rounded,
                  color: _urlFocusNode.hasFocus
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Video URL',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _urlFocusNode.hasFocus
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_urlController.text.isNotEmpty)
                  IconButton(
                    onPressed: _clearUrl,
                    icon: Icon(
                      Icons.clear_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              controller: _urlController,
              focusNode: _urlFocusNode,
              decoration: InputDecoration(
                hintText: 'Enter video URL (YouTube, Vimeo, or direct link)',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: _pasteFromClipboard,
                  icon: Icon(
                    Icons.content_paste_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  tooltip: 'Paste from clipboard',
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _analyzeVideo(),
            ),
          ),
          if (_isValidUrl)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Valid video URL detected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
      builder: (context, state) {
        final isLoading = state is VideoAnalysisLoading;

        return Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: _isValidUrl && !isLoading
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  )
                : null,
            color: !_isValidUrl || isLoading ? AppColors.border : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isValidUrl && !isLoading
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isValidUrl && !isLoading ? _analyzeVideo : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Analyzing Video...',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: _isValidUrl
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Analyze Video',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: _isValidUrl
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return _buildAnimatedCard(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Analyzing Video',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Processing video content and detecting emotions...',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            backgroundColor: AppColors.border.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(VideoAnalysisResponse response) {
    return Column(
      children: [
        _buildOverallAnalysis(response),
        const SizedBox(height: 16),
        _buildEmotionDistribution(response),
        const SizedBox(height: 16),
        _buildVideoDetails(response),
      ],
    );
  }

  Widget _buildOverallAnalysis(VideoAnalysisResponse response) {
    final emotion = response.dominantEmotion;
    final confidence = response.averageConfidence;

    Color emotionColor;
    IconData emotionIcon;

    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        emotionColor = Colors.green;
        emotionIcon = Icons.sentiment_very_satisfied_rounded;
        break;
      case 'sad':
      case 'sadness':
        emotionColor = Colors.blue;
        emotionIcon = Icons.sentiment_very_dissatisfied_rounded;
        break;
      case 'angry':
      case 'anger':
        emotionColor = Colors.red;
        emotionIcon = Icons.sentiment_very_dissatisfied_rounded;
        break;
      case 'surprised':
      case 'surprise':
        emotionColor = Colors.orange;
        emotionIcon = Icons.sentiment_satisfied_rounded;
        break;
      default:
        emotionColor = Colors.grey;
        emotionIcon = Icons.sentiment_neutral_rounded;
    }

    return _buildAnimatedCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: emotionColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(emotionIcon, color: emotionColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dominant Emotion',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emotion.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: emotionColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(confidence * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionDistribution(VideoAnalysisResponse response) {
    final emotions = response.summarySnapshot.emotionDistribution;
    if (emotions.isEmpty) return const SizedBox.shrink();

    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emotion Distribution',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          ...emotions.entries.map((entry) {
            final emotionName = entry.key;
            final count = entry.value;
            final total = emotions.values.reduce((a, b) => a + b);
            final percentage = (count / total * 100).toInt();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        emotionName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: count / total,
                    backgroundColor: AppColors.border.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildVideoDetails(VideoAnalysisResponse response) {
    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Analysis Details',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Video URL', _urlController.text),
          _buildDetailRow('Frames Analyzed', '${response.framesAnalyzed}'),
          _buildDetailRow(
            'Average Confidence',
            '${(response.averageConfidence * 100).toInt()}%',
          ),
          _buildDetailRow(
            'Analysis Time',
            DateTime.now().toString().split('.')[0],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return _buildAnimatedCard(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Analysis Failed',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _analyzeVideo(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
