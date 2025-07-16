import 'package:flutter/material.dart';

/// Widget for direct text input
class TextAnalysisInputSection extends StatelessWidget {
  final TextEditingController textController;
  final FocusNode textFocusNode;
  final String selectedSourceType;

  const TextAnalysisInputSection({
    super.key,
    required this.textController,
    required this.textFocusNode,
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
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_note,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Text Input',
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
            child: TextField(
              controller: textController,
              focusNode: textFocusNode,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: _getHintText(),
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF3B82F6),
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }

  String _getHintText() {
    switch (selectedSourceType) {
      case 'YouTube Comments':
        return 'Paste YouTube comments here...\n\nExample:\nUser1: Great video!\nUser2: Thanks for the explanation\nUser3: This helped a lot';
      case 'Amazon Reviews':
        return 'Paste Amazon product reviews here...\n\nExample:\n⭐⭐⭐⭐⭐ Great product!\nThe quality exceeded my expectations...';
      default:
        return 'Enter your text here for analysis...';
    }
  }
}
