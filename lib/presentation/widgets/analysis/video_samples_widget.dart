import 'package:flutter/material.dart';
import '../../../core/core.dart';

class VideoSamplesWidget extends StatelessWidget {
  final List<VideoSample> sampleVideos;
  final Function(String) onSampleSelected;

  const VideoSamplesWidget({
    super.key,
    required this.sampleVideos,
    required this.onSampleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
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
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.video_library,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Videos',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: customSpacing.xs),
                    Text(
                      'Try our pre-selected demo videos',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // View All Button
              TextButton(
                onPressed: () => _showAllSamples(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.md,
                    vertical: customSpacing.sm,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View All'),
                    SizedBox(width: customSpacing.xs),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: customSpacing.xl),

          // Sample Videos Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: customSpacing.md,
              mainAxisSpacing: customSpacing.md,
              childAspectRatio: 1.2,
            ),
            itemCount: sampleVideos.length > 4 ? 4 : sampleVideos.length,
            itemBuilder: (context, index) {
              final video = sampleVideos[index];
              return _buildVideoSampleCard(video, theme, customSpacing);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSampleCard(
    VideoSample video,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return GestureDetector(
      onTap: () => onSampleSelected(video.url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background/Thumbnail
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      video.category.color,
                      video.category.color.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: video.thumbnailUrl != null
                    ? Image.network(
                        video.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultThumbnail(video, spacing),
                      )
                    : _buildDefaultThumbnail(video, spacing),
              ),

              // Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                        vertical: spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            video.category.icon,
                            size: 12,
                            color: video.category.color,
                          ),
                          SizedBox(width: spacing.xs),
                          Text(
                            video.category.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: video.category.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Play Button
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: video.category.color,
                          size: 24,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Title and Duration
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 12,
                            ),
                            SizedBox(width: spacing.xs),
                            Text(
                              video.duration,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultThumbnail(VideoSample video, CustomSpacing spacing) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            video.category.icon,
            color: Colors.white.withValues(alpha: 0.8),
            size: 32,
          ),
          SizedBox(height: spacing.sm),
          Text(
            video.category.name,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllSamples(BuildContext context) {
    // Navigate to all samples screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AllSamplesBottomSheet(
        sampleVideos: sampleVideos,
        onSampleSelected: onSampleSelected,
      ),
    );
  }
}

class _AllSamplesBottomSheet extends StatelessWidget {
  final List<VideoSample> sampleVideos;
  final Function(String) onSampleSelected;

  const _AllSamplesBottomSheet({
    required this.sampleVideos,
    required this.onSampleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                  'Sample Videos',
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

          // Videos List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
              itemCount: sampleVideos.length,
              itemBuilder: (context, index) {
                final video = sampleVideos[index];
                return _buildVideoListItem(
                  video,
                  theme,
                  customSpacing,
                  context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoListItem(
    VideoSample video,
    ThemeData theme,
    CustomSpacing spacing,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(spacing.md),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: video.category.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            video.category.icon,
            color: video.category.color,
            size: 24,
          ),
        ),
        title: Text(
          video.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacing.xs),
            Text(
              video.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.xs),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: video.category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    video.category.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: video.category.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: spacing.sm),
                Text(
                  video.duration,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            onSampleSelected(video.url);
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.play_circle_fill,
            color: AppColors.primary,
            size: 32,
          ),
        ),
      ),
    );
  }
}

// Data Models
class VideoSample {
  final String id;
  final String title;
  final String description;
  final String url;
  final String duration;
  final String? thumbnailUrl;
  final VideoCategory category;

  const VideoSample({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.duration,
    this.thumbnailUrl,
    required this.category,
  });
}

class VideoCategory {
  final String name;
  final IconData icon;
  final Color color;

  const VideoCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  static const presentation = VideoCategory(
    name: 'Presentation',
    icon: Icons.present_to_all,
    color: AppColors.primary,
  );

  static const interview = VideoCategory(
    name: 'Interview',
    icon: Icons.people,
    color: AppColors.secondary,
  );

  static const training = VideoCategory(
    name: 'Training',
    icon: Icons.school,
    color: AppColors.success,
  );

  static const feedback = VideoCategory(
    name: 'Feedback',
    icon: Icons.feedback,
    color: AppColors.warning,
  );
}
