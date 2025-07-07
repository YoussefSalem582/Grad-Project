import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Widget for selecting analysis type and settings
///
/// This widget provides a clean interface for users to:
/// - Select the type of analysis to perform
/// - Configure analysis parameters
/// - Quick access to common settings
class TextAnalysisSettingsWidget extends StatelessWidget {
  final String selectedAnalysisType;
  final List<String> analysisTypes;
  final ValueChanged<String> onAnalysisTypeChanged;

  const TextAnalysisSettingsWidget({
    super.key,
    required this.selectedAnalysisType,
    required this.analysisTypes,
    required this.onAnalysisTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              Icon(Icons.tune, color: AppColors.primary, size: 24),
              SizedBox(width: customSpacing.sm),
              Text(
                'Analysis Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.md),

          // Analysis Type Selector
          Text(
            'Analysis Type',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: customSpacing.sm),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: customSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedAnalysisType,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                items:
                    analysisTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Row(
                          children: [
                            _getAnalysisTypeIcon(type),
                            SizedBox(width: customSpacing.sm),
                            Text(type),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onAnalysisTypeChanged(value);
                  }
                },
              ),
            ),
          ),

          SizedBox(height: customSpacing.md),

          // Quick Settings Chips
          Wrap(
            spacing: customSpacing.sm,
            runSpacing: customSpacing.xs,
            children: [
              _buildSettingChip('Real-time', Icons.speed, true),
              _buildSettingChip('High Accuracy', Icons.verified, false),
              _buildSettingChip('Detailed', Icons.insights, true),
            ],
          ),
        ],
      ),
    );
  }

  /// Get appropriate icon for analysis type
  Widget _getAnalysisTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'Sentiment Analysis':
        icon = Icons.sentiment_satisfied;
        color = Colors.green;
        break;
      case 'Emotion Detection':
        icon = Icons.psychology;
        color = Colors.orange;
        break;
      case 'Topic Classification':
        icon = Icons.category;
        color = Colors.blue;
        break;
      case 'Intent Recognition':
        icon = Icons.lightbulb;
        color = Colors.purple;
        break;
      case 'Language Detection':
        icon = Icons.language;
        color = Colors.teal;
        break;
      default:
        icon = Icons.analytics;
        color = AppColors.primary;
    }

    return Icon(icon, color: color, size: 20);
  }

  /// Build a setting chip widget
  Widget _buildSettingChip(String label, IconData icon, bool isEnabled) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isEnabled ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isEnabled ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      selected: isEnabled,
      onSelected: (selected) {
        // Handle setting toggle
      },
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
    );
  }
}
