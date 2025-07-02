import 'package:flutter/material.dart';
import '../../../core/core.dart';

class EmotionInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  const EmotionInputField({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: const TextStyle(fontSize: 16),
        onSubmitted: (_) => onSubmitted?.call(),
        decoration: InputDecoration(
          labelText: AppStrings.inputLabel,
          labelStyle: const TextStyle(color: AppColors.primary),
          hintText: AppStrings.inputHint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_note, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
