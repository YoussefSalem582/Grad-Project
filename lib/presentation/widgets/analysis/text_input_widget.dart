import 'package:flutter/material.dart';
import '../../../core/core.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController textController;
  final bool isAnalyzing;
  final String selectedAnalysisType;
  final List<String> analysisTypes;
  final VoidCallback? onAnalyze;
  final VoidCallback? onClear;
  final Function(String) onAnalysisTypeChanged;
  final Map<String, dynamic>? analysisResult;
  final int? characterLimit;
  final bool showWordCount;

  const TextInputWidget({
    super.key,
    required this.textController,
    required this.isAnalyzing,
    required this.selectedAnalysisType,
    required this.analysisTypes,
    required this.onAnalysisTypeChanged,
    this.onAnalyze,
    this.onClear,
    this.analysisResult,
    this.characterLimit = 5000,
    this.showWordCount = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;
    final currentLength = textController.text.length;
    final wordCount = textController.text.trim().isEmpty
        ? 0
        : textController.text.trim().split(RegExp(r'\s+')).length;
    final hasText = textController.text.trim().isNotEmpty;

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
                  Icons.text_fields,
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
                      'Text Analysis Input',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: customSpacing.xs),
                    Text(
                      'Enter text to analyze emotions, sentiment, and insights',
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

          // Text Input Section
          _buildTextInputSection(
            theme,
            customSpacing,
            currentLength,
            wordCount,
          ),

          SizedBox(height: customSpacing.lg),

          // Action Buttons
          _buildActionButtons(theme, customSpacing, hasText),
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
            Icon(Icons.analytics, color: AppColors.primary, size: 20),
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

  Widget _buildTextInputSection(
    ThemeData theme,
    CustomSpacing spacing,
    int currentLength,
    int wordCount,
  ) {
    final isOverLimit =
        characterLimit != null && currentLength > characterLimit!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.edit_note, color: AppColors.primary, size: 20),
            SizedBox(width: spacing.sm),
            Text(
              'Text Content',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (showWordCount)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$wordCount words',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: spacing.md),

        // Enhanced text input area
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOverLimit
                  ? AppColors.error
                  : textController.text.isNotEmpty
                  ? AppColors.success.withValues(alpha: 0.5)
                  : AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Main text input
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText:
                      'Type or paste your text here for analysis...\n\nExample:\n"Thank you for your excellent service! I\'m very satisfied with the quality of work and professionalism shown by your team."',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(spacing.lg),
                ),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  height: 1.6,
                ),
                maxLines: 8,
                minLines: 6,
                textInputAction: TextInputAction.newline,
              ),

              // Character count and limit
              if (characterLimit != null)
                Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isOverLimit ? Icons.warning : Icons.info_outline,
                        color: isOverLimit
                            ? AppColors.error
                            : AppColors.textSecondary,
                        size: 16,
                      ),
                      SizedBox(width: spacing.xs),
                      Text(
                        '$currentLength / $characterLimit characters',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isOverLimit
                              ? AppColors.error
                              : AppColors.textSecondary,
                          fontWeight: isOverLimit
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (textController.text.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => textController.clear(),
                          icon: Icon(Icons.clear, size: 16),
                          label: Text('Clear'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.sm,
                              vertical: spacing.xs,
                            ),
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

  Widget _buildActionButtons(
    ThemeData theme,
    CustomSpacing spacing,
    bool hasText,
  ) {
    return Row(
      children: [
        if (analysisResult != null) ...[
          Expanded(
            child: _buildActionButton(
              label: 'Clear Results',
              icon: Icons.refresh,
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
            label: isAnalyzing ? 'Analyzing Text...' : 'Start Analysis',
            icon: isAnalyzing ? Icons.hourglass_empty : Icons.psychology,
            color: AppColors.primary,
            onTap: hasText && !isAnalyzing ? onAnalyze : null,
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
      case 'Sentiment Analysis':
        return Icon(
          Icons.sentiment_satisfied,
          color: AppColors.primary,
          size: 18,
        );
      case 'Emotion Detection':
        return Icon(Icons.psychology, color: AppColors.success, size: 18);
      case 'Topic Classification':
        return Icon(Icons.category, color: AppColors.warning, size: 18);
      case 'Intent Recognition':
        return Icon(Icons.lightbulb, color: AppColors.secondary, size: 18);
      case 'Language Detection':
        return Icon(Icons.language, color: AppColors.info, size: 18);
      default:
        return Icon(Icons.text_fields, color: AppColors.primary, size: 18);
    }
  }
}
