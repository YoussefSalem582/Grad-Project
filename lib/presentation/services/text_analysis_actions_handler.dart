import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';

/// Service class to handle all text analysis actions
///
/// This class centralizes all action handlers for the text analysis screen,
/// providing a clean separation between UI and business logic with improved
/// error handling, input validation, and user feedback.
class TextAnalysisActionsHandler {
  final BuildContext context;

  const TextAnalysisActionsHandler(this.context);

  /// Validate input text before processing
  bool _validateText(String? text, {bool showError = true}) {
    if (text == null || text.trim().isEmpty) {
      if (showError) {
        _showErrorMessage('Please enter some text to analyze first.');
      }
      return false;
    }

    if (text.trim().length < 3) {
      if (showError) {
        _showErrorMessage('Text must be at least 3 characters long.');
      }
      return false;
    }

    return true;
  }

  /// Handle sharing analysis results
  void shareResult({String? text, Map<String, dynamic>? result}) {
    HapticFeedback.lightImpact();

    if (!_validateText(text)) {
      return;
    }

    final content = _formatShareContent(text, result);

    try {
      // In a real app, this would use the share package
      Clipboard.setData(ClipboardData(text: content));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Results copied to clipboard'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      _showErrorMessage('Failed to copy results to clipboard.');
    }
  }

  /// Handle saving analysis results
  void saveResult({String? text, Map<String, dynamic>? result}) {
    HapticFeedback.lightImpact();

    if (!_validateText(text)) {
      return;
    }

    try {
      // In a real app, this would save to local storage or server
      // For now, simulate a save operation

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.save, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Analysis result saved successfully'),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      _showErrorMessage('Failed to save analysis results. Please try again.');
    }
  }

  /// Show error message to user
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Navigate to batch processing screen
  void navigateToBatchProcessing() {
    HapticFeedback.lightImpact();

    // For now, show a coming soon message
    _showComingSoonDialog(
      'Batch Processing',
      'Analyze multiple texts simultaneously with advanced batch processing capabilities.',
    );
  }

  /// Export analysis results
  void exportResults() {
    HapticFeedback.lightImpact();

    _showExportDialog();
  }

  /// Navigate to text comparison feature
  void compareTexts() {
    HapticFeedback.lightImpact();

    _showComingSoonDialog(
      'Text Comparison',
      'Compare sentiment and emotions between multiple texts side-by-side.',
    );
  }

  /// Navigate to analysis settings
  void navigateToSettings() {
    HapticFeedback.lightImpact();

    _showSettingsDialog();
  }

  /// Format content for sharing
  String _formatShareContent(String? text, Map<String, dynamic>? result) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('📊 EmoSense AI - Text Analysis Results');
    buffer.writeln('=' * 45);
    buffer.writeln();

    // Original text section
    if (text != null && text.trim().isNotEmpty) {
      buffer.writeln('📝 Original Text:');
      final displayText =
          text.length > 200 ? '${text.substring(0, 200)}...' : text;
      buffer.writeln(displayText);
      buffer.writeln();
    }

    // Analysis results section
    if (result != null && result.isNotEmpty) {
      buffer.writeln('🔍 Analysis Results:');
      buffer.writeln('-' * 25);

      // Sort and format results
      final sortedEntries =
          result.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

      for (final entry in sortedEntries) {
        final key = _formatResultKey(entry.key);
        final value = _formatResultValue(entry.value);
        buffer.writeln('• $key: $value');
      }
      buffer.writeln();
    } else {
      buffer.writeln('⚠️ No analysis results available');
      buffer.writeln();
    }

    // Footer
    buffer.writeln('Generated by EmoSense AI');
    buffer.writeln('${DateTime.now().toString().split('.')[0]}');

    return buffer.toString();
  }

  /// Format result key for better readability
  String _formatResultKey(String key) {
    return key
        .split(RegExp(r'[_\s]+'))
        .map(
          (word) =>
              word.isEmpty
                  ? ''
                  : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  /// Format result value for better display
  String _formatResultValue(dynamic value) {
    if (value == null) return 'N/A';

    if (value is double) {
      return (value * 100).toStringAsFixed(1) + '%';
    } else if (value is num) {
      return value.toString();
    } else if (value is List) {
      return value.join(', ');
    } else if (value is Map) {
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    } else {
      return value.toString();
    }
  }

  /// Show coming soon dialog
  void _showComingSoonDialog(String feature, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.rocket_launch, color: AppColors.warning, size: 28),
              const SizedBox(width: 12),
              Text(feature),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'This feature is coming soon in the next update!',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }

  /// Show export options dialog
  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.file_download, color: AppColors.secondary, size: 28),
              const SizedBox(width: 12),
              const Text('Export Results'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExportOption(
                Icons.description,
                'PDF Report',
                'Complete analysis report',
              ),
              _buildExportOption(
                Icons.table_chart,
                'CSV Data',
                'Raw data for spreadsheets',
              ),
              _buildExportOption(
                Icons.code,
                'JSON Export',
                'Structured data format',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build export option widget
  Widget _buildExportOption(IconData icon, String title, String description) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        Navigator.of(context).pop();

        try {
          HapticFeedback.selectionClick();

          // Simulate export process
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Preparing $title...'),
                ],
              ),
              backgroundColor: AppColors.secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );

          // Simulate completion after delay
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.download_done,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text('$title export completed'),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          });
        } catch (e) {
          _showErrorMessage('Export failed. Please try again.');
        }
      },
    );
  }

  /// Show settings dialog
  void _showSettingsDialog() {
    // Settings state variables
    bool autoSave = true;
    bool highAccuracy = false;
    bool realTimeAnalysis = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.settings, color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  const Text('Analysis Settings'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Auto-save results'),
                    subtitle: const Text('Automatically save analysis results'),
                    value: autoSave,
                    onChanged: (value) {
                      setState(() {
                        autoSave = value;
                      });
                      HapticFeedback.selectionClick();
                    },
                    activeColor: AppColors.primary,
                  ),
                  SwitchListTile(
                    title: const Text('High accuracy mode'),
                    subtitle: const Text(
                      'Use advanced models for better accuracy',
                    ),
                    value: highAccuracy,
                    onChanged: (value) {
                      setState(() {
                        highAccuracy = value;
                      });
                      HapticFeedback.selectionClick();
                    },
                    activeColor: AppColors.primary,
                  ),
                  SwitchListTile(
                    title: const Text('Real-time analysis'),
                    subtitle: const Text('Analyze text as you type'),
                    value: realTimeAnalysis,
                    onChanged: (value) {
                      setState(() {
                        realTimeAnalysis = value;
                      });
                      HapticFeedback.selectionClick();
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.settings, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text('Settings updated successfully'),
                          ],
                        ),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
