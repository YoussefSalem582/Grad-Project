import 'package:flutter/material.dart';
import '../../../core/core.dart';

class VideoInputWidget extends StatelessWidget {
  final TextEditingController urlController;
  final FocusNode urlFocusNode;
  final bool isValidUrl;
  final bool isAnalyzing;
  final String selectedAnalysisType;
  final List<String> analysisTypes;
  final VoidCallback? onAnalyze;
  final VoidCallback? onClear;
  final Function(String) onAnalysisTypeChanged;
  final Map<String, dynamic>? analysisResult;

  const VideoInputWidget({
    super.key,
    required this.urlController,
    required this.urlFocusNode,
    required this.isValidUrl,
    required this.isAnalyzing,
    required this.selectedAnalysisType,
    required this.analysisTypes,
    required this.onAnalysisTypeChanged,
    this.onAnalyze,
    this.onClear,
    this.analysisResult,
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.video_camera_back,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Analysis Input',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: customSpacing.xs),
                    Text(
                      'Upload or provide a video URL for AI analysis',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: customSpacing.xl),

          // Analysis Type Selector
          _buildAnalysisTypeSelector(theme, customSpacing),

          SizedBox(height: customSpacing.lg),

          // URL Input Section
          _buildUrlInputSection(theme, customSpacing),

          SizedBox(height: customSpacing.lg),

          // Action Buttons
          _buildActionButtons(theme, customSpacing),
        ],
      ),
    );
  }

  Widget _buildAnalysisTypeSelector(ThemeData theme, CustomSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, color: AppColors.primary, size: 20),
            SizedBox(width: spacing.sm),
            Text(
              'Analysis Type',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.md),
        Container(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedAnalysisType,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) => onAnalysisTypeChanged(value!),
              items: analysisTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      _getAnalysisTypeIcon(type),
                      SizedBox(width: spacing.sm),
                      Text(type),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUrlInputSection(ThemeData theme, CustomSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link, color: AppColors.primary, size: 20),
            SizedBox(width: spacing.sm),
            Text(
              'Video URL or Upload',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.md),

        // Upload area with drag & drop styling
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: urlFocusNode.hasFocus
                  ? AppColors.primary
                  : isValidUrl
                  ? AppColors.success
                  : AppColors.primary.withValues(alpha: 0.2),
              width: urlFocusNode.hasFocus ? 2 : 1.5,
            ),
            boxShadow: [
              if (urlFocusNode.hasFocus)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            children: [
              // Drag & Drop Area
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(spacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                    SizedBox(height: spacing.md),
                    Text(
                      'Drag & drop video file here',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      'Supports MP4, MOV, AVI (Max 100MB)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    ElevatedButton.icon(
                      onPressed: () => _selectVideoFile(),
                      icon: Icon(Icons.folder_open),
                      label: Text('Browse Files'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.lg,
                          vertical: spacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // OR Divider
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.textSecondary)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.md),
                      child: Text(
                        'OR',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.textSecondary)),
                  ],
                ),
              ),

              // URL Input
              Padding(
                padding: EdgeInsets.all(spacing.md),
                child: TextField(
                  controller: urlController,
                  focusNode: urlFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter video URL (YouTube, Vimeo, direct link)',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(spacing.md),
                    prefixIcon: Icon(Icons.link, color: AppColors.primary),
                    suffixIcon: isValidUrl
                        ? Icon(Icons.check_circle, color: AppColors.success)
                        : null,
                  ),
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, CustomSpacing spacing) {
    return Row(
      children: [
        if (analysisResult != null) ...[
          Expanded(
            child: _buildActionButton(
              label: 'Clear',
              icon: Icons.clear,
              color: AppColors.error,
              onTap: onClear,
              spacing: spacing,
            ),
          ),
          SizedBox(width: spacing.md),
        ],
        Expanded(
          flex: 2,
          child: _buildActionButton(
            label: isAnalyzing ? 'Analyzing Video...' : 'Start Analysis',
            icon: isAnalyzing ? Icons.hourglass_empty : Icons.play_arrow,
            color: AppColors.primary,
            onTap: isValidUrl && !isAnalyzing ? onAnalyze : null,
            isLoading: isAnalyzing,
            spacing: spacing,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    bool isLoading = false,
    required CustomSpacing spacing,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [color, color.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: !isEnabled ? color.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: 22),
            SizedBox(width: spacing.sm),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAnalysisTypeIcon(String type) {
    switch (type) {
      case 'Full Analysis':
        return Icon(Icons.analytics, color: AppColors.primary, size: 18);
      case 'Facial Expression':
        return Icon(Icons.face, color: AppColors.success, size: 18);
      case 'Body Language':
        return Icon(Icons.accessibility, color: AppColors.warning, size: 18);
      case 'Engagement Level':
        return Icon(Icons.timeline, color: AppColors.secondary, size: 18);
      case 'Presentation Quality':
        return Icon(Icons.present_to_all, color: AppColors.info, size: 18);
      default:
        return Icon(
          Icons.video_camera_back,
          color: AppColors.primary,
          size: 18,
        );
    }
  }

  void _selectVideoFile() {
    // Implement file picker functionality
  }
}
