import 'package:flutter/material.dart';

/// Widget for selecting the source type (Direct Text, YouTube Comments, etc.)
class TextAnalysisModeSelector extends StatelessWidget {
  final List<String> sourceTypes;
  final String selectedSourceType;
  final Function(String) onSourceTypeChanged;

  const TextAnalysisModeSelector({
    super.key,
    required this.sourceTypes,
    required this.selectedSourceType,
    required this.onSourceTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children:
            sourceTypes.map((type) {
              final isSelected = selectedSourceType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSourceTypeChanged(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Text(
                      type,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected
                                ? const Color(0xFF1E293B)
                                : const Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
