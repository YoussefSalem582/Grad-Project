import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../cubit/video_analysis/video_analysis_cubit.dart';

/// Widget that provides sample video URLs for testing
class VideoSampleLinksWidget extends StatelessWidget {
  final TextEditingController urlController;
  final Animation<double> animation;
  final VoidCallback? onSampleSelected;

  const VideoSampleLinksWidget({
    super.key,
    required this.urlController,
    required this.animation,
    this.onSampleSelected,
  });

  static const List<Map<String, String>> sampleLinks = [
    {
      'title': 'Happy Customer Review',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'description': 'Positive customer feedback video',
      'icon': '😊',
    },
    {
      'title': 'Product Demonstration',
      'url': 'https://www.youtube.com/watch?v=ScMzIvxBSi4',
      'description': 'Product showcase and features',
      'icon': '📱',
    },
    {
      'title': 'Customer Testimonial',
      'url': 'https://www.youtube.com/watch?v=9bZkp7q19f0',
      'description': 'Mixed emotions testimonial',
      'icon': '💬',
    },
    {
      'title': 'Service Review',
      'url': 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
      'description': 'Service experience review',
      'icon': '⭐',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
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
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.play_circle_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Sample Videos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try these sample videos to test the analysis',
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  ...sampleLinks.map(
                    (sample) => _buildSampleTile(context, sample),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSampleTile(BuildContext context, Map<String, String> sample) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _selectSample(context, sample['url']!),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      sample['icon']!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sample['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sample['description']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.content_copy,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _triggerDemoAnalysis(BuildContext context) {
    // Clear any existing URL
    urlController.clear();

    // Trigger demo analysis directly
    context.read<VideoAnalysisCubit>().loadDemoData('demo_video');

    // Show info message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Running demo analysis with sample data'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    HapticFeedback.mediumImpact();
  }

  void _selectSample(BuildContext context, String url) {
    urlController.text = url;
    onSampleSelected?.call();

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sample video URL added'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
