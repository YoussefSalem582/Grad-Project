import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../../data/models/video_analysis_response.dart';
import '../../../../cubit/video_analysis/video_analysis_cubit.dart';

/// Enhanced Video Analysis Results with Improved Snapshot Display
///
/// Features:
/// - Optimized image loading with error handling
/// - Smooth animations with clamped opacity values
/// - Enhanced snapshot display with proper aspect ratios
/// - Real-time emotion detection feedback
/// - Comprehensive error handling and fallbacks
class VideoAnalysisResults extends StatelessWidget {
  final AnimationController resultsController;

  const VideoAnalysisResults({super.key, required this.resultsController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoAnalysisCubit, VideoAnalysisState>(
      listener: (context, state) {
        if (state is VideoAnalysisSuccess || state is VideoAnalysisDemo) {
          resultsController.forward();
        } else if (state is VideoAnalysisError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
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
      animation: resultsController,
      builder: (context, child) {
        return Opacity(
          opacity: resultsController.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - resultsController.value)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultsHeader(),
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

  Widget _buildResultsHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withOpacity(0.1),
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
    );
  }

  Widget _buildCustomerMetrics(VideoAnalysisResponse result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.08),
            const Color(0xFF764BA2).withOpacity(0.08),
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
                color: emotionColor.withOpacity(0.1),
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
              colors: [
                emotionColor.withOpacity(0.05),
                sentimentColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: emotionColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emotion and sentiment display
              Container(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Primary Emotion',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            snapshot.emotion,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: emotionColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: AppColors.border.withOpacity(0.5),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sentiment',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              snapshot.sentiment,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: sentimentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced Video Frame Image Display with Snapshot Features
              if (snapshot.assetImagePath != null) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: emotionColor.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: emotionColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        // Main snapshot image
                        AspectRatio(
                          aspectRatio: 16 / 9, // Standard video aspect ratio
                          child: Image.asset(
                            snapshot.assetImagePath!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                'Error loading asset image: ${snapshot.assetImagePath}',
                              );
                              print('Error details: $error');
                              return _buildImageErrorPlaceholder();
                            },
                          ),
                        ),

                        // Snapshot overlay indicators
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Snapshot',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Emotion indicator overlay
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: emotionColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getEmotionIcon(snapshot.emotion),
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  snapshot.emotion,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Confidence indicator
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: const Color(0xFF10B981),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${(snapshot.confidence * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Enhanced placeholder for missing snapshots
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.1),
                        Colors.grey.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.video_camera_back_outlined,
                            size: 40,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Video Frame Captured',
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Snapshot processing may be unavailable',
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Customer insights summary
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.psychology_rounded,
                            color: Color(0xFF667EEA),
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

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return const Color(0xFF10B981);
      case 'excited':
      case 'enthusiastic':
        return const Color(0xFFF59E0B);
      case 'confident':
      case 'satisfied':
        return const Color(0xFF667EEA);
      case 'neutral':
        return const Color(0xFF6B7280);
      case 'concerned':
      case 'worried':
        return const Color(0xFFF97316);
      case 'frustrated':
      case 'angry':
        return const Color(0xFFEF4444);
      case 'sad':
      case 'disappointed':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF667EEA);
    }
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return Icons.sentiment_very_satisfied;
      case 'excited':
      case 'enthusiastic':
        return Icons.celebration;
      case 'confident':
      case 'satisfied':
        return Icons.sentiment_satisfied;
      case 'neutral':
        return Icons.sentiment_neutral;
      case 'concerned':
      case 'worried':
        return Icons.sentiment_dissatisfied;
      case 'frustrated':
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'sad':
      case 'disappointed':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return const Color(0xFF10B981);
      case 'neutral':
        return const Color(0xFF6B7280);
      case 'negative':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF667EEA);
    }
  }

  /// Build error placeholder for images
  Widget _buildImageErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_camera_back_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Video frame not available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
