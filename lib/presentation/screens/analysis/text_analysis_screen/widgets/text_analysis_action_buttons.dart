import 'package:flutter/material.dart';

/// Widget for action buttons (analyze, clear, etc.)
class TextAnalysisActionButtons extends StatelessWidget {
  final bool isAnalyzing;
  final bool hasText;
  final VoidCallback onAnalyze;
  final VoidCallback onClear;
  final VoidCallback? onImportFromUrl;
  final String selectedSourceType;

  const TextAnalysisActionButtons({
    super.key,
    required this.isAnalyzing,
    required this.hasText,
    required this.onAnalyze,
    required this.onClear,
    this.onImportFromUrl,
    required this.selectedSourceType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Primary Analyze Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: hasText && !isAnalyzing ? onAnalyze : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isAnalyzing
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Analyzing...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.analytics, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Analyze Text',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                // Clear Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: hasText && !isAnalyzing ? onClear : null,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFEF4444),
                        width: 1.5,
                      ),
                      foregroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.clear, size: 18),
                        const SizedBox(width: 6),
                        const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Import from URL button (conditional)
            if (onImportFromUrl != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: !isAnalyzing ? onImportFromUrl : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF10B981),
                      width: 1.5,
                    ),
                    foregroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.download, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _getImportButtonText(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Action Description
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF3B82F6),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasText
                          ? 'Ready to analyze your ${selectedSourceType.toLowerCase()}'
                          : 'Enter text or import from URL to begin analysis',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImportButtonText() {
    switch (selectedSourceType) {
      case 'YouTube Comments':
        return 'Import YouTube Comments';
      case 'Amazon Reviews':
        return 'Import Amazon Reviews';
      default:
        return 'Import from URL';
    }
  }
}
