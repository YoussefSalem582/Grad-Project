import 'package:flutter/material.dart';

/// Widget for displaying sample texts
class TextAnalysisSamplesSection extends StatelessWidget {
  final String selectedSourceType;
  final Function(String) onSampleTapped;

  const TextAnalysisSamplesSection({
    super.key,
    required this.selectedSourceType,
    required this.onSampleTapped,
  });

  @override
  Widget build(BuildContext context) {
    final samples = _getSamplesForSourceType();

    if (samples.isEmpty) return const SizedBox.shrink();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC4899).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFEC4899),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Sample Texts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children:
                  samples.map((sample) => _buildSampleCard(sample)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleCard(Map<String, String> sample) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: () => onSampleTapped(sample['text']!),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sample['type']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFEC4899),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.touch_app,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                sample['text']!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF475569),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getSamplesForSourceType() {
    switch (selectedSourceType) {
      case 'YouTube Comments':
        return [
          {
            'type': 'Positive',
            'text':
                'This video is absolutely amazing! Thanks for such clear explanations. Really helped me understand the concept better. Keep up the great work! 👍',
          },
          {
            'type': 'Mixed',
            'text':
                'Good content overall but the audio quality could be better. The information is valuable though. Would love to see more videos like this.',
          },
          {
            'type': 'Negative',
            'text':
                'Disappointed with this video. The explanation was confusing and I couldn\'t follow along. Maybe add more examples next time?',
          },
        ];
      case 'Amazon Reviews':
        return [
          {
            'type': 'Positive',
            'text':
                '⭐⭐⭐⭐⭐ Excellent product! Exceeded my expectations. Fast delivery and great packaging. Highly recommend to anyone looking for quality.',
          },
          {
            'type': 'Mixed',
            'text':
                '⭐⭐⭐ Decent product for the price. Some features work well but others could be improved. Customer service was helpful when I had questions.',
          },
          {
            'type': 'Negative',
            'text':
                '⭐⭐ Not satisfied with this purchase. Product quality is poor and doesn\'t match the description. Requesting a refund.',
          },
        ];
      case 'Social Media Posts':
        return [
          {
            'type': 'Positive',
            'text':
                'Having such a wonderful day! The weather is perfect and spending time with family. Grateful for these beautiful moments. #blessed #family',
          },
          {
            'type': 'Mixed',
            'text':
                'Work has been challenging lately but learning a lot. Some days are tough but the team is supportive. Looking forward to the weekend.',
          },
          {
            'type': 'Negative',
            'text':
                'Really frustrated with the service today. Waited for hours and nothing got resolved. This is becoming a regular issue. #disappointed',
          },
        ];
      default:
        return [];
    }
  }
}
