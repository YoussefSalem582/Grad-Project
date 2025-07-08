import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

/// Video URL input widget with animations and validation
class VideoUrlInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Animation<double> animation;
  final VoidCallback onChanged;

  const VideoUrlInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.animation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.link_rounded,
                    color: Color(0xFF667EEA),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Video URL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    focusNode.hasFocus
                        ? const Color(0xFF667EEA).withValues(alpha: 0.05)
                        : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      focusNode.hasFocus
                          ? const Color(0xFF667EEA)
                          : AppColors.border.withValues(alpha: 0.5),
                  width: focusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter video URL (YouTube, Vimeo, etc.)',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.video_collection_rounded,
                    color:
                        focusNode.hasFocus
                            ? const Color(0xFF667EEA)
                            : AppColors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon:
                      controller.text.isNotEmpty
                          ? GestureDetector(
                            onTap: () {
                              controller.clear();
                              onChanged();
                            },
                            child: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.textSecondary,
                            ),
                          )
                          : null,
                ),
                onChanged: (value) => onChanged(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Customer interview videos and feedback sessions',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
