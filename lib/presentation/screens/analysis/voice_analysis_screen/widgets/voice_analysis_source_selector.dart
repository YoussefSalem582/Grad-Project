import 'package:flutter/material.dart';

/// Widget for selecting audio source type
class VoiceAnalysisSourceSelector extends StatelessWidget {
  final String selectedSource;
  final ValueChanged<String> onSourceChanged;

  const VoiceAnalysisSourceSelector({
    super.key,
    required this.selectedSource,
    required this.onSourceChanged,
  });

  static const List<Map<String, dynamic>> audioSources = [
    {
      'value': 'upload',
      'label': 'Upload File',
      'icon': Icons.upload_file,
      'description': 'Select audio file from device',
    },
    {
      'value': 'record',
      'label': 'Record Audio',
      'icon': Icons.mic,
      'description': 'Record live audio',
    },
    {
      'value': 'call',
      'label': 'Call Recording',
      'icon': Icons.phone,
      'description': 'Access recorded calls',
    },
  ];

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
            audioSources.map((source) {
              final isSelected = selectedSource == source['value'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSourceChanged(source['value'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          source['icon'] as IconData,
                          color:
                              isSelected
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF64748B),
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          source['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? const Color(0xFF3B82F6)
                                    : const Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
